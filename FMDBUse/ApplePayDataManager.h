//
//  ApplePayDataManager.h
//
//  Created by xiong on 2017/4/29.
//  Copyright © 2017年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocalStorageManager.h"

//支付订单表名字
#define TableName_PayOrder @"ApplePayReceiveDatas"

#pragma mark - 支付订单表的列名称
//支付订单的订单号
#define PayOrderTable_ColumnName_OrderNo @"orderNo"
//支付订单的订单数据
#define PayOrderTable_ColumnName_ReceiptData @"receiptData"
//用户ID
#define PayOrderTable_ColumnName_UserId @"uid"

@interface ApplePayDataManager : NSObject

+(ApplePayDataManager *)Instance;

-(BOOL)insertPayOrderNo:(NSString *)orderNo receiveData:(NSString *)receiveData;

-(NSMutableArray<NSMutableDictionary*> *)selectPayOrderNo:(NSString *)orderNo;

-(NSMutableArray<NSMutableDictionary*> *)selectPayOrderList;

-(BOOL)deletePayOrderNo:(NSString *)orderNo;

@end
