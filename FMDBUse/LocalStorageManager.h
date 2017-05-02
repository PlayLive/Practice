//
//  LocalStorageManager.h
//
//  Created by xiong on 2017/4/10.
//  Copyright © 2017年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface LocalStorageManager : NSObject

@property(nonatomic,strong,readonly) FMDatabase *db;

+(LocalStorageManager *)Instance;

-(BOOL)open;

-(BOOL)close;

@end
