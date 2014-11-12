//
//  OTDetailTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Eray Diler on 09/11/14.
//  Copyright (c) 2014 Eray Diler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTTask.h"
#import "OTEditTaskViewController.h"

@protocol OTDetailTaskViewControllerDelegate <NSObject>

@required
- (void)didUpdateTask;
- (void)didUpdateCompletedStatus:(OTTask *)task;

@end

@interface OTDetailTaskViewController : UIViewController <OTDetailTaskViewControllerDelegate, OTEditTaskViewControllerDelegate>

// Delegate property
@property (weak, nonatomic) id <OTDetailTaskViewControllerDelegate> delegate;

// IBOutlet
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

// IBAction
- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)changeCompleteStatusButtonPressed:(UIButton *)sender;

// Properties
@property (strong, nonatomic) OTTask *taskFromSegue;

@end
