//
//  piApiController.m
//  Octopod
//
//  Created by Joao on 13.07.14.
//  Copyright (c) 2014 Joao P. C. Machacaz. All rights reserved.
//

#import "piApiController.h"

@implementation piApiController

- (void)controllerCommands{
    p_printhead = @"/api/printer/printhead";
    p_tool = @"/api/printer/tool";
    p_bed = @"/api/printer/bed";
    p_sd = @"/api/printer/sd";
    p_job = @"/api/job";
    p_logs = @"/api/logs";
    
    g_printhead = @"/api/printer/printhead";
    g_tool = @"/api/printer/tool";
    g_bed = @"/api/printer/bed";
    g_sd = @"/api/printer/sd";
    g_job = @"/api/job";
    g_logs = @"/api/logs";
}
@end
