//
//  ApplePayDataManager.m
//  
//
//  Created by xiong on 2017/4/29.
//  Copyright © 2017年 xiong. All rights reserved.
//

#import "ApplePayDataManager.h"

@interface ApplePayDataManager()

@property(nonatomic,strong) NSArray<NSString*> *tablePayOrderColumns;

@end

@implementation ApplePayDataManager

+(ApplePayDataManager *)Instance
{
    static ApplePayDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[ApplePayDataManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)initData{
    self.tablePayOrderColumns=@[PayOrderTable_ColumnName_OrderNo,PayOrderTable_ColumnName_ReceiptData,PayOrderTable_ColumnName_UserId];
    if([self open])
    {
        BOOL createTableResult=[[self db] executeUpdate:[self createTablesSql]];
        NSLog(@"createTableResult %@",createTableResult?@"YES":@"NO");
        [self close];
    }
}

-(FMDatabase *)db{
    return [LocalStorageManager Instance].db;
}

-(BOOL)open{
    return [[LocalStorageManager Instance] open];
}

-(BOOL)close{
    return [[LocalStorageManager Instance] close];
}

-(NSString *)createTablesSql
{
    return [NSString stringWithFormat:@"create table %@ (%@ text,%@ text,%@ integer)",TableName_PayOrder,PayOrderTable_ColumnName_OrderNo,PayOrderTable_ColumnName_ReceiptData,PayOrderTable_ColumnName_UserId];
}

-(BOOL)insertPayOrderNo:(NSString *)orderNo receiveData:(NSString *)receiveData
{
    if([self open])
    {
        NSString *sql=[NSString stringWithFormat:@"insert into %@ (%@,%@,%@) values ('%@','%@',%ld)",TableName_PayOrder,PayOrderTable_ColumnName_OrderNo,PayOrderTable_ColumnName_ReceiptData,PayOrderTable_ColumnName_UserId,orderNo,receiveData,(long)[self userID]];
        BOOL insertBool=[[self db] executeUpdate:sql];
        [self close];
        
        return insertBool;
    }
    return NO;
}

-(NSMutableArray<NSMutableDictionary*> *)selectPayOrderNo:(NSString *)orderNo
{
    if([self open])
    {
        NSString *sql=[NSString stringWithFormat:@"select * from %@ where %@='%@' and %@=%ld",TableName_PayOrder,PayOrderTable_ColumnName_OrderNo,PayOrderTable_ColumnName_UserId,orderNo,(long)[self userID]];
        FMResultSet *resultSet = [[self db] executeQuery:sql];
        NSMutableArray *mutableArray=[self getPayOrderListByFMResultSet:resultSet];
        [self close];
        return mutableArray;
    }
    return nil;
}

-(NSMutableArray<NSMutableDictionary*> *)selectPayOrderList
{
    if([self open])
    {
        NSString *sql=[NSString stringWithFormat:@"select * from %@ where %@=%ld",TableName_PayOrder,PayOrderTable_ColumnName_UserId,(long)[self userID]];
        
        FMResultSet *resultSet= [[self db] executeQuery:sql];
        NSMutableArray<NSMutableDictionary*> *mutableArray=[self getPayOrderListByFMResultSet:resultSet];
        [self close];
        return mutableArray;
    }
    return nil;
}

-(NSMutableArray<NSMutableDictionary*> *)getPayOrderListByFMResultSet:(FMResultSet *)resultSet{
    NSMutableArray<NSMutableDictionary*> *payOrderList=[[NSMutableArray<NSMutableDictionary*> alloc] init];
    if(resultSet==nil)
    {
        NSLog(@"select result is null");
        return payOrderList;
    }
    while([resultSet next])
    {
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] init];
        for(NSString *columnName in self.tablePayOrderColumns)
        {
            dictionary[columnName]=[resultSet stringForColumn:columnName];
        }
        [payOrderList addObject:dictionary];
    }
    return payOrderList;
}

-(BOOL)deletePayOrderNo:(NSString *)orderNo
{
    if([self open])
    {
        NSString *sql=[NSString stringWithFormat:@"delete from %@ where %@='%@' and %@=%ld",TableName_PayOrder,PayOrderTable_ColumnName_OrderNo,orderNo,PayOrderTable_ColumnName_UserId,(long)[self userID]];
        BOOL deleteResult=[[self db] executeUpdate:sql];
        [self close];
        return deleteResult;
    }
    return NO;
}

-(NSInteger)userID
{
    //使用你自己的userID
    return 10001;
}

@end
