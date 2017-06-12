//
//  ReachabilityManager.m
//  HaiTang
//
//  Created by xiong on 2017/6/12.
//  Copyright © 2017年 xiong. All rights reserved.
//

#import "ReachabilityManager.h"

@interface ReachabilityManager()

@property(nonatomic,strong) Reachability *hostReachability;

@property(nonatomic,strong) Reachability *internetReachability;

@property(nonatomic,strong) void (^completeCallBack)();

@end

@implementation ReachabilityManager

+(ReachabilityManager *)Instance
{
    static ReachabilityManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ReachabilityManager alloc] init];
    });
    
    return instance;
}

-(void)setHostName:(NSString *)hostName complete:(void (^)())complete
{
    self.completeCallBack = complete;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChangedNotification:) name:kReachabilityChangedNotification object:nil];
    if(self.hostReachability==nil)
    {
        //判断 HTTP 链接是否可用
        self.hostReachability = [Reachability reachabilityWithHostName:hostName];
    }else
    {
        [self.hostReachability stopNotifier];
    }

    
    //判断 TCP/IP 是否可用
    if(self.internetReachability==nil)
    {
        self.internetReachability = [Reachability reachabilityForInternetConnection];
    }else
    {
        [self.internetReachability stopNotifier];
    }

}

-(void)start{
    if(self.hostReachability)
    {
        [self.hostReachability startNotifier];
    }
    if(self.internetReachability)
    {
        [self.internetReachability startNotifier];
    }
}

-(void)reachabilityChangedNotification:(NSNotification *)notification {
    Reachability *note = (Reachability *)notification.object;
    NSParameterAssert(note);
    if(self.completeCallBack)
    {
        self.completeCallBack();
    }
}


-(BOOL)canReachHttp
{
    return [self canReachable:self.hostReachability];
}

-(BOOL)canReachInternet
{
    return [self canReachable:self.internetReachability];
}

-(BOOL)canReachable:(Reachability *)reachability
{
    if(reachability == nil)
    {
        return NO;
    }
    NetworkStatus status = [reachability currentReachabilityStatus];
    return (status == ReachableViaWiFi || status == ReachableViaWWAN);

}

-(void)stop
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    if(self.hostReachability)
    {
        [self.hostReachability stopNotifier];
    }
    if(self.internetReachability)
    {
        [self.internetReachability stopNotifier];
    }
}

@end
