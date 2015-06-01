//
//  MessagingTableViewController.h
//  PeText
//
//  Created by Ray Lin on 5/31/15.
//  Copyright (c) 2015 BananaFoundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagingTableViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString * petID;
@property (nonatomic, strong) NSMutableArray * messages;

@end
