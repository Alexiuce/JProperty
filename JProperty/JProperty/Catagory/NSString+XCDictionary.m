//
//  NSString+XCDictionary.m
//  JProperty
//
//  Created by alexiuce  on 2017/5/24.
//  Copyright © 2017年 io.github.alexiuce. All rights reserved.
//

#import "NSString+XCDictionary.h"
#import <AppKit/AppKit.h>

@implementation NSString (XCDictionary)

+ (NSString *)xc_propertyStingInDictioary:(NSDictionary *)dict{
    // 遍历: 根据值类型来生成属性文本
    __block NSMutableString *propertyString = [NSMutableString string];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *text;
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSString *dataTyep =  [[(NSNumber *)obj stringValue] containsString:@"."]? @"CGFloat" : @"NSInteger";
            text =  [NSString stringWithFormat:@"@property (nonatomic, assign) %@ %@",dataTyep,key];
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
    return [propertyString copy];

}

+ (NSMutableAttributedString *)xc_propertyAttributedString:(NSString *)text{
    NSError *error = nil;
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:text];
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:@"@property" options:NSRegularExpressionCaseInsensitive error:&error];
    [regx enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [as setAttributes:@{NSForegroundColorAttributeName: [NSColor redColor]}range: result.range];
    }];
    NSRegularExpression *regx1 = [NSRegularExpression regularExpressionWithPattern:@"nonatomic, strong" options:NSRegularExpressionCaseInsensitive error:&error];
    [regx1 enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [as setAttributes:@{NSForegroundColorAttributeName: [NSColor purpleColor]}range: result.range];
    }];
    NSRegularExpression *regx2 = [NSRegularExpression regularExpressionWithPattern:@"nonatomic, copy" options:NSRegularExpressionCaseInsensitive error:&error];
    [regx2 enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [as setAttributes:@{NSForegroundColorAttributeName: [NSColor purpleColor]}range: result.range];
    }];
    NSRegularExpression *regx21 = [NSRegularExpression regularExpressionWithPattern:@"nonatomic, assign" options:NSRegularExpressionCaseInsensitive error:&error];
    [regx21 enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [as setAttributes:@{NSForegroundColorAttributeName: [NSColor purpleColor]}range: result.range];
    }];
    NSRegularExpression *regx3 = [NSRegularExpression regularExpressionWithPattern:@"NSArray | NSDictionary | NSString | CGFloat | NSInteger" options:NSRegularExpressionCaseInsensitive error:&error];
    [regx3 enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [as setAttributes:@{NSForegroundColorAttributeName: [NSColor blueColor]}range: result.range];
    }];
 
    
    [as addAttributes:@{NSFontNameAttribute : [NSFont systemFontOfSize:15]} range:NSMakeRange(0, as.length)];
    return as;
}

@end
