//
//  AITwitterAuth.h
//  TwitterAuth
//
//  Created by Ahmed Ibrahim on 8/17/14.
//  Copyright (c) 2014 ahmedibrahim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import "AIAccount.h"

static NSString *const AITwitterAuthDomain = @"com.ahmedibrahim.aitwitterauth";

typedef enum AITwitterAuthError {
    AITwitterAuthErrorNoAccountConfigured,
    AITwitterAuthErrorUserCancelled,
    AITwitterAuthErrorUnKnown
}AITwitterAuthError;

@interface AITwitterAuth : NSObject
+ (void)authenticateWithCompletionHandler:(void (^) (AIAccount *account))completionHandler
                           failureHandler:(void (^) (NSError *error))failureHandler;
@end
