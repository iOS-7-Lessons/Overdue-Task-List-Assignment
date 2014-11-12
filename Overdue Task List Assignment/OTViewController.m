//
//  OTViewController.m
//  Overdue Task List Assignment
//
//  Created by Eray Diler on 09/11/14.
//  Copyright (c) 2014 Eray Diler. All rights reserved.
//

#import "OTViewController.h"
#import "OTAddTaskViewController.h"
#import "OTDetailTaskViewController.h"

@interface OTViewController ()

@end

@implementation OTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // To reset NSUserDefaults
    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:ARRAY_OF_TASK_DICTIONARIES];
    
//    NSArray *savedTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_OF_TASK_DICTIONARIES];
    
//    for (NSDictionary *dictionary in savedTasks) {
//        OTTask *task = [self returnTaskObjectFromDictionary:dictionary];
//        
//        BOOL isOverDue = [self isDateGreaterThanDate:[NSDate date] and:task.date];
//        
//        if (task.isCompleted) [self.completedTaskObjects addObject:task];
//        else if (isOverDue) [self.overdueTaskObjects addObject:task];
//        else [self.incompletedTaskObjects addObject:task];
//    }
    
    NSArray *savedTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:COMPLETED_TASK_OBJECT_KEY];
    for (NSDictionary *dictionary in savedTasks) {
        OTTask *task = [self returnTaskObjectFromDictionary:dictionary];
        [self.completedTaskObjects addObject:task];
    }
    savedTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:OVERDUE_TASK_OBJECT_KEY];
    for (NSDictionary *dictionary in savedTasks) {
        OTTask *task = [self returnTaskObjectFromDictionary:dictionary];
        [self.overdueTaskObjects addObject:task];
    }
    savedTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:INCOMPLETED_TASK_OBJECT_KEY];
    for (NSDictionary *dictionary in savedTasks) {
        OTTask *task = [self returnTaskObjectFromDictionary:dictionary];
        [self.incompletedTaskObjects addObject:task];
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Adjust background
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-image.jpg"]];
    
    // Make navigation bar transparent
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender {
    
    BOOL isEditingEnabled = self.tableView.editing;
    (isEditingEnabled) ? (self.tableView.editing = NO) : (self.tableView.editing = YES);
}

- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toAddTaskViewController" sender:sender];
}

#pragma mark - OTAddTaskViewControllerDelegate

- (void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didAddTask:(OTTask *)task
{
    BOOL isOverDue = [self isDateGreaterThanDate:[NSDate date] and:task.date];
    
    NSMutableArray *tasksArray;
    if (task.isCompleted) {
        [self.completedTaskObjects addObject:task];
        tasksArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:COMPLETED_TASK_OBJECT_KEY] mutableCopy];
        if ( !tasksArray ) tasksArray = [[NSMutableArray alloc] init];
        [tasksArray addObject:[self taskObjectAsAPropertyList:task]];
        [[NSUserDefaults standardUserDefaults] setObject:tasksArray forKey:COMPLETED_TASK_OBJECT_KEY];
    }
    else if (isOverDue) {
        [self.overdueTaskObjects addObject:task];
        tasksArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:OVERDUE_TASK_OBJECT_KEY] mutableCopy];
        if ( !tasksArray ) tasksArray = [[NSMutableArray alloc] init];
        [tasksArray addObject:[self taskObjectAsAPropertyList:task]];
        [[NSUserDefaults standardUserDefaults] setObject:tasksArray forKey:OVERDUE_TASK_OBJECT_KEY];
    }
    else {
        [self.incompletedTaskObjects addObject:task];
        tasksArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:INCOMPLETED_TASK_OBJECT_KEY] mutableCopy];
        if ( !tasksArray ) tasksArray = [[NSMutableArray alloc] init];
        [tasksArray addObject:[self taskObjectAsAPropertyList:task]];
        [[NSUserDefaults standardUserDefaults] setObject:tasksArray forKey:INCOMPLETED_TASK_OBJECT_KEY];
    }
    
//    NSMutableArray *arrayToBeSaved = [[[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_OF_TASK_DICTIONARIES] mutableCopy];
//    
//    if ( !arrayToBeSaved ) arrayToBeSaved = [[NSMutableArray alloc] init];
//    
//    [arrayToBeSaved addObject:[self taskObjectAsAPropertyList:task]];
//    [[NSUserDefaults standardUserDefaults] setObject:arrayToBeSaved forKey:ARRAY_OF_TASK_DICTIONARIES];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

#pragma mark - OTDetailTaskViewControllerDelegate

- (void)didUpdateTask
{
    [self saveTasks];
    [self.tableView reloadData];
}

- (void)didUpdateCompletedStatus:(OTTask *)task
{
    BOOL isOverDue = [self isDateGreaterThanDate:[NSDate date] and:task.date];
    
    NSUInteger row;
    NSIndexPath *indexPath;
    if (task.isCompleted) {
        row = [self.completedTaskObjects indexOfObject:task];
        [NSIndexPath indexPathForRow:row inSection:0];
    }
    else if (isOverDue) {
        row = [self.overdueTaskObjects indexOfObject:task];
        [NSIndexPath indexPathForRow:row inSection:1];
    }
    else {
        row = [self.incompletedTaskObjects indexOfObject:task];
        [NSIndexPath indexPathForRow:row inSection:2];
    }
    
//    NSUInteger row = [self.incompletedTaskObjects indexOfObject:task];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self updateCompletionOfTask:task forIndexPath:indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[OTAddTaskViewController class]]) {
        
        if ( [sender isKindOfClass:[UIBarButtonItem class]] ) {
            
            OTAddTaskViewController *targetVC = segue.destinationViewController;
            targetVC.delegate = self;
        }
    }
    
    if ( [segue.destinationViewController isKindOfClass:[OTDetailTaskViewController class]] ) {
        
        if ( [sender isKindOfClass:[NSIndexPath class]] ) {
            
            OTDetailTaskViewController *targetVC = segue.destinationViewController;
            NSIndexPath *indexPath = sender;
//            OTTask *task = self.incompletedTaskObjects[indexPath.row];
            OTTask *task;
            BOOL isOverDue = [self isDateGreaterThanDate:[NSDate date] and:task.date];
            
            if (task.isCompleted) task = self.completedTaskObjects[indexPath.row];
            else if (isOverDue) task = self.overdueTaskObjects[indexPath.row];
            else task = self.incompletedTaskObjects[indexPath.row];
            
            targetVC.taskFromSegue = task;
            targetVC.delegate = self;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.completedTaskObjects count];
            break;
        case 1:
            return [self.overdueTaskObjects count];
            break;
        case 2:
            return [self.incompletedTaskObjects count];
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    OTTask *task;
    switch (indexPath.section) {
        case 0:
            task = self.completedTaskObjects[indexPath.row];
            cell.backgroundColor = [self colorWithR:255.0 G:0.0 B:0.0 A:0.1];
            break;
        case 1:
            task = self.overdueTaskObjects[indexPath.row];
            cell.backgroundColor = [self colorWithR:0.0 G:0.0 B:0.0 A:0.5];
            break;
        case 2:
            task = self.incompletedTaskObjects[indexPath.row];
            cell.backgroundColor = [self colorWithR:0.0 G:0.0 B:0.0 A:0.0];
            break;
    }
    
//    OTTask *task = self.incompletedTaskObjects[indexPath.row];
//    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
//    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", task.title ];
    cell.detailTextLabel.text = [formatter stringFromDate:task.date];
//    
//    // Compare due date with current date
//    NSDate *currentDate = [NSDate date];
//    NSDate *endDate = task.date;
//    
//    BOOL isOverDue = [self isDateGreaterThanDate:currentDate and:endDate];
//    
//    if ( task.isCompleted ) cell.backgroundColor = [self colorWithR:255.0 G:0.0 B:0.0 A:0.1];
//    else if ( isOverDue ) cell.backgroundColor = [self colorWithR:0.0 G:0.0 B:0.0 A:0.5];
//    else cell.backgroundColor = [self colorWithR:0.0 G:0.0 B:0.0 A:0.0];
//    
//    // Customize accessory disclosure
    cell.accessoryView = [self customizeAccessoryButton];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    OTTask *task = [self.incompletedTaskObjects objectAtIndex:indexPath.row];
    OTTask *task;
    BOOL isOverDue = [self isDateGreaterThanDate:[NSDate date] and:task.date];
    
    if (task.isCompleted) task = [self.completedTaskObjects objectAtIndex:indexPath.row];
    else if (isOverDue) task = [self.overdueTaskObjects objectAtIndex:indexPath.row];
    else task = [self.incompletedTaskObjects objectAtIndex:indexPath.row];
    
    // update NSUserDefault data
    [self updateCompletionOfTask:task forIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray *taskList;
        switch (indexPath.section) {
            case 0:
                [self.completedTaskObjects removeObjectAtIndex:indexPath.row];
                taskList = [[[NSUserDefaults standardUserDefaults] arrayForKey:COMPLETED_TASK_OBJECT_KEY] mutableCopy];
                [taskList removeObjectAtIndex:indexPath.row];
                [[NSUserDefaults standardUserDefaults] setObject:taskList forKey:COMPLETED_TASK_OBJECT_KEY];
                break;
            case 1:
                [self.overdueTaskObjects removeObjectAtIndex:indexPath.row];
                taskList = [[[NSUserDefaults standardUserDefaults] arrayForKey:OVERDUE_TASK_OBJECT_KEY] mutableCopy];
                [taskList removeObjectAtIndex:indexPath.row];
                [[NSUserDefaults standardUserDefaults] setObject:taskList forKey:OVERDUE_TASK_OBJECT_KEY];
                break;
            case 2:
                [self.incompletedTaskObjects removeObjectAtIndex:indexPath.row];
                taskList = [[[NSUserDefaults standardUserDefaults] arrayForKey:INCOMPLETED_TASK_OBJECT_KEY] mutableCopy];
                [taskList removeObjectAtIndex:indexPath.row];
                [[NSUserDefaults standardUserDefaults] setObject:taskList forKey:INCOMPLETED_TASK_OBJECT_KEY];
                break;
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toDetailTaskViewController" sender:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // Get the moved task
//    OTTask *movedTask = [self.incompletedTaskObjects objectAtIndex:sourceIndexPath.row];
//    
//    // Arrange the self.incompletedTaskObjects
//    [self.incompletedTaskObjects removeObjectAtIndex:sourceIndexPath.row];
//    [self.incompletedTaskObjects insertObject:movedTask atIndex:destinationIndexPath.row];
    
    OTTask *movedTask;
    
    switch (sourceIndexPath.section) {
        case 0:
            movedTask = [self.completedTaskObjects objectAtIndex:sourceIndexPath.row];
            
            // Arrange the self.incompletedTaskObjects
            [self.completedTaskObjects removeObjectAtIndex:sourceIndexPath.row];
            [self.completedTaskObjects insertObject:movedTask atIndex:destinationIndexPath.row];
            break;
        case 1:
            movedTask = [self.overdueTaskObjects objectAtIndex:sourceIndexPath.row];
            
            // Arrange the self.incompletedTaskObjects
            [self.overdueTaskObjects removeObjectAtIndex:sourceIndexPath.row];
            [self.overdueTaskObjects insertObject:movedTask atIndex:destinationIndexPath.row];
            break;
        case 2:
            movedTask = [self.incompletedTaskObjects objectAtIndex:sourceIndexPath.row];
            
            // Arrange the self.incompletedTaskObjects
            [self.incompletedTaskObjects removeObjectAtIndex:sourceIndexPath.row];
            [self.incompletedTaskObjects insertObject:movedTask atIndex:destinationIndexPath.row];
            break;
    }
    
    [self saveTasks];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    
    switch (section) {
        case 0:
            [label setText:[NSString stringWithFormat:@"Completed Tasks"]];
            break;
        case 1:
            [label setText:[NSString stringWithFormat:@"Overdue Tasks"]];
            break;
        case 2:
            [label setText:[NSString stringWithFormat:@"Incompleted Tasks"]];
            break;
    }
    label.textColor = [UIColor grayColor];
    return label;
}

#pragma mark - Lazy instantiations

- (NSMutableArray *)incompletedTaskObjects
{
    if ( !_incompletedTaskObjects ) {
        _incompletedTaskObjects = [[ NSMutableArray alloc] init];
    }
    
    return _incompletedTaskObjects;
}

- (NSMutableArray *)completedTaskObjects
{
    if ( !_completedTaskObjects ) {
        _completedTaskObjects = [[ NSMutableArray alloc] init];
    }
    
    return _completedTaskObjects;
}

- (NSMutableArray *)overdueTaskObjects
{
    if ( !_overdueTaskObjects ) {
        _overdueTaskObjects = [[ NSMutableArray alloc] init];
    }
    
    return _overdueTaskObjects;
}
#pragma mark - Helper Methods

- (NSDictionary *)taskObjectAsAPropertyList:(OTTask *)taskObject
{
    NSDictionary *dictionary = @{TASK_TITLE: taskObject.title,
                                 TASK_DESCRIPTION: taskObject.desc,
                                 TASK_DATE: taskObject.date,
                                 TASK_COMPLETION: @(taskObject.isCompleted)};
    
    return dictionary;
}

- (OTTask *)returnTaskObjectFromDictionary:(NSDictionary *)dictionary
{
    OTTask *task = [[OTTask alloc] initWithData:dictionary];
    
    return task;
}

- (BOOL)isDateGreaterThanDate:(NSDate *)date and:(NSDate *)toDate
{
    if ( [date timeIntervalSince1970] > [toDate timeIntervalSince1970] ) {
        return YES;
    }
    
    return NO;
}

- (void)updateCompletionOfTask:(OTTask *)task forIndexPath:(NSIndexPath *)indexPath
{
    
//    NSMutableArray *incompletedTaskObjectsAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_OF_TASK_DICTIONARIES] mutableCopy];
//    
//    if ( !incompletedTaskObjectsAsPropertyList ) incompletedTaskObjectsAsPropertyList = [[NSMutableArray alloc] init];
//    
//    [incompletedTaskObjectsAsPropertyList removeObjectAtIndex:indexPath.row];
//    
//    if ( task.isCompleted == YES ) task.isCompleted = NO;
//    else task.isCompleted = YES;
//    
//    [incompletedTaskObjectsAsPropertyList insertObject:[self taskObjectAsAPropertyList:task] atIndex:indexPath.row];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:incompletedTaskObjectsAsPropertyList forKey:ARRAY_OF_TASK_DICTIONARIES];
    
    if ( task.isCompleted == YES ) task.isCompleted = NO;
        else task.isCompleted = YES;
    
    NSMutableArray *taskObjectsAsPropertyList;
    switch (indexPath.section) {
        case 0:
            taskObjectsAsPropertyList = [[[NSUserDefaults standardUserDefaults]
                                          arrayForKey:COMPLETED_TASK_OBJECT_KEY]
                                         mutableCopy];
            if ( !taskObjectsAsPropertyList ) taskObjectsAsPropertyList = [[NSMutableArray alloc] init];
            [taskObjectsAsPropertyList removeObjectAtIndex:indexPath.row];
            [taskObjectsAsPropertyList insertObject:[self taskObjectAsAPropertyList:task]
                                            atIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyList
                                                      forKey:COMPLETED_TASK_OBJECT_KEY];
            break;
        case 1:
            taskObjectsAsPropertyList = [[[NSUserDefaults standardUserDefaults]
                                          arrayForKey:OVERDUE_TASK_OBJECT_KEY]
                                         mutableCopy];
            if ( !taskObjectsAsPropertyList ) taskObjectsAsPropertyList = [[NSMutableArray alloc] init];
            [taskObjectsAsPropertyList removeObjectAtIndex:indexPath.row];
            [taskObjectsAsPropertyList insertObject:[self taskObjectAsAPropertyList:task]
                                            atIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyList
                                                      forKey:OVERDUE_TASK_OBJECT_KEY];
            break;
        case 2:
            taskObjectsAsPropertyList = [[[NSUserDefaults standardUserDefaults]
                                          arrayForKey:INCOMPLETED_TASK_OBJECT_KEY]
                                         mutableCopy];
            if ( !taskObjectsAsPropertyList ) taskObjectsAsPropertyList = [[NSMutableArray alloc] init];
            [taskObjectsAsPropertyList removeObjectAtIndex:indexPath.row];
            [taskObjectsAsPropertyList insertObject:[self taskObjectAsAPropertyList:task]
                                            atIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyList
                                                      forKey:INCOMPLETED_TASK_OBJECT_KEY];
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

- (void)saveTasks
{
    NSMutableArray *tasksArray = [[NSMutableArray alloc] init];
    
//    for (OTTask *taskObject in self.incompletedTaskObjects) {
//        [tasksArray addObject:[self taskObjectAsAPropertyList:taskObject]];
//    }
//    
//    // Save array into NSUserDefaults
//    [[NSUserDefaults standardUserDefaults] setObject:tasksArray forKey:ARRAY_OF_TASK_DICTIONARIES];
    
    for (OTTask *taskObject in self.completedTaskObjects) {
        [tasksArray addObject:[self taskObjectAsAPropertyList:taskObject]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tasksArray forKey:COMPLETED_TASK_OBJECT_KEY];
    
    [tasksArray removeAllObjects];
    for (OTTask *taskObject in self.overdueTaskObjects) {
        [tasksArray addObject:[self taskObjectAsAPropertyList:taskObject]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tasksArray forKey:OVERDUE_TASK_OBJECT_KEY];
    
    [tasksArray removeAllObjects];
    for (OTTask *taskObject in self.incompletedTaskObjects) {
        [tasksArray addObject:[self taskObjectAsAPropertyList:taskObject]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tasksArray forKey:INCOMPLETED_TASK_OBJECT_KEY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)accessoryButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
		
	{
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}

- (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

- (UIButton *)customizeAccessoryButton
{
    // Customize accessory disclosure
    UIImage *image = [UIImage imageNamed:@"info-35.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(44.0, 44.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(accessoryButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    return button;
}

@end
