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
    
    // Assigning self to delegates.
    self.taskNameTextField.delegate = self;
    self.descriptionTextView.delegate = self;
    
    // Adjust background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-image.jpg"]];
    
    // Adjust outlets' borders
    self.taskNameTextField.layer.borderWidth = 1.0;
    self.taskNameTextField.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.descriptionTextView.layer.borderWidth = 1.0;
    self.descriptionTextView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    //self.dueDatePicker.layer.borderWidth = 1.0;
    
    // Adjust textField's tint
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.taskNameTextField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [text isEqualToString:@"\n"] ) {
        [textView resignFirstResponder];
    }
    
    return YES;
}


@end
