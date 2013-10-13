//
//  TodoListItem.m
//  ToDoApp
//
//  Created by Edo williams on 10/12/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import "TodoListItem.h"

@implementation TodoListItem

@synthesize text, checked;

- (void)toggleChecked
{
    self.checked = !self.checked;
}

//Implement the delegate for encoding the array of TodolistItems to plist
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
}

//here we decode the object from the plist and put into our TodoListItem
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init])){
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
    }
    
    return self;
}

@end
