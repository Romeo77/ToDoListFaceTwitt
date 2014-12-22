//
//  SingUpViewController.m
//  ToDoListFaceTwitt
//
//  Created by Roman on 18.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfEmil;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (IBAction)btnSingupTapped:(id)sender {
    
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.tfUsername.text;
    newUser.email = self.tfEmil.text;
    newUser.password = self.tfPassword.text;
    HUDSHOW
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        HUDHIDE
        UIErrReturn(@"Failed to sign up");
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil];
        [self sendWelcomeEmail];
        
        
    }];
}

- (void) sendWelcomeEmail {
    
    [PFCloud callFunctionInBackground:@"mailgunSendMail"
                       withParameters:@{@"email": self.tfEmil.text}
                                block:^(NSString *result, NSError *error) {
                                    UIErrReturn (@"Failed to send welcome email")
                                }];
    
    
}
@end
