//
//  piSecondViewController.h
//  Octopod
//
//  Created by Joao on 27.05.14.
//  Copyright (c) 2014 Joao P. C. Machacaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface piSecondViewController : UIViewController{
    NSArray *arraydata;
    NSMutableData *data;
    NSTimer *time;
    
    NSUserDefaults *ud_server;
    NSUserDefaults *ud_apikey;
    
    NSString *var_ud_server;
    NSString *var_ud_apikey;
}

@property (strong, nonatomic) IBOutlet UITextField *txt_server;
@property (strong, nonatomic) IBOutlet UITextField *txt_key;

@property (strong, nonatomic) IBOutlet UIButton *btn_connect;
@property (strong, nonatomic) IBOutlet UIButton *btn_disconnect;

- (IBAction)txt_server:(UITextField *)sender;
- (IBAction)txt_key:(UITextField *)sender;
- (IBAction)textfieldReturn:(id)sender;

- (IBAction)btn_connect:(UIButton *)sender;
- (IBAction)btn_disconnect:(UIButton *)sender;

- (NSString*)constructor : (NSString*) action;
@end
