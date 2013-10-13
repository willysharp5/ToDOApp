//
//  ItemDetailViewController.m
//  ToDoApp
//
//  Created by Edo williams on 10/12/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "TodoListItem.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //change the ttle of the navigation bar if we editing
    if (self.itemToEdit != nil) {
        self.title = @"Edit Item";
        self.textField.text = self.itemToEdit.text;
        self.doneBarButton.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //this will show the keyboard when the add item view is loaded
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//This tells modal screen view controller (UINavigationController that
//contains the ToDoListViewController) to close the screen with animation
- (IBAction)cancel
{
    [self.delegate ItemDetailViewControllerDidCancel:self];
}

- (IBAction)done
{
    //check to see if the itemTo edit contains an object, if not we add a new item
    if (self.itemToEdit == nil) {
        TodoListItem *item = [[TodoListItem alloc] init];
        item.text = self.textField.text;
        item.checked = NO;
        
        [self.delegate ItemDetailViewController:self didFinishAddingItem:item];
    }
    else {
        
        self.itemToEdit.text = self.textField.text;
        [self.delegate ItemDetailViewController:self didFinishEditingItem:self.itemToEdit];
    }
    
    
}


//this allows you to disable the selection of a table row
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

//This will allow for disabling the done bar button when there is no text in the textfield
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //Figure out what the new text will be
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    if([newText length] > 0) {
        self.doneBarButton.enabled = YES;
    }
    else {
        self.doneBarButton.enabled = NO;
    }
    
    return YES;
}

@end
