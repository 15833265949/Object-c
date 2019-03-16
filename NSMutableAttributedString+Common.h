

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Common)
//一句字符串中颜色和大小不一样
+(NSMutableAttributedString *)rangeStr:(NSString *)rangeStr
                               textStr:(NSString *)textStr
                            rangeColor:(UIColor *)rangeColor
                             rangeFont:(UIFont*)rangeFont;
@end
