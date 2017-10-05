//
//  piSecondViewController.m
//  Octopod
//
//  Created by Joao on 27.05.14.
//  Copyright (c) 2014 Joao P. C. Machacaz. All rights reserved.
//

#import "piServerVC.h"

@interface piServerVC ()

@end

@implementation piServerVC
@synthesize txt_server,txt_key;
@synthesize btn_connect,btn_disconnect;

- (void)viewDidLoad{
    [super viewDidLoad];
    //NSString *url_statement;
    
    ud_server = [NSUserDefaults standardUserDefaults];
    ud_apikey = [NSUserDefaults standardUserDefaults];
    
    var_ud_server = [ud_server objectForKey:@"server_url"];
    var_ud_apikey = [ud_apikey objectForKey:@"key_url"];
    
    txt_server.text = var_ud_server;
    txt_key.text = var_ud_apikey;
    
    [btn_connect setAlpha:0];
    [btn_disconnect setAlpha:1];
    
    if (!txt_server) {
        [btn_connect setAlpha:0];
        [btn_disconnect setAlpha:0];
    }
    
    /* Handling connection*/
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/connection",var_ud_server]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:var_ud_apikey forHTTPHeaderField:@"X-Api-Key"];

    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (NSString*)constructor : (NSString*) action{
    NSString *command;
    
    //move x,y,z axe
    if ([action isEqualToString:@"connect"] || [action isEqualToString:@"disconnect"]) {
        command = [NSString stringWithFormat:@"{\"command\": \"%@\",\"autoconnect\":false}",action];
    }
    //extrude and retract
    else{
        NSLog(@"Was not able to connect to the printer!");
    }
    
    return command;
}
- (void) send_data : (NSString*) statement execute : (NSString*) command{
    NSString *server = [NSString stringWithFormat:@"%@",var_ud_server];
    
    NSData *postData = [command dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",server,statement]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:var_ud_apikey forHTTPHeaderField:@"X-Api-Key"];
    [request setHTTPBody:postData];
    
    //NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    NSLog(@"Server URL: %@%@",server,statement);
    NSLog(@"ApiKey: %@",var_ud_apikey);
    NSLog(@"Post: %@",command);
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    data = [[NSMutableData alloc] init];
    NSLog(@"Connection did receive response!!!");
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)thedata{
    [data appendData:thedata];
    NSLog(@"Connection did receive data!!!");
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSString *stateString               = [json objectForKey:@"state"];
    
    NSLog(@" Current State: %@",stateString);
    
    if ([stateString isEqualToString:@"Closed"]) {
        [btn_disconnect setAlpha:0];
        [btn_connect setAlpha:1];
    }
    else{
        [btn_disconnect setAlpha:1];
        [btn_connect setAlpha:0];
    }
    
    NSLog(@"Connection did finish loading");
}
- (void)connection:(NSURLConnection *)connection connectionDidFailWithError:(NSError *)error{
    NSLog(@"Connection did fail with error!!!");
}

/*BUTTONS*/
- (IBAction)txt_server:(UITextField *)sender {
    NSString *server_url = txt_server.text;
    NSUserDefaults *ud_server_url = [NSUserDefaults standardUserDefaults];
    [ud_server_url setObject:server_url forKey:@"server_url"];
    [ud_server_url synchronize];
    NSLog(@"Server_Url is: %@", server_url);
    [self viewDidLoad];
}
- (IBAction)txt_key:(UITextField *)sender {
    NSString *key_url = txt_key.text;
    NSUserDefaults *ud_key_url = [NSUserDefaults standardUserDefaults];
    [ud_key_url setObject:key_url forKey:@"key_url"];
    [ud_key_url synchronize];
    NSLog(@"The key is: %@", key_url);
    [self viewDidLoad];
}
- (IBAction)textfieldReturn:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)btn_connect:(UIButton *)sender {
    NSString *statement = @"/api/connection";
    NSString *action = @"connect";
    if ([var_ud_server length]!=0 || [var_ud_apikey length]!=0) {
        NSString *command = [self constructor:action];78¨
        [self send_data:statement execute:command];
        //[self timerFireMethod];
    }
    else{
        NSLog(@"Octopod was not able to connect to the server!");
        UIAlertView *serverAlert = [[UIAlertView alloc] initWithTitle:@"SERVER ALERT!" message:@"The server's address or the key are not correct or missing!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [serverAlert show];
    }
}
- (IBAction)btn_disconnect:(UIButton *)sender {
    NSString *statement = @"/api/connection";
    NSString *action = @"disconnect";
    if ([var_ud_server length]!=0 || [var_ud_apikey length]!=0) {
        NSString *command = [self constructor:action];
        [self send_data:statement execute:command];
        //[self timerFireMethod];
    }
    else{
        NSLog(@"Octopod was not able to connect to the server!");
        UIAlertView *serverAlert = [[UIAlertView alloc] initWithTitle:@"SERVER ALERT!" message:@"The server's address or the key are not correct or missing!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [serverAlert show];
    }
}

- (void)timerFireMethod{
    [time invalidate];
    time = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(viewDidLoad) userInfo:nil repeats:NO];
}
@end