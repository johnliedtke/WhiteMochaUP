//
//  WMPhoneNumber.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 12/27/13.
//
//

#import "WMPhoneNumber.h"

@implementation WMPhoneNumber


- (void)makePhoneCall
{
    NSString *phoneText = [NSString stringWithFormat:@"%i", [self phoneNumber]];
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:phoneText];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)sendText
{
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}



@end
