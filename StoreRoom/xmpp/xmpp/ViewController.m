//
//  ViewController.m
//  xmpp
//
//  Created by wlpiaoyi on 15/1/20.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import "XMPPStream.h"
#import "XMPPJID.h"
#import "XMPPPresence.h"
#import "NSXMLElement+XMPP.h"
#import "XMPPMessage.h"

@interface ViewController ()
<XMPPStreamDelegate>
@property (nonatomic) XMPPStream *xmppStream;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.xmppStream == nil) {
        self.xmppStream = [[XMPPStream alloc] init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    if (![self.xmppStream isConnected]) {
        XMPPJID *jid = [XMPPJID jidWithString:@"admin@csdn.shimiso.com"];
        [self.xmppStream setMyJID:jid];
        [self.xmppStream setHostName:@"192.168.1.195"];
        NSError *error = nil;
        if (![self.xmppStream connectWithTimeout:30 error:&error]) {
            NSLog(@"Connect Error: %@", [[error userInfo] description]);
        }
    }

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSString *password = @"lwj2382577";
    NSError *error = nil;
    if (![self.xmppStream authenticateWithPassword:password error:&error]) {
        NSLog(@"Authenticate Error: %@", [[error userInfo] description]);
    }else{
    }
}
- (void)disconnect {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
    
    [self.xmppStream disconnect];
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.xmppStream sendElement:presence];
    [self sendMessage:@"sdfasdf" toUser:@"1"];

}
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSString *presenceType = [presence type];
    NSString *presenceFromUser = [[presence from] user];
    if (![presenceFromUser isEqualToString:[[sender myJID] user]]) {
        if ([presenceType isEqualToString:@"available"]) {
            //
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            //
        }
    }
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    return true;
}
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSString *messageBody = [message body];
}

- (XMPPIQ *)xmppStream:(XMPPStream *)sender willSendIQ:(XMPPIQ *)iq{
    return iq;
}
- (XMPPMessage *)xmppStream:(XMPPStream *)sender willSendMessage:(XMPPMessage *)message{
    return message;
}
- (void)sendMessage:(NSString *) _message toUser:(NSString *) user {
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:_message];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"from" stringValue:self.xmppStream.myJID.user];
    NSLog(@"%@",self.xmppStream.myJID.user);
    NSString *to = [NSString stringWithFormat:@"%@@csdn.shimiso.com", user];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addChild:body];
    NSLog(@"%@",[body stringValue]);
    [self.xmppStream sendElement:message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
