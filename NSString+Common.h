//
//  NSString+Common.h
//  DoctorAndPatientExchange
//
//  Created by 开发2 on 2017/7/11.
//  Copyright © 2017年 shuangYouZhiChun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SafeStr(...) [NSString safeString:__VA_ARGS__]

@interface NSString (Common)
- (NSString *)md5Str;
- (NSString*) sha1Str;
//计算字符串的高度
- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
//计算字符串的宽度
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (BOOL)hasListenChar;

//- (BOOL)isEmpty;

//是否为空
+ (BOOL)isEmpty:(NSString *)string;
///返回不为nil的字符串
+ (NSString *)safeString:(NSString *)string;
//时间戳转化为时间
+(NSString *)timeWithTimeIntervalString:(NSString *)timeString;

//字符串的CGSize
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font;
////一句字符串中颜色和大小不一样
//-(NSString *)rangeStr:(NSString *)rangeStr
//              textStr:(NSString *)textStr
//           rangeColor:(UIColor *)rangeColor
//            rangeFont:(UIFont *)rangeFont;

//输入框是 只包括数字,小数点,以及小数点后两位
+(BOOL)limitDotText:(NSString *)textStr
charactersInRange:(NSRange)range
replacementString:(NSString *)string;
@end
