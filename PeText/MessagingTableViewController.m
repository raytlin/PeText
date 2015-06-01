//
//  MessagingTableViewController.m
//  PeText
//
//  Created by Ray Lin on 5/31/15.
//  Copyright (c) 2015 BananaFoundation. All rights reserved.
//

#import "MessagingTableViewController.h"
#import "PETMessage.h"

@interface MessagingTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextfield;

@end

@implementation MessagingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //get rid of the lines on the tableView
    self.tableView.separatorColor = [UIColor clearColor];
    
    //set up observers for keyboard shift
    [self registerForKeyboardNotifications];
    
    //set the text field delegate for the keyboard
    self.messageTextfield.delegate = self;
    
    //set the gesture recognizer to get rid of keyboard on tableview
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    //set the title bar to petID
    [self setTitle:self.petID];
    
    // temporarily set values in messages array. will delete later
    PETMessage *messageOne = [[PETMessage alloc]initAsOwnWithMessage:@"this is one message"];
    PETMessage *messageTwo = [[PETMessage alloc]initAsOwnWithMessage:@"this is another message"];
    PETMessage* messageThreee = [[PETMessage alloc]init];
    messageThreee.text = @"third message";
    messageThreee.ownMessage = NO;
    
    self.messages = [NSMutableArray arrayWithObjects:messageOne, messageTwo, nil];
    
    [self.messages addObject:messageThreee];

}

#pragma mark - Messaging

-(void)sendMessage:(NSString*)text{
    PETMessage* message = [[PETMessage alloc]initAsOwnWithMessage:text];
    [self.messages addObject:message];
    
    //need to refresh table view after adding new message. Should this go somewhere else?
    [self.tableView reloadData];
}

#pragma mark - Keyboard stuff


//sending message on return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![textField.text isEqualToString:@""]) {
        [self sendMessage:textField.text];
        self.messageTextfield.text = @"";
    } else{
        [textField resignFirstResponder];
    }
    return YES;
    
}

//for hiding keyboard
-(void)hideKeyboard{
    [self.messageTextfield resignFirstResponder];
}

//register for keyboard observer
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    self.mainView.frame = aRect;
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect aRect = self.view.frame;
    aRect.size.height += kbSize.height;
    self.mainView.frame = aRect;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel* theirMessage = (UILabel*)[cell viewWithTag:1];
    UILabel* yourMessage = (UILabel*)[cell viewWithTag:2];
    
    PETMessage* message = self.messages[indexPath.row];
    if (message.ownMessage) {
        yourMessage.text = message.text;
    }else{
        theirMessage.text = message.text;
    }
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
