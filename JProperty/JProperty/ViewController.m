//
//  ViewController.m
//  JProperty
//
//  Created by alexiuce  on 2017/3/2.
//  Copyright © 2017年 io.github.alexiuce. All rights reserved.
//

#import "ViewController.h"
#import "DJProgressHUD.h"

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
#pragma mark - Properyt 转换 JSON 事件
- (IBAction)propertyClick:(NSButton *)sender {

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
    // 遍历: 根据值类型来生成属性文本
    __block NSMutableString *propertyString = [NSMutableString string];
    [jsonDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *text;
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSString *dataTyep =  [[(NSNumber *)obj stringValue] containsString:@"."]? @"CGFloat" : @"NSInteger";
            text =  [NSString stringWithFormat:@"@property (nonatomic, assign) %@ %@",key,dataTyep];
        }else if ([obj isKindOfClass:[NSString class]]){
            text = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@",key];
        }else if ([obj isKindOfClass:[NSArray class]]){
            text = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@",key];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
             text = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@",key];
        }else if ([obj isKindOfClass:[NSNull class]]){
            text = [NSString stringWithFormat:@"@property (nonatomic, strong) id %@",key];
        }
        [propertyString appendFormat:@"%@\n",text];
    }];
    _propertyTextView.string = propertyString;
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
