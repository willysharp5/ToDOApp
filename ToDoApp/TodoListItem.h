//
//  TodoListItem.h
//  ToDoApp
//
//  Created by Edo williams on 10/12/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoListItem : NSObject <NSCoding> //Add the delegate to allow for encoding of plist

@property (nonatomic, copy) NSString *text; //usd to store the label text
@property (nonatomic, assign) BOOL checked; //usd for the checkmark
- (void)toggleChecked;

@end
