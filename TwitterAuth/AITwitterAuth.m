//
//  AITwitterAuth.m
//  TwitterAuth
//
//  Created by Ahmed Ibrahim on 8/17/14.
//  Copyright (c) 2014 ahmedibrahim. All rights reserved.
//

#import "AITwitterAuth.h"
#import <Twitter/Twitter.h>

@implementation AITwitterAuth

+ (NSError *)errorWithCode:(int)code localizedDescription:(NSString *)description
{
    NSDictionary *info = @{NSLocalizedDescriptionKey : description};
    NSError *error = [NSError errorWithDomain:AITwitterAuthDomain code:code userInfo:info];
    return error;
}

+ (NSError *)noAccountConfiguredError
{
    NSString *errorDescription = @"There is no twitter account configured on this device, please go to settings to add an account.";
    return [self errorWithCode:AITwitterAuthErrorNoAccountConfigured localizedDescription:errorDescription];
}

+ (NSError *)cancelledError
{
    NSString *errorDescription = @"User has cancelled.";
    return [self errorWithCode:AITwitterAuthErrorUserCancelled localizedDescription:errorDescription];
}

+ (NSError *)permissionNotGrantedError
{
    NSString *errorDescription = @"Permission not granted, go to Settings->Privacy->Twitter and make sure that app is permitted to access your account.";
    return [self errorWithCode:AITwitterAuthErrorUserCancelled localizedDescription:errorDescription];
}

+ (void)showActionSheetForAccounts:(NSArray *)accounts
             withCompletionHandler:(void (^) (ACAccount *account))completionHandler
                     cancelHandler:(void (^) (void))cancelHandler
{
    if (!accounts.count && completionHandler) completionHandler(nil);
}

+ (void)selectAnAccountFromAccounts:(NSArray *)accounts
            withCompletionHandler:(void (^) (ACAccount *account))completionHandler
                    cancelHandler:(void (^) (void))cancelHandler
{
    if (!completionHandler) return;
    
    if (accounts.count == 1) {
        completionHandler(accounts[0]);
    }
    else {
        [self showActionSheetForAccounts:accounts withCompletionHandler:completionHandler cancelHandler:cancelHandler];
    }
}

+ (void)authenticateWithCompletionHandler:(void (^) (ACAccount *account))completionHandler
                           failureHandler:(void (^) (NSError *error))failureHandler
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        if (failureHandler) {
            failureHandler([self noAccountConfiguredError]);
        }
    }
    else {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted) {
                    if (failureHandler) failureHandler([self permissionNotGrantedError]);
                    return;
                }
                
                NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                if (accounts.count) {
                    [self selectAnAccountFromAccounts:accounts withCompletionHandler:completionHandler cancelHandler:^{
                        if (failureHandler) {
                            failureHandler([self cancelledError]);
                        }
                    }];
                }
                else if (failureHandler) {
                    failureHandler([self noAccountConfiguredError]);
                }
            });
            
        }];
    }
}
@end
