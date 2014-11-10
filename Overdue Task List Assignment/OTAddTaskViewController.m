//
//  OTAddTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Eray Diler on 09/11/14.
//  Copyright (c) 2014 Eray Diler. All rights reserved.
//

#import "OTAddTaskViewController.h"

@interface OTAddTaskViewController ()

@end

@implementation OTAddTaskViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTaskButtonPressed:(UIButton *)sender {
    [self.delegate didAddTask:[self returnTaskObject]];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.delegate didCancel];
}

#pragma mark - Helper Methods

- (OTTask *)returnTaskObject {
    
    OTTask *taskObject = [[OTTask alloc] init];
    
    taskObject.title = self.taskNameTextField.text;
    taskObject.description = self.descriptionTextView.text;
    taskObject.date = self.dueDatePicker.date;
    taskObject.isCompleted = NO;
    
    return taskObject;
}
@end
