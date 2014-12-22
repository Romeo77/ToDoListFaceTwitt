//
//  TodoTableViewController.m
//  ToDoListFaceTwitt
//
//  Created by Roman on 18.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "ToDoTableViewController.h"
#import "ToDoModels.h"
#import "ToDoSaveViewController.h"
#import "TodoItemTableCell.h"


#define UIMsgs(x) { [[[UIAlertView alloc]initWithTitle:@"My Pics" message:(x) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];}
#define SHOW_ERROR UIMsgs(([NSString stringWithFormat:@"Error: %@ %@",error,[error userInfo]]))
#define SHOW_ERROR_RETURN { if(error){ SHOW_ERROR return;}}

@interface ToDoTableViewController () <UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong,nonatomic) NSString *stringTemporary;
@property (strong,nonatomic) UIImage *pictureTemporary;
// ===
@property (strong, nonatomic) NSArray *arrayWithObjects;

@end

@implementation ToDoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    
}

#pragma mark loadData

-(void)loadData {
    
    [PFQuery clearAllCachedResults];
    PFQuery *query = [ToDoModels query];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
    
    if(query.hasCachedResult)
        query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    HUDSHOW
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         HUDHIDE
         SHOW_ERROR_RETURN
         self.arrayWithObjects  = objects;
         [self.tableView reloadData];
     }];}

#pragma mark photoAlbum

- (IBAction)btnChooseTapped:(id)sender {
    
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
    self.pictureTemporary = chosenImage;
    self.stringTemporary = nil;
    
    [self performSegueWithIdentifier: @"save" sender:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(PFObject *)toDoItem {
    ToDoSaveViewController *secondVC = [ToDoSaveViewController new];
    
    if ([[segue identifier] isEqualToString:@"save"]) {
        secondVC = [segue destinationViewController];
        secondVC.stringToEdit = self.stringTemporary;
        secondVC.imageSecondView = self.pictureTemporary;
        
        __weak id welf = self;
        secondVC.saveBlock = ^(NSString *string, UIImage *newPicture)
        {
            
            if (toDoItem){
                
                NSData *imageData = UIImagePNGRepresentation(newPicture);
                PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
                
                toDoItem[@"text"] = string;
                toDoItem[@"pictures"] = imageFile;
                
                [toDoItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    SHOW_ERROR_RETURN
                    [welf loadData];
                }];
                
            }
            else {
                
                NSData *imageData = UIImagePNGRepresentation(newPicture);
                PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
                PFObject *userPhoto = [PFObject objectWithClassName:@"ToDo"];
                userPhoto[@"text"] = string;
                userPhoto[@"pictures"] = imageFile;
                userPhoto[@"owner"] = [PFUser currentUser];
                [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    SHOW_ERROR_RETURN
                    [welf loadData];
                }];
                
            }
            
            
        };
    }
}

- (void) pushToDoDetailsVCWithObjectToEdit:(PFObject *) toDoItem
{
    
    if(toDoItem){
        self.stringTemporary = toDoItem[@"text"];
        PFFile *imgFile = toDoItem[@"pictures"];
        [imgFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) return;
            
            self.pictureTemporary = [UIImage imageWithData:data];
            
            [self performSegueWithIdentifier: @"save" sender: toDoItem];
            
            
        }];
        
        
    }else {
        
        [self performSegueWithIdentifier: @"save" sender: toDoItem];
    }
}
#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayWithObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoItemTableCell *cell = (TodoItemTableCell *)[tableView
                                                    dequeueReusableCellWithIdentifier:@"TodoItemTableCell"];
    
    PFObject *object = self.arrayWithObjects[indexPath.row];
    cell.lbl.text = object[@"text"];
    cell.imgView.image = nil;
    
    PFFile *imgFile = object[@"pictures"];
    
    [cell.indicator startAnimating];
    [imgFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [cell.indicator stopAnimating];
        if (error) return;
        
        cell.imgView.image = [UIImage imageWithData:data];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToDoDetailsVCWithObjectToEdit:self.arrayWithObjects[indexPath.row]];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFObject *object = self.arrayWithObjects[indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        SHOW_ERROR_RETURN
        [self loadData];
    }];
    
}

- (IBAction)btnLogoutTapped:(id)sender {
    [PFUser logOut];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogout object:nil];
}

@end