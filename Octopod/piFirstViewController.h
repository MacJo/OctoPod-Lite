//
//  piFirstViewController.h
//  Octopod
//
//  Created by Joao on 27.05.14.
//  Copyright (c) 2014 Joao P. C. Machacaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface piFirstViewController : UIViewController{
    NSArray *arraydata;
    NSMutableData *data;
    NSTimer *time;
    IBOutlet UIAlertView *serverAlert;
}

@property (strong, nonatomic) IBOutlet UILabel *lbl_stateString;
@property (strong, nonatomic) IBOutlet UILabel *lbl_extruderTemp;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bedTemp;
@property (strong, nonatomic) IBOutlet UILabel *lbl_printTime;
@property (strong, nonatomic) IBOutlet UILabel *lbl_printTimeLeft;
@property (strong, nonatomic) IBOutlet UILabel *lbl_filename;
@property (strong, nonatomic) IBOutlet UILabel *lbl_filesize;
@property (strong, nonatomic) IBOutlet UILabel *lbl_progress;

@property (strong, nonatomic) IBOutlet UIProgressView *pb_progress;
@property (strong, nonatomic) IBOutlet UIImageView *img_waiting_octo;

-(void)jsonrequest;
-(void)timerFireMethod;

@end