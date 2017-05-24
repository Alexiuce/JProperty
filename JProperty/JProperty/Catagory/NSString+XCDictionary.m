//
//  NSString+XCDictionary.m
//  JProperty
//
//  Created by alexiuce  on 2017/5/24.
//  Copyright © 2017年 io.github.alexiuce. All rights reserved.
//

#import "NSString+XCDictionary.h"

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

@end
