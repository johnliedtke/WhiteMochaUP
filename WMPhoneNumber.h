//
//  WMPhoneNumber.h
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/27/13.
//
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface WMPhoneNumber : NSObject <MFMessageComposeViewControllerDelegate>


// Phone number
@property (nonatomic) int phoneNumber;


// Send a text message to
- (void)sendText;


// Prompts user to make a phone call 
- (void)makePhoneCall;

@end
