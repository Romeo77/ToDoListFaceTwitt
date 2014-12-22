//
//  UIMessageHelper.m
//  ToDoListFaceTwitt
//
//  Created by Roman on 18.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "UIMessageHelper.h"

@implementation UIMessagesHelper

+ (void) showError:(NSError *)error withMessage:(NSString *)message{
    
    NSString *errorString = [error userInfo][@"error"];
    if(errorString.length == 0) errorString = @"Unknown error";
    NSString *msg = [NSString stringWithFormat:@"%@ :%@",message,errorString];
    [[[UIAlertView alloc]initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
    
    
}

+ (void) showMessage :(NSString *)message{
    
    [[[UIAlertView alloc]initWithTitle:@"Hey" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
    
}
@end
