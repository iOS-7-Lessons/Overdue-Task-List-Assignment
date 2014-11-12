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
    
    NSArray *savedTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_OF_TASK_DICTIONARIES];
    
    for (NSDictionary *dictionary in savedTasks) {
        OTTask *task = [self returnTaskObjectFromDictionary:dictionary];
        [self.taskObjects addObject:task];
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
    [self.taskObjects addObject:task];
    NSMutableArray *arrayToBeSaved = [[[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_OF_TASK_DICTIONARIES] mutableCopy];
    
    if ( !arrayToBeSaved ) arrayToBeSaved = [[NSMutableArray alloc] init];
    
    [arrayToBeSaved addObject:[self taskObjectAsAPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:arrayToBeSaved forKey:ARRAY_OF_TASK_DICTIONARIES];
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
    NSUInteger row = [self.taskObjects indexOfObject:task];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
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
            OTTask *task = self.taskObjects[indexPath.row];
            targetVC.taskFromSegue = task;
            targetVC.delegate = self;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.taskObjects count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    OTTask *task = self.taskObjects[indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", task.title ];
    cell.detailTextLabel.text = [formatter stringFromDate:task.date];
    
    // Compare due date with current date
    NSDate *currentDate = [NSDate date];
    NSDate *endDate = task.date;
    
    BOOL isOverDue = [self isDateGreaterThanDate:currentDate and:endDate];
    
    if ( task.isCompleted ) cell.backgroundColor = [self colorWithR:255.0 G:0.0 B:0.0 A:0.1];
    else if ( isOverDue ) cell.backgroundColor = [self colorWithR:0.0 G:0.0 B:0.0 A:0.5];
    else cell.backgroundColor = [self colorWithR:0.0 G:0.0 B:0.0 A:0.0];
    
    // Customize accessory disclosure
    UIImage *image = [UIImage   imageNamed:@"info-35.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(44.0, 44.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(accessoryButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    cell.accessoryView = button;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTTask *task = [self.taskObjects objectAtIndex:indexPath.row];
    
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
        
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *taskList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_OF_TASK_DICTIONARIES] mutableCopy];
        [taskList removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:taskList forKey:ARRAY_OF_TASK_DICTIONARIES];
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
    OTTask *movedTask = [self.taskObjects objectAtIndex:sourceIndexPath.row];
    
    // Arrange the self.taskObjects
    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
    [self.taskObjects insertObject:movedTask atIndex:destinationIndexPath.row];
    
    [self saveTasks];
}

#pragma mark - Lazy instantiations

- (NSMutableArray *)taskObjects
{
    if ( !_taskObjects ) {
        _taskObjects = [[ NSMutableArray alloc] init];
    }
    
    return _taskObjects;
}

#pragma mark - Helper Methods

- (NSDictionary *)taskObjectAsAPropertyList:(OTTask *)taskObject
{
    NSDictionary *dictionary = @{TASK_TITLE: taskObject.title,
                                 TASK_DESCRIPTION: taskObject.description,
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
//    [self.taskObjects removeObjectAtIndex:indexPath.row];
//    NSLog(@"%@", self.taskObjects);
//    [self.taskObjects insertObject:task atIndex:indexPath.row];
//    NSLog(@"%@", self.taskObjects);
    
    NSMutableArray *taskObjectsAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_OF_TASK_DICTIONARIES] mutableCopy];
    
    if ( !taskObjectsAsPropertyList ) taskObjectsAsPropertyList = [[NSMutableArray alloc] init];
    
    [taskObjectsAsPropertyList removeObjectAtIndex:indexPath.row];
//    NSLog(@"%@", taskObjectsAsPropertyList);
    
    if ( task.isCompleted == YES ) task.isCompleted = NO;
    else task.isCompleted = YES;
    
    [taskObjectsAsPropertyList insertObject:[self taskObjectAsAPropertyList:task] atIndex:indexPath.row];
//    NSLog(@"%@", taskObjectsAsPropertyList);
    
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyList forKey:ARRAY_OF_TASK_DICTIONARIES];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

- (void)saveTasks
{
    NSMutableArray *tasksArray = [[NSMutableArray alloc] init];
    
    for (OTTask *taskObject in self.taskObjects) {
        [tasksArray addObject:[self taskObjectAsAPropertyList:taskObject]];
    }
    
    // Save array into NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:tasksArray forKey:ARRAY_OF_TASK_DICTIONARIES];
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

@end
