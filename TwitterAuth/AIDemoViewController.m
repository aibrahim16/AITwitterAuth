//
//  AIDemoViewController.m
//  TwitterAuth
//
//  Created by Ahmed Ibrahim on 8/17/14.
//  Copyright (c) 2014 ahmedibrahim. All rights reserved.
//

#import "AIDemoViewController.h"
#import "AITwitterAuth.h"

@implementation AIDemoViewController

- (void)showMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AITwitterAuth"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}

- (IBAction)login:(id)sender {
    [AITwitterAuth authenticateWithCompletionHandler:^(ACAccount *account) {
        [self showMessage:[NSString stringWithFormat:@"%@ has been successfully authenticated.", account.username]];
    } failureHandler:^(NSError *error) {
        [self showMessage:error.localizedDescription];
    }];
}

@end
