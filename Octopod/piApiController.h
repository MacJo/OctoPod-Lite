//
//  piApiController.h
//  Octopod
//
//  Created by Joao on 13.07.14.
//  Copyright (c) 2014 Joao P. C. Machacaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface piApiController : NSObject{
    NSString *p_printhead;
    NSString *p_tool;
    NSString *p_bed;
    NSString *p_sd;
    NSString *p_job;
    NSString *p_logs;
    
    NSString *g_printhead;
    NSString *g_tool;
    NSString *g_bed;
    NSString *g_sd;
    NSString *g_job;
    NSString *g_logs;
}

- (void)controllerCommands;
@end
