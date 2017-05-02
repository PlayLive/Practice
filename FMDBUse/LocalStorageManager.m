//
//  LocalStorageManager.m
//
//  Created by xiong on 2017/4/10.
//  Copyright © 2017年 xiong. All rights reserved.
//

#import "LocalStorageManager.h"

#define LocalStorageDataBase_Name @"localStorage.sqlite"

@interface LocalStorageManager()

@property(nonatomic,strong) FMDatabase *database;

@end

@implementation LocalStorageManager

+(LocalStorageManager *)Instance{
    static LocalStorageManager *singleInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleInstance=[[LocalStorageManager alloc] init];
    });
    return singleInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDataBase];
    }
    return self;
}

-(void)initDataBase{
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *databasePath=[documentPath stringByAppendingPathComponent:LocalStorageDataBase_Name];
    
    self.database=[FMDatabase databaseWithPath:databasePath];
}

-(FMDatabase *)db
{
    return self.database;
}

-(BOOL)open
{
    return [self.database open];
}

-(BOOL)close{
    return [self.database close];
}

@end
