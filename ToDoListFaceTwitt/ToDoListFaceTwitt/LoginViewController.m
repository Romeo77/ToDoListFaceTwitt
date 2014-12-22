//
//  ViewController.m
//  ToDoListFaceTwitt
//
//  Created by Roman on 18.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

#pragma btnActions

- (IBAction)btnLoginTapped:(id)sender {
    HUDSHOW
    [PFUser logInWithUsernameInBackground:self.tfLogin.text password:self.tfPassword.text
                                    block:^(PFUser *user, NSError *error) {
                                        HUDHIDE
                                        
                                        UIErrReturn(@"Cannot login");
                                        
                                        [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil];
                                        
                                        
                                    }];
}

- (IBAction)btnLoginFacebook:(id)sender {
    
    NSArray *permissionsArray = @[ @"public_profile", @"user_birthday",@"user_about_me",@"email"];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if(!user){
            return;
        }
        UIErrReturn (@"You cancelled the Facebook login")
        
        if (user.isNew) {
            [self facebookOpenSessionForEmail];
            UIMsg(@"You signed up and logged in through Facebook!");
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil];
            
        } else {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil];
            
        }
    }];
    
    
}

- (IBAction)btnLoginTwitter:(id)sender {
    
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        
        UIErrReturn (@"You cancelled the Twitter login")
        
        if(!user){
            return;
        }
        else if (user.isNew) {
            
            UIMsg(@"You signed up and logged in through Twitter!");
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil];
            
        } else {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil];
            
        }
        
    }];
    
}

- (IBAction)btnForgotPasswordTapped:(id)sender {
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Password reset" message:@"Please enter your email" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
    
    av.tapBlock = ^(UIAlertView *av, NSInteger buttonIndex){
        
        if(buttonIndex == av.cancelButtonIndex)return ;
        HUDSHOW
        [PFUser requestPasswordResetForEmailInBackground:[av textFieldAtIndex:0].text block:^(BOOL succeeded,NSError *error){
            HUDHIDE
            UIErrReturn (@"Failed to request password reset")
            UIMsg(@"Reguest instructions sent to your email")
            
            
        }];
        
    };
    
}

#pragma Facebook getEmail

- (void)facebookOpenSessionForEmail {
    
    NSArray *permissions = @[@"email"];
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      UIErrReturn (@"Failed to get your email")
                                      [self sessionStateChangedForEmail:session state:state error:error];
                                  }];
}

- (void)sessionStateChangedForEmail:(FBSession *)session
                              state:(FBSessionState) state
                              error:(NSError *)error {
    if(state == FBSessionStateOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            UIErrReturn (@"Failed to get your email")
            
            [self sendWelcomeEmail:[user objectForKey:@"email"]];
            
        }];
    }
}

- (void) sendWelcomeEmail:(NSString *) userEmail {
    
    [PFCloud callFunctionInBackground:@"mailgunSendMail"
                       withParameters:@{@"email": userEmail}
                                block:^(NSString *result, NSError *error) {
                                    UIErrReturn (@"Failed to send welcome email")
                                    
                                }];
    
    
}



@end