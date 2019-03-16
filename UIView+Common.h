

#import <UIKit/UIKit.h>
@class EaseBlankPageView;
typedef NS_ENUM(NSInteger , EaseBlankPageType){
    
    EaseBlankPageTypeView = 0,//空白页
    
};

@interface UIView (Common)

- (UIViewController *)findViewController;
- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;
- (void)canResignFirst;

#pragma mark BlankPageView
@property (strong, nonatomic) EaseBlankPageView *blankPageView;
- (void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;
- (void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadButtonBlock:(void(^)(id sender))block;

@end


@interface EaseBlankPageView :UIView

@property (nonatomic,strong) UIImageView * monkeyView;
@property (nonatomic,strong) UILabel * tipLabel , * titleLabel;
@property (nonatomic,strong) UIButton * reloadButton , * actionButton;

@property (nonatomic,assign) EaseBlankPageType curType;
@property (nonatomic,copy) void(^reloadButtonBlock)(id sender);
@property (nonatomic,copy) void(^loadAndShowStatusBlock)(void);
@property (nonatomic,copy) void(^clickButtonBlock)(EaseBlankPageType curType);

-(void)configWithType:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError offSetY:(CGFloat)offSetY reloadButtonBlock:(void(^)(id sender))block;

@end
