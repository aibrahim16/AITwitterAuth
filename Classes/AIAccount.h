//
//  AIAccount.h
//  TwitterAuth
//
//  Created by Ahmed Ibrahim on 8/21/14.
//  Copyright (c) 2014 ahmedibrahim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIAccount : NSObject
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *profilePictureURL;

- (instancetype)initWithIdentifier:(NSString *)identifier
                          username:(NSString *)username
                          fullName:(NSString *)fullName
                 profilePictureURL:(NSString *)pictureURL;
@end
