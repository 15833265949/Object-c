

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)
- (void)pause;//暂停
- (void)resume;//开始
- (void)resumeWithTimeInterval:(NSTimeInterval)time;//多长时间后开始
//创建定时器
+ (NSTimer *)wy_scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void(^)(NSTimer *timer))block;
@end
