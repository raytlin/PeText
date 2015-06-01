//
//  PETMessage.h
//  PeText
//
//  Created by Ray Lin on 5/31/15.
//  Copyright (c) 2015 BananaFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PETMessage : NSObject

@property (nonatomic, strong) NSString * text;
@property (nonatomic) BOOL ownMessage;


-(instancetype)initAsOwnWithMessage:(NSString*)message;

@end
