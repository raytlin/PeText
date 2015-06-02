//
//  LoginViewController.m
//  PeText
//
//  Created by Ray Lin on 5/31/15.
//  Copyright (c) 2015 BananaFoundation. All rights reserved.
//

#import "LoginViewController.h"
#import "MessagingTableViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *petIDTextfield;

@end

@implementation LoginViewController
- (IBAction)loginButtonPressed:(id)sender {
    
    //check if the pet ID is filled out, then do the segue to the messaging view
    //The pet ID is passed to the messaging view usong prepareForSegue
    if (![self.petIDTextfield.text isEqualToString:@""]) {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            [self performSegueWithIdentifier:@"goToPetMessagingViewController" sender:self];
        }else{
            [self performSegueWithIdentifier:@"goToMessagingTableView" sender:self];
        }
    }else{
        UIAlertController * loginAlert = [UIAlertController alertControllerWithTitle:@"" message:@"You need to enter a valid Pet ID, of course" preferredStyle:UIAlertControllerStyleAlert];
        [loginAlert addAction:[UIAlertAction actionWithTitle:@"Ima Dummy" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:loginAlert animated:YES completion:nil];
    }
    
}

- (IBAction)newUserButtonPressed:(id)sender {
// TODO: implement this for ipad only for new pets to make IDs
// TODO: add modal view of paw print analyzer
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //check if ipad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //popup the paw-pass
        [self performSegueWithIdentifier:@"presentPawPass" sender:self];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //for seg to message view, pass the pet ID to message view
    if ([segue.identifier isEqualToString:@"goToMessagingTableView"]||[segue.identifier isEqualToString:@"goToPetMessagingViewController"]) {
        MessagingTableViewController* mtvc = [segue destinationViewController];
        mtvc.petID = self.petIDTextfield.text;
    }
    
}


@end
