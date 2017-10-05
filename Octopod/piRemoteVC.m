//
//  piThirdViewController.m
//  Octopod
//
//  Created by Joao on 12.06.14.
//  Copyright (c) 2014 Joao P. C. Machacaz. All rights reserved.
//

#import "piRemoteVC.h"

@interface piRemoteVC ()

@end

@implementation piRemoteVC
@synthesize btn_down,btn_extrude,btn_home_xy,btn_left,btn_retract,btn_right,btn_up,btn_z_down,btn_z_up,btn_home_z,btn_extruder;


/*
 Nedd to import piFirstViewController so that the printer state is updated!
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    p_printhead = @"/api/printer/printhead";
    p_tool = @"/api/printer/tool";
    p_bed = @"/api/printer/bed";
    p_sd = @"/api/printer/sd";
    p_job = @"/api/job";
    p_logs = @"/api/logs";
    
    NSUserDefaults *ud_server_url   = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *ud_key_url      = [NSUserDefaults standardUserDefaults];
    var_ud_server         = [ud_server_url objectForKey:@"server_url"];
    var_ud_apikey         = [ud_key_url objectForKey:@"key_url"];
    
    NSLog(@"Server:%@ Key:%@", var_ud_server, var_ud_apikey);
    
    if ([var_ud_server length]!=0 || [var_ud_apikey length]!=0) {
        btn_up.enabled = YES;btn_down.enabled = YES;btn_left.enabled = YES;btn_right.enabled = YES;btn_z_up.enabled = YES;btn_z_down.enabled = YES;btn_home_z.enabled = FALSE;btn_home_xy.enabled = YES;btn_extruder.enabled = YES;btn_extrude.enabled = YES;btn_retract.enabled = YES;
    }
    else{
        btn_up.enabled = FALSE; btn_down.enabled = FALSE;btn_left.enabled = FALSE;btn_right.enabled = FALSE;btn_z_up.enabled = FALSE;btn_z_down.enabled = FALSE;btn_home_z.enabled = FALSE;btn_home_xy.enabled = FALSE;btn_extruder.enabled = FALSE;btn_extrude.enabled = FALSE;btn_retract.enabled = FALSE;
    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (NSString*)constructor : (NSString*) axe direction : (NSString*) axe_movement{
    NSString *command;
    
    var_ud_motor = 10;
    var_ud_extruder = 5;
    
    NSLog(@"Motor: %d  Extruder:%d",var_ud_motor,var_ud_extruder);
    
    //move x,y,z axe
    if ([axe isEqualToString:@"x"] || [axe isEqualToString:@"y"] || [axe isEqualToString:@"z"]) {
        command = [NSString stringWithFormat:@"{\"command\": \"jog\",\"%@\": %@%d}",axe,axe_movement,var_ud_motor];
    }
    //extrude and retract
    else if ([axe isEqualToString:@"e"]){
        command = [NSString stringWithFormat:@"{\"command\": \"extrude\",\"amount\": %@%d}",axe_movement,var_ud_extruder];
    }
    //home x,y
    else if ([axe isEqualToString:@"h"]){
        command = [NSString stringWithFormat:@"{\"command\": \"home\",\"axes\": [\"x\",\"y\"]}"];
    }
    else if ([axe isEqualToString:@"hz"]){
        command = [NSString stringWithFormat:@"{\"command\": \"home\",\"axes\": [\"z\"]}"];
    }
    //NSLog(@"Command:%@",command);
    return command;
}
- (void) send_data : (NSString*) statement execute : (NSString*) command{
    NSLog(@"Server: %@",var_ud_server);
    NSData *postData = [command dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",var_ud_server,statement]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:var_ud_apikey forHTTPHeaderField:@"X-Api-Key"];
    [request setHTTPBody:postData];
    
    //NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    NSLog(@"Server URL: %@%@",var_ud_server,statement);
    NSLog(@"ApiKey: %@",var_ud_apikey);
    NSLog(@"Post: %@",command);
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self]; /* WHAT A FUCK IS YOUR PROBLEM???*/
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    NSLog(@"Connection didReceivedData");
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{}

- (IBAction)btn_up:(UIButton *)sender {
    NSString *statement = p_printhead;
    NSString *axe = @"y";
    NSString *axe_movement = @"";
    NSString *command = [self constructor:axe direction:axe_movement];
    [self send_data:statement execute:command];
}
- (IBAction)btn_down:(UIButton *)sender {
    NSString *statement = p_printhead;
    NSString *axe = @"y";
    NSString *axe_movement = @"-";
    NSString *command = [self constructor:axe direction:axe_movement];
    [self send_data:statement execute:command];
}
- (IBAction)btn_left:(UIButton *)sender {
    NSString *statement = p_printhead;
    NSString *axe = @"x";
    NSString *axe_movement = @"-";
    NSString *command = [self constructor:axe direction:axe_movement];
    [self send_data:statement execute:command];
}
- (IBAction)btn_right:(UIButton *)sender {
    NSString *statement = p_printhead;
    NSString *axe = @"x";
    NSString *axe_movement = @"";
    NSString *command = [self constructor:axe direction:axe_movement];
    [self send_data:statement execute:command];
}
- (IBAction)btn_z_up:(UIButton *)sender {
    NSString *statement = p_printhead;
    NSString *axe = @"z";
    NSString *axe_movement = @"";
    NSString *command = [self constructor:axe direction:axe_movement];
    [self send_data:statement execute:command];
}
- (IBAction)btn_z_down:(UIButton *)sender {
    NSString *statement = p_printhead;
    NSString *axe = @"z";
    NSString *axe_movement = @"-";
    NSString *command = [self constructor:axe direction:axe_movement];
    [self send_data:statement execute:command];
}
- (IBAction)btn_home_xy:(UIButton *)sender {
    NSString *statement = p_printhead;
    NSString *axe = @"h";
    NSString *axe_movement = @"";
    NSString *command = [self constructor:axe direction:axe_movement];
    [self send_data:statement execute:command];
}

- (IBAction)btn_home_z:(UIButton *)sender {
    NSString *statement = p_printhead;
    NSString *axe = @"hz";
    NSString *axe_movement = @"";
    NSString *command = [self constructor:axe direction:axe_movement];
    [self send_data:statement execute:command];
}

- (IBAction)btn_extrude:(UIButton *)sender {
    NSLog(@"Extrude");
    NSString *statement = p_tool;
    NSString *axe = @"e";
    NSString *axe_movement = @"";
    NSString *command = [self constructor:axe direction:axe_movement];
    [self send_data:statement execute:command];
}
- (IBAction)btn_retract:(UIButton *)sender {
    NSLog(@"Retract");
    NSString *statement = p_printhead;
    NSString *axe = @"e";
    NSString *axe_movement = @"-";
    NSString *command = [self constructor:axe direction:axe_movement];
    [self send_data:statement execute:command];
}
- (IBAction)btn_extruder:(UIButton *)sender {
}
@end
