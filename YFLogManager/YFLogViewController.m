//
//  YFLogViewController.m
//  YFLogManager
//
//  Created by Fynil on 2018/7/16.
//  Copyright © 2018年 Fynil. All rights reserved.
//

#import "YFLogViewController.h"
#import "YFLOGManager.h"

@interface YFLogViewController () <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation YFLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日志";
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor darkTextColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor]}];
    
    UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearLog)];
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishCheck)];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openTextWithOtherApp)];
    self.navigationItem.leftBarButtonItems = @[leftBBI];
    self.navigationItem.rightBarButtonItems = @[rightBBI,shareItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
}

- (void)viewDidAppear:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 1, 1)];
    });
}

- (void)openTextWithOtherApp {
    if (![[NSFileManager defaultManager] fileExistsAtPath:kYFLogPath]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无日志" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSURL *url = [NSURL fileURLWithPath:kYFLogPath isDirectory:NO];
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
    self.documentController.delegate = self;
    self.documentController.name = @"日志";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.documentController presentOpenInMenuFromRect:CGRectZero
                                               inView:self.view
                                             animated:YES];
    });
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller
       willBeginSendingToApplication:(NSString *)application
{
    
}


-(void)documentInteractionController:(UIDocumentInteractionController *)controller
          didEndSendingToApplication:(NSString *)application
{
    [controller dismissMenuAnimated:YES];
}


-(void)documentInteractionControllerDidDismissOpenInMenu: (UIDocumentInteractionController *)controller
{
    
}


- (void)finishCheck {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearLog {
    self.textView.text = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearLog" object:nil];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        _textView.frame = CGRectMake(0, 0, width, height - 64);
        _textView.editable = NO;
        NSString *path = kYFLogPath;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSString *logString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSMutableParagraphStyle* pStyle = [[NSMutableParagraphStyle alloc] init];
            pStyle.alignment = NSTextAlignmentLeft;
            pStyle.paragraphSpacing = 5;
            pStyle.lineSpacing = 3;
            pStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary* attArr = @{ NSFontAttributeName : [UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName : [UIColor darkGrayColor],
                                      NSParagraphStyleAttributeName : pStyle };
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:logString attributes:attArr];
            self.title = @"日志";
            self.textView.attributedText = string;
        }
    }
    return _textView;
}
@end
