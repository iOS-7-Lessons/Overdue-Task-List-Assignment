//
//  OTEditTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Eray Diler on 09/11/14.
//  Copyright (c) 2014 Eray Diler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTTask.h"

@protocol OTEditTaskViewControllerDelegate <NSObject>

@required;
- (void)updateTask;
- (void)updateCompletedStatus:(OTTask *)task;

@end

@interface OTEditTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

// Delegate property
@property (weak, nonatomic) id <OTEditTaskViewControllerDelegate> delegate;

// IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *taskTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateDatePicker;

// Properties
@property (strong, nonatomic) OTTask *taskFromSegue;
@property (strong, nonatomic) NSIndexPath *indexPathFromSegue;

// IBActions
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)chnageCompleteStatusButtonPressed:(UIButton *)sender;

@end
