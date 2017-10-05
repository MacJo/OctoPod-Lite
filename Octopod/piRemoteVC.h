//
//  piThirdViewController.h
//  Octopod
//
//  Created by Joao on 12.06.14.
//  Copyright (c) 2014 Joao P. C. Machacaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface piRemoteVC: UIViewController{
    int var_ud_motor;
    int var_ud_extruder;
    
    NSUserDefaults *ud_server;
    NSUserDefaults *ud_apikey;
    NSUserDefaults *ud_motor;
    NSUserDefaults *ud_extruder;
    
    NSString *var_ud_server;
    NSString *var_ud_apikey;
    
    NSString *p_printhead;
    NSString *p_tool;
    NSString *p_bed;
    NSString *p_sd;
    NSString *p_job;
    NSString *p_logs;
}
@property (strong, nonatomic) IBOutlet UIButton *btn_up;
@property (strong, nonatomic) IBOutlet UIButton *btn_down;
@property (strong, nonatomic) IBOutlet UIButton *btn_left;
@property (strong, nonatomic) IBOutlet UIButton *btn_right;
@property (strong, nonatomic) IBOutlet UIButton *btn_z_up;
@property (strong, nonatomic) IBOutlet UIButton *btn_z_down;
@property (strong, nonatomic) IBOutlet UIButton *btn_home_xy;
@property (strong, nonatomic) IBOutlet UIButton *btn_home_z;


@property (strong, nonatomic) IBOutlet UIButton *btn_extruder;
@property (strong, nonatomic) IBOutlet UIButton *btn_extrude;
@property (strong, nonatomic) IBOutlet UIButton *btn_retract;

@property (strong, nonatomic) IBOutlet UISegmentedControl *sc_mv_distance;
@property (strong, nonatomic) IBOutlet UITextField *tf_extruder;

- (IBAction)btn_up:(UIButton *)sender;
- (IBAction)btn_down:(UIButton *)sender;
- (IBAction)btn_left:(UIButton *)sender;
- (IBAction)btn_right:(UIButton *)sender;
- (IBAction)btn_z_up:(UIButton *)sender;
- (IBAction)btn_z_down:(UIButton *)sender;
- (IBAction)btn_home_xy:(UIButton *)sender;
- (IBAction)btn_home_z:(UIButton *)sender;
- (IBAction)btn_extruder:(UIButton *)sender;
- (IBAction)btn_extrude:(UIButton *)sender;
- (IBAction)btn_retract:(UIButton *)sender;

- (NSString*)constructor : (NSString*) axe direction : (NSString*) axe_movement;
@end