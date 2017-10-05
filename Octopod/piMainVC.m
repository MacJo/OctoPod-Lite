//
//  piFirstViewController.m
//  Octopod
//
//  Created by Joao on 27.05.14.
//  Copyright (c) 2014 Joao P. C. Machacaz. All rights reserved.
//

#import "piMainVC.h"

@interface piMainVC ()

@end

@implementation piMainVC
@synthesize lbl_bedTemp,lbl_extruderTemp,lbl_filename,lbl_filesize,lbl_printTime,lbl_printTimeLeft,lbl_stateString,lbl_progress;
@synthesize pb_progress;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSUserDefaults *ud_server_url   = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *ud_key_url      = [NSUserDefaults standardUserDefaults];
    NSString *var_ud_server         = [ud_server_url objectForKey:@"server_url"];
    NSString *var_ud_apikey         = [ud_key_url objectForKey:@"key_url"];
        
    if ([var_ud_server length]!=0 || [var_ud_apikey length]!=0) {
        NSLog(@"Octopod is using a remote server!");
        //Making the labels invisibles
        [lbl_stateString    setAlpha:1],[lbl_bedTemp setAlpha:1],[lbl_extruderTemp setAlpha:1],[lbl_progress setAlpha:1],[lbl_printTimeLeft setAlpha:1],[lbl_printTime      setAlpha:1],[lbl_filename       setAlpha:1],[lbl_filesize       setAlpha:1] ;
        
        [self jsonrequest];
    }
    else{
        piMainVC *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];
        [self presentViewController:settingsVC animated:YES completion:nil];
        
        //Making the labels invisible
        [lbl_stateString    setAlpha:0],[lbl_bedTemp setAlpha:0],[lbl_extruderTemp setAlpha:0],[lbl_progress setAlpha:0],[lbl_printTimeLeft setAlpha:0],[lbl_printTime setAlpha:0],[lbl_filename setAlpha:0],[lbl_filesize setAlpha:0],
        
            NSLog(@"Octopod was not able to connect to the server!");
            serverAlert = [[UIAlertView alloc] initWithTitle:@"SERVER ALERT!" message:@"The server address or the key are missing!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [serverAlert show];
        
        NSLog(@"Firing the timer");
        [self timerFireMethod];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSLog(@"REQUEST SENT");
}

- (void) jsonrequest {
    NSUserDefaults *ud_server_url   = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *ud_key_url      = [NSUserDefaults standardUserDefaults];
    NSString *var_ud_server         = [ud_server_url objectForKey:@"server_url"];
    NSString *var_ud_apikey         = [ud_key_url objectForKey:@"key_url"];

    NSString *url_statement = [NSString stringWithFormat:@"/api/job"];
    
    NSString *myurl     = [NSString stringWithFormat:@"%@%@",var_ud_server,url_statement];
    NSURL *url = [NSURL URLWithString:myurl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Server URL: %@%@",var_ud_server,url_statement);
    NSLog(@"ApiKey: %@",var_ud_apikey);
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [self timerFireMethod];
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
    int cnt_stringstate = 0;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSString *stateString               = [json     objectForKey:@"state"];
    NSString *bedTemperature            = [[[json   objectForKey:@"temps"]      objectForKey:@"bed"]            objectForKey:@"actual"];
    NSString *extruderTemperature       = [[[json   objectForKey:@"temps"]      objectForKey:@"tool0"]          objectForKey:@"actual"];
    NSString *printTime                 = [[json    objectForKey:@"progress"]   objectForKey:@"printTime"];
    NSNumber *estimatedPrintTime        = [[json    objectForKey:@"progress"]   objectForKey:@"printTimeLeft"];
    NSNumber *progress                  = [[json    objectForKey:@"progress"]   objectForKey:@"completion"];
    NSString *filename                  = [[[json   objectForKey:@"job"]        objectForKey:@"file"]           objectForKey:@"name"];
    NSNumber *filesize                  = [[[json   objectForKey:@"job"]        objectForKey:@"file"]           objectForKey:@"size"];
    
    NSLog(@"%@  %@  %@  %@  %@ %@",stateString,printTime,estimatedPrintTime,filename,filesize, progress);
    NSLog(@"%@  %@",bedTemperature,extruderTemperature);
    
    
    if (stateString == (id)[NSNull null] || stateString.length == 0) {
        NSLog(@"stateString is Null");
        lbl_stateString.text = [NSString stringWithFormat:@"N/A"];
        cnt_stringstate++;
        NSLog(@"%i",cnt_stringstate);
    }
    else{
        lbl_stateString.text = [NSString stringWithFormat:@"%@...",stateString];
    }
    if (bedTemperature == (id)[NSNull null]) {
        NSLog(@"bed temperature is NULL --> %@ <--",bedTemperature);
        lbl_bedTemp.text = [NSString stringWithFormat:@"N/A"];
        
        cnt_stringstate++;
        NSLog(@"%i",cnt_stringstate);
    }
    else{
        lbl_bedTemp.text = [NSString stringWithFormat:@"%@ °C",bedTemperature];
    }
    if (extruderTemperature == (id)[NSNull null]) {
        NSLog(@"extruder temperature is NULL --> %@ <--",extruderTemperature);
        lbl_extruderTemp.text = [NSString stringWithFormat:@"N/A"];
        
        cnt_stringstate++;
        NSLog(@"%i",cnt_stringstate);
    }
    else{
        lbl_extruderTemp.text = [NSString stringWithFormat:@"%@ °C",extruderTemperature];
    }
    if (printTime == (id)[NSNull null]) {
        NSLog(@"print time is NULL --> %@ <--",printTime);
        lbl_printTime.text = [NSString stringWithFormat:@"N/A"];
        
        cnt_stringstate++;
        NSLog(@"%i",cnt_stringstate);
    }
    else{
        NSLog(@"Print time is printing!!!");
        lbl_printTime.text = [NSString stringWithFormat:@"%@",printTime];
    }
    if (estimatedPrintTime == (id)[NSNull null]) {
        NSLog(@"estimated print time is NULL --> %@ <--",estimatedPrintTime);
        lbl_printTimeLeft.text = [NSString stringWithFormat:@"N/A"];
        
        cnt_stringstate++;
        NSLog(@"%i",cnt_stringstate);
    }
    else{
        lbl_printTimeLeft.text = [NSString stringWithFormat:@"%@",estimatedPrintTime];
    }
    
    if (filename == (id)[NSNull null] || filename.length == 0) {
        NSLog(@"filename is NULL --> %@ <--",filename);
        lbl_filename.text = [NSString stringWithFormat:@"N/A"];
        
        cnt_stringstate++;
        NSLog(@"%i",cnt_stringstate);
    }
    else{
        lbl_filename.text = [NSString stringWithFormat:@"%@",filename];
    }
    if (filesize == (id)[NSNull null]) {
        NSLog(@"file size is NULL --> %@ <--",filesize);
        lbl_filesize.text = [NSString stringWithFormat:@"N/A"];
        
        cnt_stringstate++;
        NSLog(@"%i",cnt_stringstate);
    }
    else{
        lbl_filesize.text = [NSString stringWithFormat:@"%@ mb",filesize];
    }
    if (progress == (id)[NSNull null]) {
        NSLog(@"Progress is NULL --> %@ <--",progress);
        lbl_progress.text = [NSString stringWithFormat:@"N/A"];
        
        cnt_stringstate++;
        NSLog(@"%i",cnt_stringstate);
    }
    else{
        float var_progress  = [progress floatValue] / 100;
        float var_progress2  = [progress floatValue];
        int pr_progress     = (int)var_progress2;
        
        NSLog(@"var_prog1: %f",var_progress);
        NSLog(@"var_prog2: %f",var_progress2);
        
        lbl_progress.text = [NSString stringWithFormat:@"%d",pr_progress];//string
        pb_progress.progress = var_progress;//progress bar
    }
    
    if(cnt_stringstate > 10){
        NSLog(@"The number of null strings is superior to 10!!!No Labels available!");
        NSLog(@"Empty strings  == %i",cnt_stringstate);
        
        //Making the labels invisibles
        [lbl_stateString setAlpha:0],[lbl_bedTemp setAlpha:0],[lbl_extruderTemp setAlpha:0],[lbl_progress setAlpha:0],[lbl_printTimeLeft setAlpha:0],[lbl_printTime setAlpha:0],[lbl_filename setAlpha:0],[lbl_filesize setAlpha:0];
        
        //[img_waiting_octo setAlpha:1];
    }
    
    NSLog(@"Connection did finish loading");
    [self timerFireMethod];
}
- (void)connection:(NSURLConnection *)connection connectionDidFailWithError:(NSError *)error{
    NSLog(@"Connection did fail with error!!!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self timerFireMethod];
}
- (void)timerFireMethod{
    [time invalidate]; //invalidating the timer / setting it to zero
    time = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(jsonrequest) userInfo:nil repeats:YES];
    NSLog(@"%@",time);
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end