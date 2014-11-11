//
//  OTAddTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Eray Diler on 09/11/14.
//  Copyright (c) 2014 Eray Diler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTTask.h"

@protocol OTAddTaskViewControllerDelegate <NSObject>

- (void)didCancel;
- (void)didAddTask:(OTTask *)task;

@end

@interface OTAddTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

// Delegate
@property (weak, nonatomic) id <OTAddTaskViewControllerDelegate> delegate;

// IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDatePicker;

// IBActions
- (IBAction)addTaskButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;


@end
