//
//  AIAccount.m
//  TwitterAuth
//
//  Created by Ahmed Ibrahim on 8/21/14.
//  Copyright (c) 2014 ahmedibrahim. All rights reserved.
//

#import "AIAccount.h"

@implementation AIAccount

- (instancetype)initWithIdentifier:(NSString *)identifier
                          username:(NSString *)username
                          fullName:(NSString *)fullName
                 profilePictureURL:(NSString *)pictureURL
{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.username = username;
        self.fullName = fullName;
        self.profilePictureURL = pictureURL;
    }
    return self;
}

@end
