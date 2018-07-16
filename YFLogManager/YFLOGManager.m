//
//  YFLOGManager.m
//  YFLogManager
//
//  Created by Fynil on 2018/7/16.
//  Copyright © 2018年 Fynil. All rights reserved.
//

#import "YFLOGManager.h"
#import "YFLogViewController.h"

@import AudioToolbox;

@implementation YFLOGManager

static YFLOGManager *manager;

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YFLOGManager alloc] init];
    });
    return manager;
}

- (void)registerLogMgr {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLog:) name:@"saveLog" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(checkLog) name:@"checkLog" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearLog) name:@"clearLog" object:nil];
}

- (void)saveLog: (NSNotification *)notification {
    NSDictionary *notify = notification.userInfo;
    NSString *logString = [notify valueForKey:@"log"];
    [self saveLogWithString:logString];
    
}

- (void)saveLogWithString: (NSString *)logString {
    logString = [self addDateToString:logString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = kYFLogPath;
    
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[logString dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}

- (NSString *)addDateToString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    NSInteger seconds = [timeZone secondsFromGMTForDate: [NSDate date]];
    NSDate *beiJingDate = [NSDate dateWithTimeInterval: seconds sinceDate: [NSDate date]];
    NSString *content = [NSString stringWithFormat:@"\n\n%@\n%@", [dateFormatter stringFromDate:beiJingDate], string];
    return content;
}

- (void)checkLog {
    
    NSString *path = kYFLogPath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        YFLogViewController *vc = [[YFLogViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        NSString *logString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSMutableParagraphStyle* pStyle = [[NSMutableParagraphStyle alloc] init];
//        pStyle.alignment = NSTextAlignmentLeft;
//        pStyle.paragraphSpacing = 5;
//        pStyle.lineSpacing = 2;
//        pStyle.lineBreakMode = NSLineBreakByWordWrapping;
//        NSDictionary* attArr = @{ NSFontAttributeName : [UIFont systemFontOfSize:14],
//                                  NSForegroundColorAttributeName : [UIColor darkGrayColor],
//                                  NSParagraphStyleAttributeName : pStyle };
//        NSAttributedString *string = [[NSAttributedString alloc] initWithString:logString attributes:attArr];
//        vc.title = @"日志";
//        vc.textView.attributedText = string;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    } else {
        if ([UIDevice currentDevice].systemVersion.floatValue > 7.8) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无日志" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无日志" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        }
    }
}

- (void)clearLog {
    NSString *path = kYFLogPath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error) {
            NSLog(@"删除日志失败");
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            NSLog(@"删除日志成功");
        }
    }
}

@end
