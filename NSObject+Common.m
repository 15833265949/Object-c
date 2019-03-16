

#import "NSObject+Common.h"
#import "MBProgressHUD+Add.h"
@implementation NSObject (Common)

+(NSString *)tipFromError:(NSError *)error
{
    if (error && error.userInfo) {
        NSMutableString * tipStr = [[NSMutableString alloc] init];
        NSString * errorTip = error.userInfo[@"NSLocalizedDescription"];
        if (errorTip.length != 0){
            tipStr = [NSMutableString stringWithString:errorTip];
        }
        else{
            NSDictionary* userDict = error.userInfo;
            NSString* returnMessage = userDict[@"message"];
            returnMessage = returnMessage.length == 0 ? userDict[@"returnmessae"] : returnMessage;
            [tipStr appendFormat:@"%@", returnMessage];
        }
        return tipStr;
    }
    else{
        return @"";
    }
}

+(BOOL)showError:(NSError *)error
{
   
    NSString * tipStr = [self tipFromError:error];
    [self showHudTipStr:tipStr];
    return YES;
}

+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =tipStr;
        hud.labelFont = [UIFont boldSystemFontOfSize:15.0];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];

    }
}







@end
