

#import <UIKit/UIKit.h>

@interface UIImage (Common)
#pragma mark 截图
- (UIImage *)capture:(UIView *)view;

+(CGSize)getImageSizeWithURL:(id)imageURL;
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request;
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request;
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request;
@end
