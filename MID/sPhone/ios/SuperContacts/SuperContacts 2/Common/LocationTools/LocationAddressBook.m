//
//  LocationAddressBook.m
//  SuperContacts
//
//  Created by wlpiaoyi on 3/17/14.
//  Copyright (c) 2014 wlpiaoyi. All rights reserved.
//

#import "LocationAddressBook.h"

@implementation LocationAddressBook{
@private
    ABAddressBookRef addressBook;
}
-(id) init{
    //如果没有授权则返回空
    if(self = [super init]){
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            //等待同意后向下执行
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                     {
                                                         dispatch_semaphore_signal(sema);
                                                     });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            dispatch_release(sema);
        }
        else
        {
            addressBook = ABAddressBookCreate();
        }
        if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
        {return nil;}
        return self;
    }else{return nil;}
}
/**
 查询出对应的记录
 */
- (NSMutableArray*) queryContentByName:(NSString*)searchText
{
    NSMutableArray *listContacts;
    if(!searchText||searchText==nil||[searchText length]==0)
    {
        //查询所有
        listContacts = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(self->addressBook));
    } else {
        //条件查询
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        listContacts = CFBridgingRelease(ABAddressBookCopyPeopleWithName(self->addressBook, cfSearchText));
        CFRelease(cfSearchText);
    }
    NSMutableArray *listContactsTemp = [[NSMutableArray alloc]init];
    @try {
        for (id X in listContacts) {
            ABRecordRef thisPerson = CFBridgingRetain(X);
            NSMutableDictionary *json = [self findContent:thisPerson CheckParams:nil];
            [json setValue:X forKey:@"recordKey"];
            [listContactsTemp addObject:json];
            CFRelease(thisPerson);
        }
    }
    @finally {
        [listContacts removeAllObjects];
    }
    return listContactsTemp;
}

/**
 查询出对应的记录
 */
- (NSMutableArray*) queryContentByParams:(NSString*) params
{
    //查询所有
    NSMutableArray *listContacts = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(self->addressBook));
    NSMutableArray *listContactsTemp = [[NSMutableArray alloc]init];
    @try {
        for (id X in listContacts) {
            ABRecordRef thisPerson = CFBridgingRetain(X);
            NSMutableDictionary *json = [self findContent:thisPerson CheckParams:params];
            if(json){
                [json setValue:X forKey:@"recordKey"];
                [listContactsTemp addObject:json];
            }
            CFRelease(thisPerson);
        }
    }
    @finally {
        [listContacts removeAllObjects];
    }
    return listContactsTemp;
}
/**
 新增通信录
 */
-(ABRecordRef) persistContent:(NSDictionary*) jsonContent{
    
    // 创建一条空的联系人
    ABRecordRef userRef = ABPersonCreate();
    bool success = [self  setAllValues:jsonContent UserRef:userRef];
    if (!success) return nil;
    return userRef;
}
/**
 更新通信录
 */
-(bool) mergeContent:(NSDictionary*) jsonContent UserRef:(ABRecordRef) userRef{
    bool success = [self  setAllValues:jsonContent UserRef:userRef];
    if (!success) return false;
    return true;
}
/**
 删除记录
 */
-(bool) removeContent:(ABRecordRef) recordRef{
    bool success = ABAddressBookRemoveRecord(addressBook, recordRef, NULL);
    [self commiteAddRecode:recordRef];
    return success;
}
/**
 得到记录
 */
-(NSMutableDictionary*) findContent:(ABRecordRef) thisPerson CheckParams:(NSString*) checkParams
{
    NSMutableDictionary *personInfos = [[NSMutableDictionary alloc]init];
    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty));
    //    if([NSString isEnabled:firstName])[personInfos setObject:firstName forKey:@"firstName"];
    NSString *middleName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonMiddleNameProperty));
    //    if([NSString isEnabled:middleName])[personInfos setObject:middleName forKey:@"middleName"];
    NSString *lastName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonLastNameProperty));
    //    if([NSString isEnabled:lastName])[personInfos setObject:lastName forKey:@"lastName"];
    NSString *name = [NSString stringWithFormat:@"%@%@%@",[NSString isEnabled:firstName]?firstName:@"",[NSString isEnabled:middleName]?middleName:@"",[NSString isEnabled:lastName]?lastName:@""];
    if([NSString isEnabled:checkParams]&&![name hasPrefix:checkParams]&&![name hasSuffix:checkParams]){
        return nil;
    }
    NSString *shortPy = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonFirstNamePhoneticProperty));
    if([NSString isEnabled:shortPy]){
        [personInfos setValue:shortPy forKey:@"shortPY"];
    }
    NSString *longPy = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonLastNamePhoneticProperty));
    if([NSString isEnabled:shortPy]){
        [personInfos setValue:longPy forKey:@"longPY"];
    }
    [personInfos setObject:name forKey:@"name"];
    NSString *phone = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonPhoneProperty));
    if([NSString isEnabled:phone]){
        id  phones = [self filterContentForCheckSubProperty:CFBridgingRetain(phone) CheckParams:checkParams];
        if(!phones){
            return nil;
        }
        [personInfos setObject:phones forKey:@"phone"];
    }
    
    NSString *email = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonEmailProperty));
    if([NSString isEnabled:email]){
        id  emails = [self filterContentForCheckSubProperty:CFBridgingRetain(email) CheckParams:checkParams];
        if(!emails){
            return nil;
        }
        [personInfos setObject:emails forKey:@"email"];
    }
    id address = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonAddressProperty));
    if([NSString isEnabled:address])[personInfos setObject:[self filterContentForCheckAddressProperty:CFBridgingRetain(address)] forKey:@"address"];
    NSString *note = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonNoteProperty));
    if([NSString isEnabled:note]){
        [personInfos setValue:note forKey:@"note"];
    }
    //读取照片
    NSData *dataImage = [self findDataImage1ByRef:thisPerson];
    if(dataImage)[personInfos setObject:dataImage forKey:@"dataImage"];
    return personInfos;
}
-(NSData*) findDataImageByRef:(ABRecordRef) thisPerson{
    return (__bridge NSData*)ABPersonCopyImageData(thisPerson);
}
-(NSData*) findDataImage1ByRef:(ABRecordRef) thisPerson{
    return (__bridge NSData *)(ABPersonCopyImageDataWithFormat(thisPerson, kABPersonImageFormatThumbnail));
}
-(NSData*) findDataImage2ByRef:(ABRecordRef) thisPerson{
    return (__bridge NSData *)(ABPersonCopyImageDataWithFormat(thisPerson, kABPersonImageFormatOriginalSize));
}
/**
 设置瞬时状态的数据
 */
-(bool) setAllValues:(NSDictionary*) jsonContent UserRef:(ABRecordRef) userRef{
    NSString *name = [jsonContent objectForKey:@"name"];
    NSString *shortPY = [jsonContent objectForKey:@"shortPY"];
    NSString *longPY = [jsonContent objectForKey:@"longPY"];
    NSArray *phones = [jsonContent objectForKey:@"phone"];
    NSArray *emails = [jsonContent objectForKey:@"email"];
    NSArray *address = [jsonContent objectForKey:@"address"];
    NSString *note = [jsonContent objectForKey:@"note"];
    NSData *dataImage = [jsonContent objectForKey:@"dataImage"];
    bool success = [self addRecodeValue:userRef PropertyID:kABPersonFirstNameProperty PropertyValue:name IfCommite:false];
    if (!success) return nil;
    success = [self setRecodeValue:userRef PropertyID:kABPersonLastNameProperty PropertyValue:@"" IfCommite:NO];
    if (!success) return nil;
    success = [self setRecodeValue:userRef PropertyID:kABPersonMiddleNameProperty PropertyValue:@"" IfCommite:NO];
    if (!success) return nil;
    success = [self setRecodeValue:userRef PropertyID:kABPersonFirstNamePhoneticProperty PropertyValue:shortPY IfCommite:NO];
    success = [self setRecodeValue:userRef PropertyID:kABPersonLastNamePhoneticProperty PropertyValue:longPY IfCommite:NO];
    if(emails){
        success = [self setPropertyValue:userRef kABPersonProperty:kABPersonEmailProperty Values:emails];
        if (!success) return nil;
    }
    if(phones){
        success = [self setPropertyValue:userRef kABPersonProperty:kABPersonPhoneProperty Values:phones];
        if (!success) return nil;
    }
    if(address){
        success = [self setPropertyAddressValue:userRef Values:address];
    }
    success = [self setRecodeValue:userRef PropertyID:kABPersonNoteProperty PropertyValue:note IfCommite:NO];
    if (!success) return nil;
    if(dataImage&&[dataImage class]==[NSData class])
        success = ABPersonSetImageData(userRef, (__bridge CFDataRef)(dataImage), NULL);
    else
        success = ABPersonRemoveImageData(userRef, NULL);
    [self commiteAddRecode:userRef];
    return success;
}
/**
 读取多值
 */
-(NSArray*) filterContentForCheckSubProperty:(ABRecordRef) subPropertyRef CheckParams:(NSString*) checkParams
{
    //    CFStringRef r1 = kABPersonHomePageLabel;
    //    r1 = kABPersonPhoneMainLabel;
    //    r1 = kABPersonPhoneMobileLabel;
    //    r1 = kABPersonPhoneIPhoneLabel ;
    //    r1 = kABPersonPhoneMainLabel;
    //    r1 = kABPersonPhonePagerLabel;
    //    r1 = kABPersonPhoneHomeFAXLabel;
    //    r1 = kABPersonPhoneWorkFAXLabel;
    //    r1 = kABPersonPhoneOtherFAXLabel;
    NSMutableArray *subPropertys = [[NSMutableArray alloc]init];;
    int count = ABMultiValueGetCount(subPropertyRef);
    bool flag = ![NSString isEnabled:checkParams];
    for (int index = 0; index<count; index++)
    {
        id value =(__bridge id) ABMultiValueCopyValueAtIndex(subPropertyRef, index);
        NSString  *lable  = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(subPropertyRef,index);
        NSArray *property = [NSArray arrayWithObjects:lable, value, nil];
        flag = flag||(![checkParams hasPrefix:value]&&![checkParams hasSuffix:value]);
        [subPropertys addObject:property];
    }
    if(!flag){
        return nil;
    }
    return subPropertys;
}
/**
 读取多值
 */
-(NSArray*) filterContentForCheckAddressProperty:(ABRecordRef) subPropertyRef
{
    NSMutableArray *subPropertys = [[NSMutableArray alloc]init];;
    int count = ABMultiValueGetCount(subPropertyRef);
    for (int index = 0; index<count; index++)
    {
        CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(subPropertyRef, index);
        NSString *street = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressStreetKey);
        NSString *city = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressCityKey);
        NSString *state = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressStateKey);
        NSString *zip = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressZIPKey);
        NSString *country = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressCountryKey);
        NSString *countryCode = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressCountryCodeKey);
        NSMutableDictionary *json = [[NSMutableDictionary alloc]init];
        if([NSString isEnabled:street])[json setObject:street forKey:(__bridge NSString*)kABPersonAddressStreetKey];
        if([NSString isEnabled:city])[json setObject:city forKey:(__bridge NSString*)kABPersonAddressCityKey];
        if([NSString isEnabled:state])[json setObject:state forKey:(__bridge NSString*)kABPersonAddressStateKey];
        if([NSString isEnabled:zip])[json setObject:zip forKey:(__bridge NSString*)kABPersonAddressZIPKey];
        if([NSString isEnabled:country])[json setObject:country forKey:(__bridge NSString*)kABPersonAddressCountryKey];
        if([NSString isEnabled:countryCode])[json setObject:countryCode forKey:(__bridge NSString*)kABPersonAddressCountryCodeKey];
        [subPropertys addObject:json];
        CFRelease(dict);
    }
    return subPropertys;
}

/**
 新增一级数据
 */
-(bool) addRecodeValue:(ABRecordRef) thisPerson PropertyID:(ABPropertyID) propertyID PropertyValue:(NSString*) propertyValue IfCommite:(bool) ifCommite
{
    ABRecordType recordType = ABRecordGetRecordType(thisPerson);//获取该记录的类型,有kABPersonType,kABGroupType,kABSourceType三种
    
    if(recordType!=kABPersonType){
        return NO;
    }
    bool success = NO;
    success = ABRecordSetValue(thisPerson, propertyID, (__bridge CFTypeRef)(propertyValue), NULL);//设置标签对应的属性值
    if(ifCommite)success = success&&[self commiteAddRecode:thisPerson];
    return success;
}
/**
 修改一级数据
 */
-(bool) setRecodeValue:(ABRecordRef) thisPerson PropertyID:(ABPropertyID) propertyID PropertyValue:(NSString*) propertyValue IfCommite:(bool) ifCommite
{
    ABRecordType recordType = ABRecordGetRecordType(thisPerson);//获取该记录的类型,有kABPersonType,kABGroupType,kABSourceType三种
    if(recordType!=kABPersonType){
        return NO;
    }
    bool success = NO;
    success = ABRecordSetValue(thisPerson, propertyID, (__bridge CFTypeRef)(propertyValue), NULL);//设置标签对应的属性值,以FirstName为例
    if(ifCommite)success = success&&[self commiteBookRecode:thisPerson];
    return success;
}
/**
 设置二级数据
 */
-(bool) setPropertyValue:(ABRecordRef)  userRef kABPersonProperty:(ABPropertyID) kABPersonProperty Values:(NSArray*) values{
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    unsigned int count =  (values&&[values count]>0)?[values count]:0;
    if(count){
        int index = 0;
        for (NSArray *array in values) {
            CFStringRef stringRef =  (__bridge CFStringRef)(array[0]);
            if(!stringRef){continue;}
            ABMultiValueAddValueAndLabel(multiPhone, CFBridgingRetain(values[index]), stringRef, NULL);
            CFRelease(stringRef);
            index++;
        }
    }
    // add data details to Record
    bool success = ABRecordSetValue(userRef, kABPersonProperty, multiPhone,nil);
    CFRelease(multiPhone);
    return success;
}
/**
 设置地址数据
 */
-(bool) setPropertyAddressValue:(ABRecordRef)  userRef  Values:(NSArray*) values{
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    for (NSMutableDictionary *addressDictionary in values) {
        //        [addressDictionary setObject:@"750 North Orleans Street, Ste 601" forKey:(NSString *) kABPersonAddressStreetKey];
        //        [addressDictionary setObject:@"Chicago" forKey:(NSString *)kABPersonAddressCityKey];
        //        [addressDictionary setObject:@"IL" forKey:(NSString *)kABPersonAddressStateKey];
        //        [addressDictionary setObject:@"60654" forKey:(NSString *)kABPersonAddressZIPKey];
        ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
    }
    // add data details to Record
    bool success = ABRecordSetValue(userRef, kABPersonAddressProperty, multiAddress,NULL);
    CFRelease(multiAddress);
    return success;
}
/**
 提交数据
 */
-(bool) commiteAddRecode:(ABRecordRef) thisPerson
{
    bool success = YES;
    //保存电话本
    success = ABAddressBookAddRecord(self->addressBook, thisPerson, nil);
    success = success&&ABAddressBookSave(self->addressBook, NULL);
    return success;
}
/**
 提交数据
 */
-(bool) commiteBookRecode:(ABRecordRef) thisPerson
{
    bool success = YES;
    bool hasUnsavedChanges = ABAddressBookHasUnsavedChanges(thisPerson);//判断当前通讯录是否有做更改
    if (hasUnsavedChanges) {
        //保存电话本
        success = ABAddressBookAddRecord(self->addressBook, thisPerson, nil);
        success = success&&ABAddressBookSave(self->addressBook, NULL);
    }
    return success;
}

@end
