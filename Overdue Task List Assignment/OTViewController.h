//
//  OTViewController.h
//  Overdue Task List Assignment
//
//  Created by Eray Diler on 09/11/14.
//  Copyright (c) 2014 Eray Diler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTAddTaskViewController.h"
#import "OTDetailTaskViewController.h"
#import "OTTask.h"

@interface OTViewController : UIViewController <OTAddTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, OTDetailTaskViewControllerDelegate>

// Properties
@property (strong, nonatomic) NSMutableArray *taskObjects;

// IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// IBActions
- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender;

@end
