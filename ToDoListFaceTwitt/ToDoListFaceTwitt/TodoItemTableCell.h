//
//  TodoItemTableCell.h
//  ToDoListFaceTwitt
//
//  Created by Roman on 20.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoItemTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbl;

@end


