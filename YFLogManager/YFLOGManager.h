//
//  YFLOGManager.h
//  YFLogManager
//
//  Created by Fynil on 2018/7/16.
//  Copyright © 2018年 Fynil. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kYFDocumentPath (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject)
#define kYFLogPath ([kYFDocumentPath stringByAppendingPathComponent:@"YF_LOG.txt"])
/*
如果需要保存日志， 需要这样定义DebugLog
 */
#ifdef DEBUG

#define YFLog(fmt, ...) ((NSLog((@"%@" fmt), @"", ##__VA_ARGS__))); \
([[NSNotificationCenter defaultCenter] postNotificationName:@"saveLog" object:nil userInfo:@{@"log":[NSString stringWithFormat:fmt,##__VA_ARGS__]}]);

#else

#define YFLog(fmt, ...)

#endif

@interface YFLOGManager : NSObject

+ (instancetype)defaultManager;
- (void)registerLogMgr;

@end
