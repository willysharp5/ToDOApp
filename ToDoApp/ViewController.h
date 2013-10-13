//
//  ViewController.h
//  ToDoApp
//
//  Created by Edo williams on 10/12/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@interface ViewController : UITableViewController <ItemDetailViewControllerDelegate>

- (IBAction) ReorderTable:(id)sender;

@end
