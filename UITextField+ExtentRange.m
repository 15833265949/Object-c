

#import "UITextField+ExtentRange.h"

@implementation UITextField (ExtentRange)
//获取光标的位置
-(NSRange)selectedRange
{
    UITextPosition * beginning = self.beginningOfDocument;
    
    UITextRange * selectedRange = self.selectedTextRange;
    UITextPosition * selectionStart = selectedRange.start;
    UITextPosition * selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}
//改变光标的位置
-(void)setSelectedRange:(NSRange)range
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
    
}

//改变占位符颜色
-(void)changePlaceTextClocor:(UIColor *)color
{
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

//改变占位符字体大小
-(void)changePlaceTextFont:(UIFont *)font
{
    [self setValue:font forKeyPath:@"_placeholderLabel.font"];
}




@end
