//
//  EntityManagerAddressBook.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityManagerAddressBook.h"
@interface EntityManagerAddressBook()
@property (nonatomic, strong) NSMutableArray *listContacts;//当前查询出来的记录
@property ABAddressBookRef addressBook;
@end
@implementation EntityManagerAddressBook
-(id) init{
    ABAddressBookRef addressBook;
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
    //如果没有授权则返回空
    self = [super init];
    if(self){
        _addressBook = addressBook;
    }
    return self;
}
/**
 更新通信录
 */
-(EntityUser*) merge:(EntityUser*) entity{
    NSString *userName = entity.userName;
    NSArray *telephones = entity.telephones;
    if(![NSString isEnabled:userName]||!telephones||telephones==nil||[telephones count]==0){
        return nil;
    }
    ABRecordRef userRef = entity.userRef;
    if (!userRef) {
        return [self persist:entity];
    }
    bool success = [self setRecodeValue:userRef PropertyID:kABPersonFirstNameProperty PropertyValue:entity.userName IfCommite:false];
    if (!success) return false;
    if(entity.dataImage&&[entity.dataImage class]==[NSData class])
        success = ABPersonSetImageData(userRef, (__bridge CFDataRef)((NSData*)entity.dataImage), NULL);
    else
        success = ABPersonRemoveImageData(userRef, NULL);
    if (!success) return nil;
    success = [self setPropertyValue:userRef kABPersonProperty:kABPersonEmailProperty Values:entity.emails];
    if (!success) return nil;
    success = [self setPropertyValue:userRef kABPersonProperty:kABPersonPhoneProperty Values:entity.telephones];
    if (!success) return nil;
    success = [self setPropertyAddressValue:userRef Values:entity.addresses];
    [self commiteBookRecode:userRef];
    if (!success) return nil;
    COMMON_REFRESH_ADDRESSBOOKARRAY;
    return entity;
}
/**
 新增通信录
 */
-(EntityUser*) persist:(EntityUser*) entity{
    NSString *userName = entity.userName;
    NSArray *telephones = entity.telephones;
    if(![NSString isEnabled:userName]||!telephones||telephones==nil||[telephones count]==0){
        return nil;
    }
    // 创建一条空的联系人
    ABRecordRef userRef = ABPersonCreate();
    entity.userRef=userRef;
    bool success = [self addRecodeValue:userRef PropertyID:kABPersonFirstNameProperty PropertyValue:entity.userName IfCommite:false];
    if (!success) return nil;
    if(entity.dataImage&&[entity.dataImage class]==[NSData class])
        success = ABPersonSetImageData(userRef, (__bridge CFDataRef)((NSData*)entity.dataImage), NULL);
    if (!success) return nil;
    success = [self setRecodeValue:userRef PropertyID:kABPersonFirstNameProperty PropertyValue:entity.userName IfCommite:NO];
    if (!success) return nil;
    success = [self setRecodeValue:userRef PropertyID:kABPersonLastNameProperty PropertyValue:@"" IfCommite:NO];
    if (!success) return nil;
    success = [self setRecodeValue:userRef PropertyID:kABPersonMiddleNameProperty PropertyValue:@"" IfCommite:NO];
    if (!success) return nil;
    success = [self setPropertyValue:userRef kABPersonProperty:kABPersonEmailProperty Values:entity.emails];
    if (!success) return nil;
    success = [self setPropertyValue:userRef kABPersonProperty:kABPersonPhoneProperty Values:entity.telephones];
    if (!success) return nil;
    success = [self setPropertyAddressValue:userRef Values:entity.addresses];
    [self commiteAddRecode:userRef];
    if (!success) return nil;
    COMMON_REFRESH_ADDRESSBOOKARRAY;
    return entity;
}
/**
 删除通信录
 */
-(bool) remove:(EntityUser*) entity{
    bool success = ABAddressBookRemoveRecord(_addressBook, entity.userRef, NULL);
    [self commiteAddRecode:entity.userRef];
    COMMON_REFRESH_ADDRESSBOOKARRAY;
    return success;
}
/**
 得到当前通信录
 */
-(EntityUser*) findByName:(NSString*) userName{
    NSArray *temp = COMMON_ADDRESSBOOKARRAY;
    for (EntityUser *u in temp) {
        if([u.userName isEqual:userName]){
            return u;
        }
    }
    return nil;
}
/**
 得到当前通信录
 */
-(EntityUser*) findByPhone:(NSString*) phone{
    NSArray *temp = COMMON_ADDRESSBOOKARRAY;
    for (EntityUser *u in temp) {
        if(u.telephones&&[u.telephones count]>0){
            for (NSString *temp in u.telephones) {
                if([temp hasPrefix:phone]){
                    return u;
                }
            }
        }
    }
    return nil;
}
/**
 新增数据
 */
-(bool) addRecodeValue:(ABRecordRef) thisPerson PropertyID:(ABPropertyID) propertyID PropertyValue:(NSString*) propertyValue IfCommite:(bool) ifCommite
{
    ABRecordType recordType = ABRecordGetRecordType(thisPerson);//获取该记录的类型,有kABPersonType,kABGroupType,kABSourceType三种
    
    if(recordType!=kABPersonType){
        return NO;
    }
    bool success = NO;
    success = ABRecordSetValue(thisPerson, propertyID, (__bridge CFTypeRef)(propertyValue), NULL);//设置标签对应的属性值,以FirstName为例
    if(ifCommite)success = success&&[self commiteAddRecode:thisPerson];
    return success;
}
/**
 修改数据
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

-(bool) setPropertyValue:(ABRecordRef)  userRef kABPersonProperty:(ABPropertyID) kABPersonProperty Values:(NSArray*) values{
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    unsigned int count =  (values&&[values count]>0)?[values count]:0;
    for (unsigned int index = 0; index<count; index++) {
        CFStringRef stringRef = [self getStringRefForIndex:index];
        if(!stringRef){continue;}
        ABMultiValueAddValueAndLabel(multiPhone, CFBridgingRetain(values[index]), stringRef, NULL);
        CFRelease(stringRef);
    }
    // add phone details to person
    bool success = ABRecordSetValue(userRef, kABPersonProperty, multiPhone,nil);
    CFRelease(multiPhone);
    return success;
}
-(bool) setPropertyAddressValue:(ABRecordRef)  userRef  Values:(NSArray*) values{
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    for (NSMutableDictionary *addressDictionary in values) {
//        [addressDictionary setObject:@"750 North Orleans Street, Ste 601" forKey:(NSString *) kABPersonAddressStreetKey];
//        [addressDictionary setObject:@"Chicago" forKey:(NSString *)kABPersonAddressCityKey];
//        [addressDictionary setObject:@"IL" forKey:(NSString *)kABPersonAddressStateKey];
//        [addressDictionary setObject:@"60654" forKey:(NSString *)kABPersonAddressZIPKey];
        ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
    }
    bool success = ABRecordSetValue(userRef, kABPersonAddressProperty, multiAddress,NULL);
    CFRelease(multiAddress);
    // add phone details to person
    return success;
}
-(CFStringRef) getStringRefForIndex:(int) index{
    switch (index) {
        case 0:
            return kABPersonPhoneMobileLabel;
        case 1:
            return kABPersonPhoneIPhoneLabel;
        case 2:
            return kABPersonPhoneMainLabel;
        case 3:
            return kABPersonPhoneHomeFAXLabel;
        case 4:
            return kABPersonPhoneWorkFAXLabel;
        case 5:
            return kABPersonPhoneOtherFAXLabel;
        case 6:
            return kABPersonPhonePagerLabel;
        default:
            return false;
    }
}

/**
 提交数据
 */
-(bool) commiteAddRecode:(ABRecordRef) thisPerson
{
    bool success = YES;
    //保存电话本
    success = ABAddressBookAddRecord(self.addressBook, thisPerson, nil);
    success = success&&ABAddressBookSave(self.addressBook, NULL);
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
        success = ABAddressBookAddRecord(self.addressBook, thisPerson, nil);
        success = success&&ABAddressBookSave(self.addressBook, NULL);
    }
    return success;
}
/**
 查询出所有的记录
 */
-(NSMutableArray*) queryAllRecord{
    [self filterContentForSearchText:@""];
    NSMutableArray *listContacts = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *json in _listContacts) {
        EntityUser *u = [json objectForKey:@"entityUser"];
        u.userName = [NSString stringWithFormat:@"%@%@%@",[json objectForKey:@"lastName"]?[json objectForKey:@"lastName"]:@"",[json objectForKey:@"firstName"]?[json objectForKey:@"firstName"]:@"",[json objectForKey:@"middleName"]?[json objectForKey:@"middleName"]:@""];
        u.dataImage = [json objectForKey:@"dataImage"];
        u.telephones = [json objectForKey:@"phone"];
        u.emails = [json objectForKey:@"email"];
        u.addresses = [json objectForKey:@"address"];
        NSMutableArray *temp1 = [[NSMutableArray alloc]init];
        for (NSString *phone in u.telephones) {
            [temp1 addObject:[phone stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        }
        u.telephones = temp1;
        [listContacts addObject:u];
    }
    return listContacts;
}
/**
 查询出对应的记录 存储在 self.listContacts 中
 */
- (void)filterContentForSearchText:(NSString*)searchText
{
    NSArray *listContacts;
    if(!searchText||searchText==nil||[searchText length]==0)
    {
        //查询所有
        listContacts = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(self.addressBook));
    } else {
        //条件查询
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        listContacts = CFBridgingRelease(ABAddressBookCopyPeopleWithName(self.addressBook, cfSearchText));
        CFRelease(cfSearchText);
    }
    self.listContacts = [[NSMutableArray alloc]init];
    for (id X in listContacts) {
        ABRecordRef thisPerson = CFBridgingRetain(X);
        NSMutableDictionary *json = [self filterContentForCheckInfo:thisPerson checkProperts:nil];
        EntityUser *u = [[EntityUser alloc]init];
        u.userRef = thisPerson;
        [json setObject:u forKey:@"entityUser"];
        [self.listContacts addObject:json];
        CFRelease(thisPerson);
    }
}
/**
 得到一级参数值
 */
-(NSMutableDictionary*) filterContentForCheckInfo:(ABRecordRef) thisPerson checkProperts:(NSArray*) checkProperts
{
    NSMutableDictionary *personInfos = [[NSMutableDictionary alloc]init];
    //读取照片
    NSData *dataImage = (__bridge NSData*)ABPersonCopyImageData(thisPerson);
    if(dataImage)[personInfos setObject:dataImage forKey:@"dataImage"];
    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty));
    if([NSString isEnabled:firstName])[personInfos setObject:firstName forKey:@"firstName"];
    NSString *middleName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonMiddleNameProperty));
    if([NSString isEnabled:middleName])[personInfos setObject:middleName forKey:@"middleName"];
    NSString *lastName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonLastNameProperty));
    if([NSString isEnabled:lastName])[personInfos setObject:lastName forKey:@"lastName"];
    NSString *phone = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonPhoneProperty));
    if([NSString isEnabled:phone])[personInfos setObject:[self filterContentForCheckSubProperty:CFBridgingRetain(phone)] forKey:@"phone"];
    NSString *email = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonEmailProperty));
    if([NSString isEnabled:email])[personInfos setObject:[self filterContentForCheckSubProperty:CFBridgingRetain(email)]  forKey:@"email"];
    id address = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonAddressProperty));
    if([NSString isEnabled:address])[personInfos setObject:[self filterContentForCheckAddressProperty:CFBridgingRetain(address)] forKey:@"address"];
    if(checkProperts&&checkProperts!=nil&&[checkProperts count]>0){
        for (NSArray *vk in checkProperts) {
            NSString *_vk = CFBridgingRelease(ABRecordCopyValue(thisPerson, (ABPropertyID)vk[0]));
            if([NSString isEnabled:address])[personInfos setObject:_vk forKey:vk[1]];
        }
    };
    return personInfos;
}
/**
 读取多值
 */
-(NSArray*) filterContentForCheckSubProperty:(ABRecordRef) subPropertyRef
{
    NSMutableArray *subPropertys = [[NSMutableArray alloc]init];;
    int count = ABMultiValueGetCount(subPropertyRef);
    for (int index = 0; index<count; index++)
    {
        NSDictionary* jsonPropery =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(subPropertyRef, index);
        [subPropertys addObject:jsonPropery];
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
        if([NSString isEnabled:street])[json setObject:street forKey:(NSString*)kABPersonAddressStreetKey];
        if([NSString isEnabled:city])[json setObject:city forKey:(NSString*)kABPersonAddressCityKey];
        if([NSString isEnabled:state])[json setObject:state forKey:(NSString*)kABPersonAddressStateKey];
        if([NSString isEnabled:zip])[json setObject:zip forKey:(NSString*)kABPersonAddressZIPKey];
        if([NSString isEnabled:country])[json setObject:country forKey:(NSString*)kABPersonAddressCountryKey];
        if([NSString isEnabled:countryCode])[json setObject:countryCode forKey:(NSString*)kABPersonAddressCountryCodeKey];
        [subPropertys addObject:json];
        CFRelease(dict);
    }
    return subPropertys;
}
@end
