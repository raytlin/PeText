//
//  MessagingTableViewController.m
//  PeText
//
//  Created by Ray Lin on 5/31/15.
//  Copyright (c) 2015 BananaFoundation. All rights reserved.
//

#import "MessagingTableViewController.h"
#import "PETMessage.h"

#define firebaseStore @"https://vivid-inferno-5447.firebaseio.com/"

@interface MessagingTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextfield;

@end

@implementation MessagingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialize the messages array
    self.messages = [[NSMutableArray alloc]init];
    
    //initialize firebase
    Firebase *initalFirebase = [[Firebase alloc]initWithUrl:firebaseStore];
    self.firebase = [initalFirebase childByAppendingPath:self.petID];
    
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
    
    
    // This allows us to check if these were messages already stored on the server
    // when we booted up (YES) or if they are new messages since we've started the app.
    // This is so that we can batch together the initial messages' reloadData for a perf gain.
    __block BOOL initialAdds = YES;
    
    //getting all the messages already there for each pet ID to do the inital message load and all subsequent adds
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [self.messages addObject:snapshot.value];
        // Reload the table view so the new message will show up.
        if (!initialAdds) {
            [self refreshTable];
        }
    }];
    
    [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        [self.tableView reloadData];
        initialAdds = NO;
    }];

}

#pragma mark - Messaging
- (IBAction)sendButtonPressed:(id)sender {
    if (![self.messageTextfield.text isEqualToString:@""]) {
        [self sendMessage:self.messageTextfield.text];
        self.messageTextfield.text = @"";
    } else{
        [self.messageTextfield resignFirstResponder];
    }

}

-(void)sendMessage:(NSString*)text{
    
    //firebase can only append nsdictionarys so adding the array numbers manually
    NSDictionary * message = @{@"text" : text, @"humanMessage" : @YES};
    NSString *arrayCount = [NSString stringWithFormat:@"%lu",[self.messages count] + 1];
    
    //send messages to firebase by appending to the end
    NSDictionary *messageDict = @{arrayCount: message};
    [self.firebase updateChildValues:messageDict];
    
    [self refreshTable];
    
}

-(void)refreshTable{
    //need to refresh table view after adding new message.
    [self.tableView reloadData];
    
    //scrolls to bottom of the page when new message comes in.
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: [self.messages count]-1
                                            inSection: 0];
    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

#pragma mark - Keyboard stuff


//sending message when press return on the keyboard
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

// Called when the UIKeyboardDidShowNotification is sent to change the size of the mainview to exclude the keyboard.
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
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        NSDictionary* message = self.messages[indexPath.row];
        if (!message[@"humanMessage"]) {
            yourMessage.text = message[@"text"];
        }else{
            theirMessage.text = message[@"text"];
        }
    }else{
        NSDictionary* message = self.messages[indexPath.row];
        if (message[@"humanMessage"]) {
            yourMessage.text = message[@"text"];
        }else{
            theirMessage.text = message[@"text"];
        }
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
