
#import "UIControl+XPTime.h"

@implementation UIControl (XPTime)


#pragma mark ----- 用于替换系统方法的自定义方法

- (void)custom_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    // 是否小于设定的时间间隔
    if ([target isKindOfClass:[UITabBar class]]) {
         [self custom_sendAction:action to:target forEvent:event];
    }else{
        BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.custom_acceptEventTime >= self.custom_acceptEventInterval);
        // 更新上一次点击时间戳
        if (self.custom_acceptEventInterval > 0) {
            self.custom_acceptEventTime = NSDate.date.timeIntervalSince1970;
        }
        if (needSendAction) {
            // 两次点击的时间间隔小于设定的时间间隔时，才执行响应事件
            [self custom_sendAction:action to:target forEvent:event];
        }else{
            return;
        }
    }
}

- (NSTimeInterval )custom_acceptEventTime{
    
    return [objc_getAssociatedObject(self, "UIControl_acceptEventTime") doubleValue];
}

- (void)setCustom_acceptEventTime:(NSTimeInterval)custom_acceptEventTime{
    
    objc_setAssociatedObject(self, "UIControl_acceptEventTime", @(custom_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


#pragma mark ------ 关联

- (NSTimeInterval )custom_acceptEventInterval{
    if ([objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue]) {
        return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
    }
    return 2;
    //    return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
}

- (void)setCustom_acceptEventInterval:(NSTimeInterval)custom_acceptEventInterval{
    
    objc_setAssociatedObject(self, "UIControl_acceptEventInterval", @(custom_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
