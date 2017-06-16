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
#import <ACEView.h>



@interface ViewController ()<NSTextViewDelegate,WebFrameLoadDelegate>

@property (unsafe_unretained) IBOutlet ACEView *jsonTextView;
@property (weak) IBOutlet ACEView *displayView;


@property (weak) IBOutlet NSButton *startButton;

@property (weak) IBOutlet NSButton *deleteButton;

@property (weak) IBOutlet NSButton *plistButton;

@property (weak) IBOutlet NSButton *xmlButton;

@property (assign, nonatomic) BOOL onceTime;
/** 底部提示信息 */
@property (weak) IBOutlet NSTextField *infoTextField;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    /** 这个很重要,不然竖直的英文引号会自动变为中文的弯引号,导致字符串解析错误 */
//    _jsonTextView.automaticQuoteSubstitutionEnabled = NO;
//    _jsonTextView.font = [NSFont systemFontOfSize:18];
    _startButton.toolTip = @"begin";
    _deleteButton.toolTip = @"empty text";
    _plistButton.toolTip = @"open plist file";
    _xmlButton.toolTip = @"open xml file";
   
}
- (void)viewWillAppear{
    [super viewWillAppear];
    static dispatch_once_t onceToken;
    
    
    dispatch_once(&onceToken, ^{
        [self.jsonTextView setShowInvisibles: NO];
        [self.jsonTextView setShowLineNumbers:NO];
        [self.jsonTextView setShowGutter:NO];
        [self.jsonTextView setMode:ACEModeJSON];
        [self.jsonTextView setString:@"the content should be JSON format,such as :\n{\"name\":\"alex\",\"job\":\"Mac OSX developer\"}\nplist/xml file be supported, also"];
        
        [self.displayView setReadOnly:YES];
        [self.displayView setMode:ACEModeJSON];
        [self.displayView setTheme:ACEThemeSolarizedDark];
        [self.displayView setShowInvisibles:NO];
    });
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
        NSString *js = [NSString stringWithFormat:@"{\"filepath\":\"%@\"}",element.path];
        [self.jsonTextView setString:js];
//        NSString *text =  plistDict == nil ? @"@property (nonatomic, strong) NSArray *plistArray" : [NSString xc_propertyStingInDictioary:plistDict];
//        [self.displayView setString:text];
        NSData *jsdata = [NSJSONSerialization dataWithJSONObject:plistDict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jt = [[NSString alloc]initWithData:jsdata encoding:NSUTF8StringEncoding];
        [self.displayView setString:jt];
//        [_propertyTextView.textStorage setAttributedString:[NSString xc_propertyAttributedString:text]];
    }];
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
            [self emptyJSON:nil];
            self.infoTextField.stringValue = error.localizedDescription;
            _onceTime = 0;
        }
        return;
    }
    
    NSString *text = [NSString xc_propertyStingInDictioary:jsonDict];
    NSLog(@"text %@",text);
    if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
        NSData *jsdata = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jt = [[NSString alloc]initWithData:jsdata encoding:NSUTF8StringEncoding];
        [self.displayView setMode:ACEModeJSON];
        [self.displayView setString:jt];
        self.infoTextField.stringValue = @"";
    }
    _onceTime = 0;
}
/** 清空内容 */
- (IBAction)emptyJSON:(NSButton *)sender {
    [self.displayView setString:@""];
}
/** 打开导入的xml文件 */
- (IBAction)openXml:(id)sender {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    panel.allowsMultipleSelection = NO;     // 禁止多选
    panel.allowedFileTypes = @[@"xml"];   // 设置文件类型
    panel.directoryURL = [NSURL URLWithString:NSHomeDirectory()];           // 设置默认打开路径
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result != NSModalResponseOK) {return ;}
        NSURL *element = panel.URLs.firstObject;
        NSData *xmlData = [NSData dataWithContentsOfURL:element];
        NSError *error = nil;
        NSXMLDocument *xmlDocument = [[NSXMLDocument alloc]initWithData:xmlData options:NSXMLNodePreserveAll error:&error];
        NSString *js = [NSString stringWithFormat:@"{\"filepath\":\"%@\"}",element.path];
        [self.jsonTextView setString:js];
        
        if (error) {
            [self emptyJSON:nil];
            self.infoTextField.stringValue = error.localizedDescription;
            return;}
        self.infoTextField.stringValue = @"";
        [self.displayView setMode:ACEModeXML];
        [self.displayView setString:[xmlDocument XMLStringWithOptions:NSXMLNodePrettyPrint]];
        
        //        [_propertyTextView.textStorage setAttributedString:[NSString xc_propertyAttributedString:text]];
    }];
}





///** copy内容到系统剪切板 */
//- (IBAction)copyText:(NSButton *)sender {
//     /** 在stroyBoard 中,设置了COPY JSON 按钮的tag值为200 */
//    NSTextView *textView =  _jsonTextView ;
//    /** 如果内容为空,直接返回 */
//    if (textView.string == nil || textView.string.length == 0) { return;}
//    /** 清楚剪切板之前的内容 */
//    [[NSPasteboard generalPasteboard] clearContents];
//    /** 保存新内容到剪切板 */
//    [[NSPasteboard generalPasteboard] setString:textView.string forType:NSStringPboardType];
//}


@end
