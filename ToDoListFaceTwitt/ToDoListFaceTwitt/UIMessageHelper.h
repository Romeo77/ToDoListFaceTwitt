//
//  UIMessageHelper.h
//  ToDoListFaceTwitt
//
//  Created by Roman on 18.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIMessagesHelper : NSObject
+(void) showError:(NSError *)error withMessage:(NSString *)message;
+ (void) showMessage :(NSString *)message;
@end

#define UIErrReturn(x) { if (error) {\
[UIMessagesHelper showError:error withMessage:(x)];\
return;\
}}

#define UIMsg(x){[UIMessagesHelper showMessage:(x)];}
