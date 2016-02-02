//
//  AITwitterAuth.m
//  TwitterAuth
//
//  Created by Ahmed Ibrahim on 8/17/14.
//  Copyright (c) 2014 ahmedibrahim. All rights reserved.
//

#import "AITwitterAuth.h"
#import <Twitter/Twitter.h>
#import "STTwitterAPI.h"
#import "AIAccount.h"
#import "UIActionSheet+Blocks.h"

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
             withCompletionHandler:(void (^) (AIAccount *account))completionHandler
                     cancelHandler:(void (^) (void))cancelHandler
{
    if (!accounts.count && completionHandler) {
        completionHandler(nil);
    } else {
        UIWindow *appWindow = [[[UIApplication sharedApplication] delegate] window];
        [UIActionSheet showInView:appWindow
                        withTitle:@"Choose a Twitter account"
                cancelButtonTitle:@"Cancel"
           destructiveButtonTitle:nil
                otherButtonTitles:[self titlesForAccounts:accounts]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (completionHandler) {
                                 if (buttonIndex < accounts.count) {
                                     ACAccount *account = accounts[buttonIndex];
                                     [self wrapACAccount:account withCompletionHandler:completionHandler];
                                 } else {
                                     cancelHandler();
                                 }
                             }
                         }];
    }
}

+ (NSArray *)titlesForAccounts:(NSArray *)accounts
{
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:accounts.count];
    for (AIAccount *account in accounts) {
        [titles addObject:account.username];
    }
    return titles;
}

+ (void)selectAnAccountFromAccounts:(NSArray *)accounts
            withCompletionHandler:(void (^) (AIAccount *account))completionHandler
                    cancelHandler:(void (^) (void))cancelHandler
{
    if (!completionHandler) return;
    
    if (accounts.count == 1) {
        ACAccount *account = accounts[0];
        [self wrapACAccount:account withCompletionHandler:completionHandler];
    }
    else {
        [self showActionSheetForAccounts:accounts withCompletionHandler:completionHandler cancelHandler:cancelHandler];
    }
}

+ (void)wrapACAccount:(ACAccount *)account withCompletionHandler:(void (^) (AIAccount *account))completionHandler {
    STTwitterAPI *twitterAPI = [STTwitterAPI twitterAPIOSWithAccount:account];
    
    [twitterAPI getUserInformationFor:account.username successBlock:^(NSDictionary *user) {
        completionHandler([[AIAccount alloc] initWithTwitterUserObject:user]);
    } errorBlock:^(NSError *error) {
        completionHandler([[AIAccount alloc] initWithIdentifier:[account valueForKey:@"properties"][@"user_id"]
                                                       username:account.username
                                                       fullName:account.userFullName
                                              profilePictureURL:nil]);
    }];
}

+ (void)authenticateWithCompletionHandler:(void (^) (AIAccount *account))completionHandler
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
