//
//  ToDoSaveViewController.m
//  ToDoListFaceTwitt
//
//  Created by Roman on 20.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "ToDoSaveViewController.h"

@interface ToDoSaveViewController () <UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePic;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ToDoSaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.stringToEdit) self.field.text = self.stringToEdit;
    _imageView.image = self.imageSecondView;
    [self.field becomeFirstResponder];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (void) setButtonStatus
{
    self.btnSave.enabled = self.field.text.length > 0;
}

- (IBAction)btnSaveTapped:(id)sender {
    
    if (self.saveBlock){
        self.saveBlock(self.field.text, self.imageSecondView);
        self.field.text = @"";
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self btnSaveTapped:self];
    return YES;
}

#pragma mark photoAlbum

- (IBAction)changePic:(id)sender {
    
    [self compactCode:UIImagePickerControllerSourceTypePhotoLibrary] ;
    
}

-(void)compactCode :(UIImagePickerControllerSourceType)type{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = type;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageSecondView = chosenImage;
    self.stringToEdit = self.field.text;
    [self viewDidLoad];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



@end