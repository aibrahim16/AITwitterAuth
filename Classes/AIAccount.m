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

- (instancetype)initWithTwitterUserObject:(NSDictionary *)user {
    NSString *pictureURL = user[@"profile_image_url"];
    if (pictureURL) {
        pictureURL = [pictureURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
        pictureURL = [pictureURL stringByReplacingOccurrencesOfString:@"_bigger" withString:@""];
        pictureURL = [pictureURL stringByReplacingOccurrencesOfString:@"_mini" withString:@""];
    }
    self = [self initWithIdentifier:user[@"id"] username:user[@"screen_name"] fullName:user[@"name"] profilePictureURL:pictureURL];
    return self;
}

@end
