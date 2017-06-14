//
//  ViewController.m
//  JProperty
//
//  Created by alexiuce  on 2017/3/2.
//  Copyright © 2017年 io.github.alexiuce. All rights reserved.
//

#import "ViewController.h"
#import "DJProgressHUD.h"
#import "NSString+XCDictionary.h"



@interface ViewController ()<NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;
@property (unsafe_unretained) IBOutlet NSTextView *propertyTextView;
@property (weak) IBOutlet NSButton *jsonButton;

@property (assign, nonatomic) BOOL onceTime;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _jsonButton.enabled =  _jsonTextView.string.length;
    /** 这个很重要,不然竖直的英文引号会自动变为中文的弯引号,导致字符串解析错误 */
    _jsonTextView.automaticQuoteSubstitutionEnabled = NO;
    _propertyTextView.automaticQuoteSubstitutionEnabled = NO;
    _jsonTextView.delegate = self;
    _jsonTextView.font = [NSFont systemFontOfSize:18];
    _propertyTextView.font = _jsonTextView.font;
}


#pragma mark - JSON 转换Property 事件
- (IBAction)jsonClick:(NSButton *)sender {
    [self checkJsonText:_jsonTextView.string];
}
#pragma mark - Improt Plist
- (IBAction)importPlist:(NSButton *)sender {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    panel.allowsMultipleSelection = NO;     // 禁止多选
    panel.allowedFileTypes = @[@"plist"];   // 设置文件类型
    panel.directoryURL = [NSURL URLWithString:NSHomeDirectory()];           // 设置默认打开路径
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result != NSModalResponseOK) {return ;}
        NSURL *element = panel.URLs.firstObject;
        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfURL:element];
        NSString *text =  plistDict == nil ? @"@property (nonatomic, strong) NSArray *plistArray" : [NSString xc_propertyStingInDictioary:plistDict];
        [_propertyTextView.textStorage setAttributedString:[NSString xc_propertyAttributedString:text]];
    }];
}


#pragma mark - NSTextViewDelegate
- (void)textDidChange:(NSNotification *)notification{
    NSTextView *textView = notification.object;
    if (textView != _jsonTextView) {return;}
    _jsonButton.enabled = textView.string.length;
}
#pragma mark - 自定义方法
- (void)checkJsonText:(NSString *)json{
    NSString *st = [json stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    st = [st stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    st = [st stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    st = [st stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    st = [st stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *jsonData = [st dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        if (_onceTime == 0) {
            char cText[json.length];
            int index = 0;
            for (int i = 0; i < st.length; i ++) {
                char c = [st characterAtIndex:i];
                if (c == '\240' || c == '\302') {continue;}
                cText[index] = c;
                index++;
            }
            cText[index] = 0;
            NSString *csting = [NSString stringWithUTF8String:cText];
            _onceTime = 1;
            [self checkJsonText:csting];
        }else{
            DJProgressHUD *hud = [DJProgressHUD instance];
            hud.indicatorSize = CGSizeZero;
            [DJProgressHUD showStatus:@"JSON 内容格式有误,请检查确认~" FromView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [DJProgressHUD dismiss];
            });
            _onceTime = 0;
        }
        return;
    }
//       _propertyTextView.string
    NSString *text = [NSString xc_propertyStingInDictioary:jsonDict];
    
    [_propertyTextView.textStorage setAttributedString:[NSString xc_propertyAttributedString:text]];
    
//    [_propertyTextView insertText:[NSString xc_propertyAttributedString:text]];
//    _propertyTextView.attributedString = [NSString xc_propertyAttributedString:text];
    _onceTime = 0;
}
/** 清空内容 */
- (IBAction)emptyJSON:(NSButton *)sender {
    /** 在stroyBoard 中,设置了清楚JSON 按钮的tag值为100 */
    NSTextView *textView = sender.tag == 100 ? _jsonTextView : _propertyTextView;
    textView.string = @"";
}
/** copy内容到系统剪切板 */
- (IBAction)copyText:(NSButton *)sender {
     /** 在stroyBoard 中,设置了COPY JSON 按钮的tag值为200 */
   NSTextView *textView = sender.tag == 200 ? _jsonTextView : _propertyTextView;
    /** 如果内容为空,直接返回 */
    if (textView.string == nil || textView.string.length == 0) { return;}
    /** 清楚剪切板之前的内容 */
    [[NSPasteboard generalPasteboard] clearContents];
    /** 保存新内容到剪切板 */
    [[NSPasteboard generalPasteboard] setString:textView.string forType:NSStringPboardType];
}


@end
