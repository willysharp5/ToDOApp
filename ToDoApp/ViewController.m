//
//  ViewController.m
//  ToDoApp
//
//  Created by Edo williams on 10/12/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import "ViewController.h"
#import "TodoListItem.h"

@interface ViewController ()

@end

@implementation ViewController {
    //create an array of Items
    NSMutableArray *items;
}

//Create a Document Directory to save the data for persistance
- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

//create a file plist in the document directory
- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"ToDoList.plist"];
}

//takes the contents of our array and converts it in two steps to binary and writes to the file
- (void)saveTodolistItems
{
    NSMutableData *data = [[NSMutableData alloc] init];
    //is a Form of NSCoder that creates a plist file, encodes the array in binary form
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //wite the data into a specifield file name
    [archiver encodeObject:items forKey:@"TodolistItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}


- (void)loadTodoListItems{
    NSString *path = [self dataFilePath]; //store file path
    //check if the file pathe exist
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        //load contains of the TodoListItems from the plist file
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        items = [unarchiver decodeObjectForKey:@"TodolistItems"];
        [unarchiver finishDecoding];
    }
    else {
        //if no file path exist meaning no values in the TodolistItems, then create an array of TodoItems
        items = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

    
//use this to initialize the ToDoItems from the plist and load to tableview
- (id)initWithCoder:(NSCoder *)aDecoder{
    //initialize aDecoder and assign to self
    //if self is not nil, return a refrence to self and call the loadToDolistItems
    if ((self = [super initWithCoder:aDecoder])) {
        [self loadTodoListItems];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add reorder buton
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Reorder" style:UIBarButtonItemStyleBordered target:self action:@selector(ReorderTable:)];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    
    
    //NSLog(@"Document Directory %@", [self documentsDirectory]);
    //NSLog(@"Data file %@", [self dataFilePath]);
    
    /*
    //create array objects
    items = [[NSMutableArray alloc] initWithCapacity:20];
    
    //creat an array of todo list
    TodoListItem *item;
    
    //Add values to this array of items
    item = [[TodoListItem alloc] init];
    item.text = @"Buy Grocery";
    item.checked = NO;
    [items addObject:item];
    
    item = [[TodoListItem alloc] init];
    item.text = @"Go Home";
    item.checked = NO;
    [items addObject:item];
     */
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Allows us to set the row checkmark to checked and unchecked when table view is ran
- (void)configureCheckmarkForCell:(UITableViewCell *)cell withToDoListItem:(TodoListItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    
    if(item.checked) {
        label.text = @"√";
    }
    else {
        label.text = @"";
    }
}

//Allows us to set the label text
- (void)configuretextForCell:(UITableViewCell *)cell withToDolistItem:(TodoListItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = item.text;
}


//This tells the TableView how many rows to display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //set the number of table rows to array value as it grows
    return [items count];
}

//This tells the TableView what Row to display
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoListItem"];
    
    //get the array that contains the object at the index with row number
    TodoListItem *item = [items objectAtIndex:indexPath.row];
    
    //set the text and check mark one each row
    [self configuretextForCell:cell withToDolistItem:item];
    [self configureCheckmarkForCell:cell withToDoListItem:item];
    
    return cell;
}

//Allows for selecting a row with animation and toggle the checkmark
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //get the array that contains the object at the index with row number
    TodoListItem *item = [items objectAtIndex:indexPath.row];
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withToDoListItem:item];
    
    //save the data to plist
    [self saveTodolistItems];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//Delete row action
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //this removes the items from the row
    [items removeObjectAtIndex:indexPath.row];
    
    //remove the data from plist
    [self saveTodolistItems];
    
    //this removes the corresponding row from the table view
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


//attach the segue to the disclosure control in tableview
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //here we sending the object of TodoLisitem (item) to ItemDetailViewController through its delegate
    TodoListItem *item = [items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EditItem" sender:item];
}

//The implementation of the delegates for the cancel and done tool bar buttom
- (void)ItemDetailViewControllerDidCancel:(ItemDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



//Reorder table delegates
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [items count] ) {
        return NO;
    }
    return YES;
}


//Reorder table delegates
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [items count]) {
        return NO;
    }
    return YES;
}

//Reorder table delegates
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    TodoListItem *item = [items objectAtIndex:fromIndexPath.row];
    [items removeObjectAtIndex:fromIndexPath.row];
    [items insertObject:item atIndex:toIndexPath.row];
}

//Reorder table delegates
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if ([proposedDestinationIndexPath row] < [items count]) {
        return proposedDestinationIndexPath;
    }
    NSIndexPath *betterIndexPath = [NSIndexPath indexPathForRow:[items count]-1 inSection:0];
    return betterIndexPath;
}

//Reorder the Table method
- (IBAction) ReorderTable:(id)sender{
    
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.navigationItem.leftBarButtonItem setTitle:@"Reorder"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}


//delegate to add ToDolistItem object
- (void)ItemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(TodoListItem *)item
{
    //Insert the new objects into our array of items
    int newRowIndex = [items count];
    [items addObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //save the data to plist
    [self saveTodolistItems];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Implement the delegate for the Editing ToDoListItem
- (void)ItemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(TodoListItem *)item
{
    //Find the correspondng text in the tableview and update it
    int index = [items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configuretextForCell:cell withToDolistItem:item];
    
    //save the data to plist
    [self saveTodolistItems];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//let ItemDetailViewController know that ViewController is now it's delegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AddItem"]){
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *) navigationController.topViewController;
        controller.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"EditItem"]){
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.itemToEdit = sender; //this contains todolist object to be edited
        
    }
}




@end
