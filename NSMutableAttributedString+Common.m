

#import "NSMutableAttributedString+Common.h"

@implementation NSMutableAttributedString (Common)
//一句字符串中颜色和大小不一样
+(NSMutableAttributedString *)rangeStr:(NSString *)rangeStr
                               textStr:(NSString *)textStr
                            rangeColor:(UIColor *)rangeColor
                             rangeFont:(UIFont *)rangeFont
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSRange boldRange = [[str string]rangeOfString:rangeStr options:NSCaseInsensitiveSearch];
    [str addAttribute:NSForegroundColorAttributeName value:rangeColor range:boldRange];
    [str addAttribute:NSFontAttributeName value:rangeFont range:boldRange];
    return str;
}
@end
