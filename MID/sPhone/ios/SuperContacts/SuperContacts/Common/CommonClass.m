//
//  CommonClass.m
//  ST-ME
//
//  Created by wlpiaoyi on 12/16/13.
//  Copyright (c) 2013 wlpiaoyi. All rights reserved.
//
#import "CommonClass.h"
#import  "Common.h"
#import "EntityManagerAddressBook.h"
#import "FDEntityManager.h"
#import "SABFromDataBaseService.h"
#import "SABFromLocationContentService.h"
#import "LoginController.h"
#import "PopUpDialogView.h"

extern NSString *CTSettingCopyMyPhoneNumber();//本机号码
static NSString  *COMMONCLASSHTTPURL;
static NSString  *COMMONCLASSFILEURL;
static NSMutableArray *COMMONSYSVERSION;
static UIColor *COMMONCLASSAPPBGCOLOR;//系统背景颜色
static float COMMONCLASSTOPHEIGHT;
//static NSMutableArray *COMMONADDRESSBOOKARRAY;//通信录
static NSMutableArray *COMMONUSERSHORTPY;//通信录中的简拼集合
static FDEntityManager *COMMONEM;//数据库操作对象
static EntityManagerAddressBook *COMMONEMAB;//电话本操作对象
static SABFromDataBaseService *COMMONFDBS;
static SABFromLocationContentService *COMMONFLCS;
@implementation CommonClass{
}
+(void) initialize{
    COMMONCLASSHTTPURL = [NSString stringWithFormat:@"http://%@:%d",COMMON_HTTP_BASE_URL,COMMON_APP_API_PORT];
    COMMONCLASSFILEURL = [NSString stringWithFormat:@"http://%@:%d",COMMON_HTTP_FILE_URL,COMMON_APP_FILE_PORT ];
    
    NSArray *temparray =[[[UIDevice currentDevice] systemVersion]componentsSeparatedByString:@"."];
    COMMONSYSVERSION = [NSMutableArray new];
    for (NSString *tempv in temparray) {
        [COMMONSYSVERSION addObject:[[NSNumber alloc] initWithInt:[tempv intValue]]];
    }
    COMMONCLASSTOPHEIGHT = 20.0f;
    COMMONCLASSAPPBGCOLOR = [UIColor colorWithRed:0.176 green:0.537 blue:0.843 alpha:1];
//    [CommonClass refreshAllAddressBookRecords];
    COMMONEM = [FDEntityManager new];
    COMMONEMAB = [[EntityManagerAddressBook alloc]init];
    COMMONUSERSHORTPY = false;;
}
+(NSString*) getCurrentPhoneNum{
    NSString *phoneNum = CTSettingCopyMyPhoneNumber();
    phoneNum = [NSString isEnabled: phoneNum]?phoneNum:[[NSUserDefaults standardUserDefaults] objectForKey:@"SBFormattedPhoneNumber"];
    return [NSString isEnabled: phoneNum]?phoneNum:@"未知号码";
}
+(UIColor*) getCOMMONCLASSAPPBGCOLOR{
    return COMMONCLASSAPPBGCOLOR;
}
+(NSString*) CC_getHttpUrl:(NSString*) url{// /api/sp
    return [NSString stringWithFormat:@"%@%@%@",COMMONCLASSHTTPURL,COMMON_HTTP_URL_SUFFIX,url];
}
+(NSString*) CC_getFileUrl:(NSString*) url{
    return [NSString stringWithFormat:@"%@%@",COMMONCLASSFILEURL,url];
}
+(bool) IOSVersionCheck:(int) version{
    if(((NSNumber*)[COMMONSYSVERSION objectAtIndex:0]).intValue>=version){
        return YES;
    }
    return NO;
}
+(UINavigationController*) CC_addRootController:(UINavigationController*) navnext topHeight:(float) topHeight{
    CGRect frameWindow = [[UIScreen mainScreen] bounds];
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        frameWindow=  CGRectMake(0,topHeight<0.0f?COMMONCLASSTOPHEIGHT:topHeight,frameWindow.size.width,frameWindow.size.height-(topHeight<0.0f?COMMONCLASSTOPHEIGHT:topHeight));
        [[UIApplication sharedApplication].keyWindow.rootViewController.view setFrame:frameWindow];
        //[navnext.view setFrame:frameWindow];
        //[UIApplication sharedApplication].keyWindow.frame = frameWindow;
    }else{
        frameWindow=  CGRectMake(0,topHeight<0.0f?COMMONCLASSTOPHEIGHT:topHeight,frameWindow.size.width,frameWindow.size.height-(topHeight<0.0f?COMMONCLASSTOPHEIGHT:topHeight));
        navnext.view.frame = frameWindow;
    }
    return navnext;
    // [self.navigationController pushViewController:viewcontroller animated:YES];
}
+(void) callTelprompt:(NSString*) phoneNun
{
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneNun];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:num]];
}
+(void)showMessage:(NSString*) message Title:(NSString*) title Delegate:(id<PopUpDialogViewDelegate>) delegate{
    [[PopUpDialogView initWithTitle:title  message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil,nil]show];
}
+(void)showMessage:(NSString*) title Delegate:(id<PopUpDialogViewDelegate>) delegate Messages:(NSString*) message,...{
    va_list _list;
    NSMutableArray *_resources = [NSMutableArray arrayWithObjects:message,nil];
    va_start(_list, message);
    @try {
        NSString* resource;
        while ((resource = va_arg( _list, NSString *)))
        {
            [_resources addObject:resource];
        }
        NSString *cancel = [_resources lastObject];
        [_resources removeObject:cancel];
        PopUpDialogView *tempx;
        switch ([_resources count]) {
            case 1:
                tempx = [PopUpDialogView initWithTitle:@"询问"  message:title delegate:delegate cancelButtonTitle:cancel otherButtonTitles:_resources[0],nil];
                break;
            case 2:
                tempx = [PopUpDialogView initWithTitle:@"询问"  message:title delegate:delegate cancelButtonTitle:cancel otherButtonTitles:_resources[0],_resources[1],nil];
                break;
            case 3:
                tempx = [PopUpDialogView initWithTitle:@"询问"  message:title  delegate:delegate cancelButtonTitle:cancel otherButtonTitles:_resources[0],_resources[1],_resources[2],nil];
                break;
            case 4:
                tempx = [PopUpDialogView initWithTitle:@"询问"  message:title  delegate:delegate cancelButtonTitle:cancel otherButtonTitles:_resources[0],_resources[1],_resources[2],_resources[3],nil];
                break;
            case 5:
                tempx = [PopUpDialogView initWithTitle:@"询问"  message:title delegate:delegate cancelButtonTitle:cancel otherButtonTitles:_resources[0],_resources[1],_resources[2],_resources[3],_resources[4],nil];
                break;
                
            default:
                tempx = [PopUpDialogView initWithTitle:@"询问"  message:title  delegate:delegate cancelButtonTitle:cancel otherButtonTitles:nil,nil];
                break;
        }
        [tempx show];
    }
    @finally {
        va_end(_list);
    }
}

+(void)showSheet:(NSString*) title TargetView:(UIView*) targetView Delegate:(id<UIActionSheetDelegate>) delegate ButtonNames:(NSString*) buttonNames,...{
    va_list arg_ptr;
    va_start(arg_ptr, buttonNames);
    @try {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:title
                                      delegate:delegate
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:buttonNames,va_arg(arg_ptr, NSString*),va_arg(arg_ptr, NSString*),va_arg(arg_ptr, NSString*),va_arg(arg_ptr, NSString*),va_arg(arg_ptr, NSString*),nil];
        [actionSheet showInView:targetView];
    }
    @finally {
        va_end(arg_ptr);
    };
}
//+(NSMutableArray*) allAddressBookRecords{
//    return COMMONADDRESSBOOKARRAY;
//}
//+(void) refreshAllAddressBookRecords{
//    EntityManagerAddressBook *em = [[EntityManagerAddressBook alloc]init];
//    COMMONADDRESSBOOKARRAY = [em queryContentsByParams:nil];
//}
+(id) getCurrentEntityManager{
    return COMMONEM;
}
+(id) getCurrentEntityManagerAddressBook{
    return COMMONEMAB;
}
 +(NSString*) getLocationPhoneNumber{
     NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
     return [ud valueForKey:@"SBFormattedPhoneNumber"];
 }
+(id) getCOMMONFDBS{
    @synchronized(COMMONFDBS){
        if (!COMMONFDBS) {
            COMMONFDBS = [[SABFromDataBaseService alloc]init];
        }
    }
    return COMMONFDBS;
}
+(id) getCOMMONFLCS{
    @synchronized(COMMONFLCS){
        if (!COMMONFLCS) {
            COMMONFLCS = [[SABFromLocationContentService alloc]init];
        }
    }
    return COMMONFLCS;
}
+(bool) ifLongScreen{
    bool flag = COMMON_SCREEN_H>=548?true:false;
    return flag;
}
+(NSArray*) checkShortPingYing{
    @synchronized(COMMONUSERSHORTPY){
        if(!COMMONUSERSHORTPY){
            FDEntityManager *em = [CommonClass getCurrentEntityManager];
            COMMONUSERSHORTPY = [NSMutableArray arrayWithArray:[em queryBySql:@"select u.shortPingYing from EntityUser as u" Params:nil]];
            [COMMONUSERSHORTPY addObjectsFromArray:COMMONEMAB.pys];
        }
    }
    return COMMONUSERSHORTPY;
}
+(NSArray*) checkNumToPingYingForArray:(char*) numChar{
    if(!numChar)return nil;
    if(strlen(numChar)==0)return nil;
    if(strlen(numChar)>4)return nil;
    NSMutableArray *temp1 = [[NSMutableArray alloc] init];
    for (int i =0;i<strlen(numChar);i++) {
        char c = numChar[i];
        char* temp2 = [CommonClass checkNumForPinyYing:c];
        NSMutableArray *temp3 = [NSMutableArray new];
        if(temp2){
            for (int j=0; j<strlen(temp2); j++) {
                char x = temp2[j];
                NSString *temp4;
                if([CommonClass checkCharToNum:x]){
                    temp4 = [CommonClass checkCharToNum:x];
                }else{
                    temp4 = [NSString stringWithFormat:@"%c",x];
                }
                [temp3 addObject:temp4];
            }
            [temp1 addObject:temp3];
        }
    }
    NSArray *tempArray = [CommonClass checkNumToPingYingForSql:temp1 dicArg:nil SQLArray:nil Index:0];
    NSMutableArray *tempresult = [NSMutableArray new];
    for (NSString *tempx01 in tempArray) {
        for (NSString *tempx02 in [CommonClass checkShortPingYing]) {
            if([tempx02 isEqual:tempx01]||[tempx02 hasPrefix:tempx01]){
                [tempresult addObject:tempx01];
                break;
            }
        }
    }
    return tempresult;
}
+(NSMutableArray*) checkNumToPingYingForSql: (NSArray*) pys dicArg:(NSString*) dicArg SQLArray:(NSMutableArray*) sqlArray Index:(int) index{
    if(!sqlArray){
        sqlArray = [NSMutableArray new];
    }
    if(![pys count]) return sqlArray;
    NSArray *temp1 = pys[index];
    for(NSString *temp2 in temp1){
        if(!index) dicArg = @"";
        for (NSString *tempx in sqlArray) {
            if([tempx isEqual:dicArg]){
                [sqlArray removeObject:tempx];
                break;
            }
        }
        NSString *dicArg2 = [dicArg stringByAppendingString:temp2];
        if([pys count]>index+1){
            [CommonClass checkNumToPingYingForSql:pys dicArg:dicArg2 SQLArray:sqlArray Index:++index];
            --index;
        }else{
            [sqlArray addObject:dicArg2];
        }
    }
    return sqlArray;
}
+(NSString*) checkCharToNum:(char) c{
    switch (c) {
        case '0':
            return @"0";
        case '1':
            return @"1";
        case '2':
            return @"2";
        case '3':
            return @"3";
        case '4':
            return @"4";
        case '5':
            return @"5";
        case '6':
            return @"6";
        case '7':
            return @"7";
        case '8':
            return @"8";
        case '9':
            return @"9";
        default:
            return nil;
    }
}
+(char*) checkNumForPinyYing:(char) num{
    switch (num) {
        case '1':
            return "1";
        case '2':
            return "2ABC";
        case '3':
            return "3DEF";
        case '4':
            return "4GHI";
        case '5':
            return "5JKL";
        case '6':
            return "6MNO";
        case '7':
            return "7PQRS";
        case '8':
            return "8TUV";
        case '9':
            return "9WXYZ";
        case '0':
            return "0";
        default:
            return nil;
    }
}

+(NSString*) chooseNumberStr:(NSString*) str{
    NSString *tempstr = @"";
    const char* temp = [str UTF8String];
    for (int i=0; i<strlen(temp); i++) {
        if(temp[i]<=57&&temp[i]>=48){
            tempstr = [NSString stringWithFormat:@"%@%c",tempstr,temp[i]];
        }
    }
    return tempstr;
}

+(UIImage*) cutSizeForScrren:(UIImage*) image{
    CGSize s = image.size;
    CGRect r;
    float w = COMMON_SCREEN_W;
    float h = COMMON_SCREEN_H-44;
    if(s.height/s.width>h/w){
        image = [[[UIImageView alloc]initWithImage:image] drawView];
        float height = s.width*h/w;
        r = CGRectMake(0, (s.height-height)/2, s.width, height);
    }else{
        float width = s.height*w/h;
        r = CGRectMake((s.width-width)/2, 0, width, s.height);
    }
    image = [image cutImage:r];
    image = [image setImageSize:CGSizeMake(w*2, h*2)];
    return image;
}
//==>在从通信录数据库查询联系人数据是无法使用SQL语句，只能通过ABAddressBookCopyArrayOfAllPeople和ABAddressBookCopyPeopleWithName函数获得
CFArrayRef ABAddressBookCopyArrayOfAllPeople (
                                              ABAddressBookRef addressBook
                                              );
CFArrayRef ABAddressBookCopyPeopleWithName (
                                            ABAddressBookRef addressBook,
                                            CFStringRef name
                                            );
//<==
/**
 ABAddressBookCopyArrayOfAllPeople函数是查询所有的联系人数据。ABAddressBookCopyPeopleWithName函数是通过人名查询通讯录中的联系人，其中的name参数就是查询的前缀关键字。两个函数中都有addressBook参数，它是我们要查询的通讯录对象，其创建使用ABAddressBookCreateWithOptions函数（在iOS6之前是ABAddressBookCreate函数）
 */
ABAddressBookRef ABAddressBookCreateWithOptions (
                                                 CFDictionaryRef options,
                                                 CFErrorRef* error
                                                 );
CFTypeRef ABRecordCopyValue (
                             ABRecordRef record,
                             ABPropertyID property
                             );

@end
