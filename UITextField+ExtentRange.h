

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

-(NSRange)selectedRange;
-(void)setSelectedRange:(NSRange)range;


//改变占位符颜色
-(void)changePlaceTextClocor:(UIColor *)color;//kvc
//改变占位符字体大小
-(void)changePlaceTextFont:(UIFont *)font;//kvc


@end
