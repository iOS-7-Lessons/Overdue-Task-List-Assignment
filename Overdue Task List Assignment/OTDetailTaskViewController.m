//
//  OTDetailTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Eray Diler on 09/11/14.
//  Copyright (c) 2014 Eray Diler. All rights reserved.
//

#import "OTDetailTaskViewController.h"
#import "OTEditTaskViewController.h"

@interface OTDetailTaskViewController ()

@end

@implementation OTDetailTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.taskFromSegue.title;
    self.descriptionLabel.text = self.taskFromSegue.description;
    
    self.dateLabel.text = [self convertDateIntoString:self.taskFromSegue.date];
    
    // Adjust background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-image.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ( [segue.destinationViewController isKindOfClass:[OTEditTaskViewController class]] ) {
        
        OTEditTaskViewController *targetVC = segue.destinationViewController;
        // in this line connects two taskFromSegue objects in two different controllers
        // because taskFromSegue remains in the heap we can manage changes made in OTEditTaskViewController
        // from this controller
        targetVC.taskFromSegue = self.taskFromSegue;
        targetVC.delegate = self;
    }
}

#pragma mark - Actions

- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toEditTaskViewController" sender:sender];
}

- (IBAction)changeCompleteStatusButtonPressed:(UIButton *)sender {
    [self didUpdateCompletedStatus:self.taskFromSegue];
}

#pragma mark - Helper Methods

- (NSString *)convertDateIntoString:(NSDate *)date
{
    NSString *string = [[NSString alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    string = [dateFormatter stringFromDate:self.taskFromSegue.date];
    
    return string;
}

- (NSDate *)convertStringToDate:(NSString *)string
{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    date = [dateFormatter dateFromString:string];
    
    return date;
}

#pragma mark - OTEditTaskViewControllerDelegate

- (void)updateTask
{
    self.titleLabel.text = self.taskFromSegue.title;
    self.descriptionLabel.text = self.taskFromSegue.description;
    self.dateLabel.text = [self convertDateIntoString:self.taskFromSegue.date];
    
    [self didUpdateTask];
}

- (void)updateCompletedStatus:(OTTask *)task
{
    [self.delegate didUpdateCompletedStatus:task];
}

#pragma mark - OTDetailTaskViewControllerDelegate

- (void)didUpdateTask
{
    [self.delegate didUpdateTask];
}

- (void)didUpdateCompletedStatus:(OTTask *)task
{
    [self.delegate didUpdateCompletedStatus:task];
}

@end
