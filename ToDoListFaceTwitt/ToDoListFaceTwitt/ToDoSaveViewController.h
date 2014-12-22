//
//  ToDoSaveViewController.h
//  ToDoListFaceTwitt
//
//  Created by Roman on 20.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void ((^TodoItemSaveBlock)(NSString *string, UIImage *picture));

@interface ToDoSaveViewController : UIViewController

@property (copy, nonatomic) TodoItemSaveBlock saveBlock;
@property (nonatomic, strong) NSString *stringToEdit;
@property (strong,nonatomic) UIImage *imageSecondView;

- (IBAction)btnSaveTapped:(id)sender;
- (IBAction)changePic:(id)sender;



@end

