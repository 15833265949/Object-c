

#import <UIKit/UIKit.h>

@interface UITextField (Additions)

///获取焦点的位置
- (NSRange)selectedRange;
///设置焦点的位置
- (void)setSelectedRange:(NSRange)range;

@end
