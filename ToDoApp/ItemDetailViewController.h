//
//  ItemDetailViewController.h
//  ToDoApp
//
//  Created by Edo williams on 10/12/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import <UIKit/UIKit.h>

//Adding delegates to add the text to teh tableview
@class ItemDetailViewController;
@class TodoListItem;

//protocols are name of groups of methods
//any object that conforms to this protocol must implement the methods listed
@protocol ItemDetailViewControllerDelegate <NSObject>

- (void)ItemDetailViewControllerDidCancel: (ItemDetailViewController *)controller;
- (void)ItemDetailViewController: (ItemDetailViewController *)controller didFinishAddingItem:(TodoListItem *)item;
- (void)ItemDetailViewController: (ItemDetailViewController *)controller didFinishEditingItem:(TodoListItem *)item;

@end

@interface ItemDetailViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <ItemDetailViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem * doneBarButton;
@property (nonatomic, strong) TodoListItem *itemToEdit;

- (IBAction)cancel;
- (IBAction)done;



@end
