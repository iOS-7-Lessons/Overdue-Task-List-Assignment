//
//  OTEditTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Eray Diler on 09/11/14.
//  Copyright (c) 2014 Eray Diler. All rights reserved.
//

#import "OTEditTaskViewController.h"

@interface OTEditTaskViewController ()

@end

@implementation OTEditTaskViewController

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
    self.taskTitleTextField.text = self.taskFromSegue.title;
    self.descriptionTextView.text = self.taskFromSegue.description;
    self.dateDatePicker.date = self.taskFromSegue.date;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
    self.taskFromSegue.title = self.taskTitleTextField.text;
    self.taskFromSegue.description = self.descriptionTextView.text;
    self.taskFromSegue.date = self.dateDatePicker.date;
    
    [self updateTask];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTask
{
    [self.delegate updateTask];
}

@end
