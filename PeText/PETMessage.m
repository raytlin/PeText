//
//  PETMessage.m
//  PeText
//
//  Created by Ray Lin on 5/31/15.
//  Copyright (c) 2015 BananaFoundation. All rights reserved.
//

#import "PETMessage.h"

@implementation PETMessage

-(instancetype)initAsHumanWithMessage:(NSString*)message{
    self = [super init];
    _text = message;
    _humanMessage = YES;
    return self;
}

@end
