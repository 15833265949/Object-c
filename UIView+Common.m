

#import "UIView+Common.h"
#import <objc/runtime.h>

@interface UIView()

@end

@implementation UIView (Common)
static char  BlankPageViewKey;

//找到View所在的控制器
-(UIViewController *)findViewController
{
    for (UIView * next = self; next; next = next.superview) {
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = width;
    if (!color) {
        self.layer.borderColor = [UIColor redColor].CGColor;
    }else{
        self.layer.borderColor = color.CGColor;
    }
}

- (void)canResignFirst {
    UIGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirst)];
    [self addGestureRecognizer:ges];
    self.userInteractionEnabled = YES;
}

- (void)resignFirst {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
#pragma mark BlankPageView
- (void)setBlankPageView:(EaseBlankPageView *)blankPageView{
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}
- (EaseBlankPageView *)blankPageView{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

-(void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block
{
    [self configBlankPage:blankPageType hasData:hasData hasError:hasError offsetY:0 reloadButtonBlock:block];
}

-(void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadButtonBlock:(void (^)(id))block
{
    if (hasData) {
        if (self.blankPageView) {
            self.blankPageView.hidden = YES;
            [self.blankPageView removeFromSuperview];
        }
    }
    else{
        if (!self.blankPageView) {
            self.blankPageView = [[EaseBlankPageView alloc] initWithFrame:self.bounds];
        }
        self.blankPageView.hidden = NO;
        [[self blankPageContainer] insertSubview:self.blankPageView atIndex:0];
        [self.blankPageView configWithType:blankPageType hasData:hasData hasError:hasError offSetY:offsetY reloadButtonBlock:block];
    }
}

-(UIView *)blankPageContainer
{
    UIView * blankPageContainer = self;
    for (UIView * aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}
@end
@implementation EaseBlankPageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)configWithType:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError offSetY:(CGFloat)offSetY reloadButtonBlock:(void(^)(id sender))block
{
    
    _curType = blankPageType;
    _reloadButtonBlock = block;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_loadAndShowStatusBlock) {
            _loadAndShowStatusBlock();
        }
    });
    
    if (hasData) {
        [self removeFromSuperview];
        return;
    }
    
    self.alpha = 1.0;
    
    //占位图片
    if (!_monkeyView) {
        _monkeyView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _monkeyView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_monkeyView];
    }
    //标题
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor greenColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    //文字
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _tipLabel.backgroundColor = [UIColor redColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = kFont(30.0f);
        _tipLabel.textColor = RGBColor(153, 153, 153);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
    }
    
    //按钮
    if (!_actionButton) {
        _actionButton = ({
            UIButton * button = [UIButton new];
            button.backgroundColor = [UIColor greenColor];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button;
        });
        
        [self addSubview:_actionButton];
    }
    
    //重新加载按钮
    if (!_reloadButton) {
        _reloadButton = ({
            UIButton * button = [UIButton new];
            button.backgroundColor = mainColor;
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [button addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button;
        });
        
        [self addSubview:_reloadButton];
    }
    
    NSString * imageName , * titleStr , * tipStr;
    NSString * buttonTitle;
    
    if (hasError) {
        //加载失败
        _actionButton.hidden = YES;
        tipStr = @"呀,网络出了问题";
        imageName = @"";//图片的名字
        buttonTitle = @"重新连接网络";
    }
    else{
        //空白数据
        _reloadButton.hidden = YES;
        //类型
        switch (_curType) {
            case EaseBlankPageTypeView:
            {
                tipStr = @"暂无数据";
                break;
            }
            default:
                break;
        }
    }
    
    imageName = imageName ?: @"blankpage_image_Default";
    UIButton * bottomBtn = hasError ? _reloadButton : _actionButton;
    _monkeyView.image = [UIImage imageNamed:imageName];
    _titleLabel.text = titleStr;
    _tipLabel.text = tipStr;
    [bottomBtn setTitle:buttonTitle forState:UIControlStateNormal];
    _titleLabel.hidden = titleStr.length <= 0;
    bottomBtn.hidden = buttonTitle.length <= 0;
    
    //布局
    if (ABS(offSetY) > 0 ) {
        self.frame = CGRectMake(0, offSetY, self.width, self.height);
    }
    
    [_monkeyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_bottom).multipliedBy(0.15);
        make.size.mas_equalTo(CGSizeMake(160, 160));
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(_monkeyView.mas_bottom);
    }];
    
    [_tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel);
        if (titleStr.length > 0) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        }
        else{
            make.top.equalTo(_monkeyView.mas_bottom);
        }
    }];
    
    [bottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(130, 44));
        make.top.equalTo(_tipLabel.mas_bottom).offset(25);
    }];
    
}
//新增按钮点击事件
-(void)btnAction
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_clickButtonBlock) {
            _clickButtonBlock(_curType);
        }
    });
}
//重新加载按钮
-(void)reloadButtonClicked:(UIButton *)sender
{
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_reloadButtonBlock) {
            _reloadButtonBlock(sender);
        }
    });
}
@end
