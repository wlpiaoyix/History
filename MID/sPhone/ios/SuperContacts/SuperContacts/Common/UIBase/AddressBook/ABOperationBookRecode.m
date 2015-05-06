//
//  ABOperationBookRecode.m
//  ST-ME
//
//  Created by wlpiaoyi on 13-12-25.
//  Copyright (c) 2013年 wlpiaoyi. All rights reserved.
//

#import "ABOperationBookRecode.h"
@interface ABOperationBookRecode()
@property (nonatomic, strong) NSMutableArray *listContacts;
@property ABAddressBookRef addressBook;
@end
@implementation ABOperationBookRecode
-(id) init{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
    {return nil;}
    //如果没有授权则返回空
    self = [super init];
    if(self){
        self.addressBook = addressBook;
    }
    return self;
}
-(NSArray*) getALLBookRecode
{
    [self filterContentForSearchText:@""];
    return self.listContacts;
}
-(NSArray*) getBookRecodeByName:(NSString*) searchName
{
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            //查询所有
            [self filterContentForSearchText:searchName];
        }
    });
    return self.listContacts;
}
//    ABMultiValueRef phoneNumbers = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
//    CFIndex k = ABMultiValueGetCount(phoneNumbers);
//    CFTypeRef g = ABMultiValueCopyValueAtIndex(phoneNumbers, 1);
//    CFIndex i = ABMultiValueGetFirstIndexOfValue(phoneNumbers, g);
//    CFStringRef s = ABMultiValueCopyLabelAtIndex(phoneNumbers, 1);
//    ABMultiValueIdentifier outIdentifier = ABMultiValueGetIdentifierAtIndex(phoneNumbers, i);
//    ABMutableMultiValueRef minValue = ABMultiValueCreateMutableCopy(phoneNumbers);
//    bool f = ABMultiValueAddValueAndLabel(minValue, (__bridge CFTypeRef)(@"15823423423"), s, &outIdentifier);
//    bool kkk = ABGroupAddMember(thisPerson, phoneNumbers, nil);
-(bool) setGroupPhoneValue:(ABRecordRef) thisPerson PhoneValue:(NSString*) phoneValue PhoneStringRef:(CFStringRef) phoneStringRef IfCommite:(bool) ifCommite
{
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    unsigned int count = ABMultiValueGetCount(phoneNumbers);
    for (unsigned int index = 0; index<count; index++) {
        CFStringRef phoneStringRef = ABMultiValueCopyLabelAtIndex(phoneNumbers, index);
        CFTypeRef phoneTypeRef = ABMultiValueCopyValueAtIndex(phoneNumbers, index);
        ABMultiValueAddValueAndLabel(multiPhone, phoneTypeRef, phoneStringRef, NULL);
        CFRelease(phoneStringRef);
        CFRelease(phoneTypeRef);
    }
    CFRelease(phoneNumbers);
    bool success = NO;
    // Adding Phone details
    // create a new phone --------------------
    if(phoneStringRef&&phoneStringRef!=nil)
        ABMultiValueAddValueAndLabel(multiPhone, phoneValue, phoneStringRef, NULL);
    else
        ABMultiValueAddValueAndLabel(multiPhone, phoneValue, kABPersonPhoneMainLabel, NULL);
    // add phone details to person
    success = ABRecordSetValue(thisPerson, kABPersonPhoneProperty, multiPhone,nil);
    // release phone object
    CFRelease(multiPhone);
    if(ifCommite)success = success&&[self commiteBookRecode:thisPerson];
    return success;
}

//    ABRecordID recordID = ABRecordGetRecordID(thisPerson);//获取该记录的id号
//    NSLog(@"%d",recordID);
//    CFTypeRef targetRef = ABRecordCopyValue(thisPerson, propertyID);//根据标签获取对应的属性值,以FirstName为例
//    CFShow(targetRef);
-(bool) setRecodeValue:(ABRecordRef) thisPerson PropertyID:(ABPropertyID) propertyID PropertyValue:(NSString*) propertyValue IfCommite:(bool) ifCommite
{
    ABRecordType recordType = ABRecordGetRecordType(thisPerson);//获取该记录的类型,有kABPersonType,kABGroupType,kABSourceType三种
    if(recordType!=kABPersonType){
        return NO;
    }
    bool success = NO;
    CFErrorRef error = NULL;
    success = ABRecordSetValue(thisPerson, propertyID, (__bridge CFTypeRef)(propertyValue), &error);//设置标签对应的属性值,以FirstName为例
    CFRelease(error);
    if(ifCommite)success = success&&[self commiteBookRecode:thisPerson];
    return success;
}
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
 查询出对应的记录 存储在 self.listContacts 中
 */
- (void)filterContentForSearchText:(NSString*)searchText
{
    NSArray *listContacts;
    if([searchText length]==0)
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
    if([NSString isEnabled:address])[personInfos setObject:[self filterContentForCheckSubProperty:CFBridgingRetain(address)] forKey:@"address"];
    if(checkProperts&&checkProperts!=nil&&[checkProperts count]>0){
        for (NSArray *vk in checkProperts) {
            NSString *_vk = CFBridgingRelease(ABRecordCopyValue(thisPerson, (ABPropertyID)vk[0]));
            if([NSString isEnabled:address])[personInfos setObject:_vk forKey:vk[1]];
        }
    }
//    [self setRecodeValue:thisPerson PropertyID:kABPersonFirstNameProperty PropertyValue:[NSString stringWithFormat:@"%@",@"又功"] IfCommite:YES];
//    [self setGroupPhoneValue:thisPerson PhoneValue:@"2134234" PhoneStringRef:kABPersonPhoneWorkFAXLabel IfCommite:YES];
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
//        ABMultiValueInsertValueAndLabelAtIndex(ABMutableMultiValueRef multiValue, CFTypeRef value, CFStringRef label, CFIndex index, ABMultiValueIdentifier *outIdentifier)
    }
    return subPropertys;
}
-(oneway void) release{
    [super release];
}
-(void) dealloc{
    CFRelease(self.addressBook);
    [super dealloc];
}
@end
