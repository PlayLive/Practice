//
//  ReachabilityManager.h
//  HaiTang
//
//  Created by xiong on 2017/6/12.
//  Copyright © 2017年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject

+(ReachabilityManager *)Instance;

-(void)setHostName:(NSString*)hostName complete:(void(^)())complete;

-(BOOL)canReachHttp;

-(BOOL)canReachInternet;

-(void)start;

-(void)stop;

@end
