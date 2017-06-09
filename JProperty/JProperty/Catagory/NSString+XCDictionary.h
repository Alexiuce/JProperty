//
//  NSString+XCDictionary.h
//  JProperty
//
//  Created by alexiuce  on 2017/5/24.
//  Copyright © 2017年 io.github.alexiuce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XCDictionary)

+ (NSString *)xc_propertyStingInDictioary:(NSDictionary *)dict;
+ (NSMutableAttributedString *)xc_propertyAttributedString:(NSString *)text;
@end
