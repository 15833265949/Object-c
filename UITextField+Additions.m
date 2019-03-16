

#import "UITextField+Additions.h"

@implementation UITextField (Additions)

- (NSRange)selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange)range
{
    UITextPosition* beginning = self.beginningOfDocument;
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= 13 && string.length > range.length) {
        return NO;
    }
    NSInteger lengthChange = string.length - range.length;
    BOOL rst = YES;
    //选中区域/光标位置
    NSRange sltRange = textField.selectedRange;
    sltRange.location += lengthChange;
    NSMutableString *mtbStr;
    //删除空格则删除空格前的字符串
    if ((range.location == 3 || range.location == 8) && range.length == 1 && !string.length && [[textField.text substringWithRange:range] isEqualToString:@" "]) {
        mtbStr = [textField.text stringByReplacingCharactersInRange:NSMakeRange(range.location-1, 1) withString:string].mutableCopy;
        sltRange.location --;
    } else {
        mtbStr = [textField.text stringByReplacingCharactersInRange:range withString:string].mutableCopy;
    }
    mtbStr = [mtbStr stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSBackwardsSearch range:NSMakeRange(sltRange.location, mtbStr.length - sltRange.location)].mutableCopy;
    //    NSLog(@"待加空格的字符串:%@", mtbStr);
    if (mtbStr.length > 3 && ![[mtbStr substringWithRange:NSMakeRange(3, 1)] isEqualToString:@" "]) {
        [mtbStr insertString:@" " atIndex:3];
        if (sltRange.location > 3) {
            sltRange.location ++;
        }
        rst = NO;
    }
    if (mtbStr.length > 8 && ![[mtbStr substringWithRange:NSMakeRange(8, 1)] isEqualToString:@" "]) {
        [mtbStr insertString:@" " atIndex:8];
        if (sltRange.location > 8) {
            sltRange.location ++;
        }
        rst = NO;
    }
    if (!rst) {
        textField.text = mtbStr;
        textField.selectedRange = sltRange;
    }
    return rst;
}

@end
