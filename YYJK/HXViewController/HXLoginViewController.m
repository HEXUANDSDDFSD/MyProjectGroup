//
//  HXLoginViewController.m
//  tysx
//
//  Created by zwc on 14-4-2.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXLoginViewController.h"
#import "UIView+CornerRadius.h"
#import "OSSMemberCache.h"
#import "LoginCtr.h"
#import "TYSXBindAPNTokenCtr.h"

@interface HXLoginViewController ()<UITextFieldDelegate>

@end

@implementation HXLoginViewController {
    //UITextField *safeCode;
    UITextField *userName;
    UITextField *password;
    UIButton *remember;
    UIImageView *logoImageView;
    UIView *containerView;
    LoginCtr *loginCtr;
    BOOL keyboardIsShow;
}

- (id)init {
    if (self = [super init]) {
        loginCtr = [[LoginCtr alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)noti {
    if (!keyboardIsShow) {
        [UIView animateWithDuration:0.2 animations:^{
            containerView.frame = CGRectMake(containerView.frame.origin.x, 20, containerView.bounds.size.width, containerView.bounds.size.height);
        }];
    }
    keyboardIsShow = YES;
}

- (void)keyboardWillHide:(NSNotification *)noti {
    if (keyboardIsShow) {
        [UIView animateWithDuration:0.2 animations:^{
            containerView.frame = CGRectMake(containerView.frame.origin.x, 154, containerView.bounds.size.width, containerView.bounds.size.height);
        }];
    }
    keyboardIsShow = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self loginAction];
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    //self.view.backgroundColor = [UIColor whiteColor];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
//    imageView.image = [UIImage imageNamed:@"Icon-72.png"];
//    imageView.backgroundColor = [UIColor whiteColor];
//    imageView.center = self.view.center;
//    imageView.layer.cornerRadius = 35;
//    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    imageView.layer.borderWidth = 2;
//    imageView.layer.masksToBounds = YES;
//    [self.view addSubview:imageView];
//    return;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat containerWidth = 760;
    containerView = [[UIView alloc] initWithFrame:CGRectMake((kScreenHeight - containerWidth) / 2, 154, 760, 381)];
    
    NSMutableArray *layouts = [NSMutableArray array];
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg.jpg"]];
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bgView];
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectZero];
    middleView.translatesAutoresizingMaskIntoConstraints = NO;
    middleView.backgroundColor = [UIColor colorWithHexString:@"#111C46"];
    middleView.alpha = 0.2;
    [containerView addSubview:middleView];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    logoView.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:logoView];
    
//    UIView *safeCodeBgView = [self textFieldBgView];
//    safeCodeBgView.hidden = YES;
//    [containerView addSubview:safeCodeBgView];
//    UILabel *safeTitle = [self textFieldTitleLabel:@"安全代码："];
//    [containerView addSubview:safeTitle];
//    safeCode = [self textField];
//    safeCode.text = USER_DFT.safeCode;
//    [safeCodeBgView addSubview:safeCode];
//    safeCode.secureTextEntry = YES;
//    [safeCode locationAtSuperView:safeCodeBgView edgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    
    remember = [self buttonWith:@"保存账号" normalImage:nil hightedImage:nil action:nil];
    remember.titleLabel.font = [UIFont systemFontOfSize:15];
    remember.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -8);
    [remember setImage:[UIImage imageNamed:@"unremember.png"] forState:UIControlStateNormal];
    [remember setImage:[UIImage imageNamed:@"remember.png"] forState:UIControlStateSelected];
    remember.selected = USER_DFT.isRememberUserName;
    [remember addTarget:self action:@selector(rememberAction:) forControlEvents:UIControlEventTouchDown];
    [containerView addSubview:remember];
    
    UIView *accountBgView = [self textFieldBgView];
    [containerView addSubview:accountBgView];
    userName = [self textField];
    
    if (USER_DFT.isRememberUserName) {
        userName.text = USER_DFT.userName;
    }
    
    [accountBgView addSubview:userName];
    [userName locationAtSuperView:accountBgView edgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    UILabel *accountTitle = [self textFieldTitleLabel:@"账号："];
    [containerView addSubview:accountTitle];
    
    UIView *pwdBgView = [self textFieldBgView];
    [containerView addSubview:pwdBgView];
    password = [self textField];
    password.secureTextEntry = YES;
    [pwdBgView addSubview:password];
    [password locationAtSuperView:pwdBgView edgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    UILabel *pwdTitle = [self textFieldTitleLabel:@"密码："];
    [containerView addSubview:pwdTitle];
    
    UIButton *loginBtn = [self buttonWith:@"登   录"
                              normalImage:@"orange.png"
                             hightedImage:@"orange_d.png"
                                   action:@selector(loginAction)];
    [containerView addSubview:loginBtn];
    
//    UIButton *guestBtn = [self buttonWith:@"游客访问"
//                              normalImage:@"orange.png"
//                             hightedImage:@"orange_d.png"
//                                   action:@selector(guestLookAction)];
//    [containerView addSubview:guestBtn];
    
    
    UIButton *resetBtn = [self buttonWith:@"重   置"
                              normalImage:@"gray.png"
                             hightedImage:@"gray_d.png"
                                   action:@selector(resetAction)];
    [containerView addSubview:resetBtn];
    
    [self.view addSubview:containerView];
    
    [middleView locationAtSuperView:containerView edgeInsets:UIEdgeInsetsZero];
    
    [layouts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[logoView(==200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logoView)]];
    [layouts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-27-[logoView(==53)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logoView)]];
    [layouts addObject:[logoView layoutConstraintCenterXInView:containerView]];
    
    [layouts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[logoView]-50-[accountBgView(==50)]-20-[pwdBgView(==50)]" options:NSLayoutFormatAlignAllCenterX metrics:0 views:NSDictionaryOfVariableBindings(logoView, accountBgView, pwdBgView)]];
//    [layouts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[safeTitle(==100)]-3-[safeCodeBgView(==424)]" options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(safeCodeBgView, safeTitle)]];
//    [layouts addObject:[accountBgView layoutConstraintEqualWidthOfView:safeCodeBgView constant:0]];
//    
//    [layouts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[accountTitle(==100)]-3-[accountBgView(==424)]" options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(accountBgView, accountTitle)]];
    
    [layouts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[accountTitle(==90)]-3-[accountBgView(==424)]-6-[remember(==89)]" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(accountBgView, accountTitle, remember)]];
    [layouts addObject:[pwdBgView layoutConstraintEqualWidthOfView:accountBgView constant:0]];
    [layouts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pwdTitle(==90)]-3-[pwdBgView]" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(pwdBgView, pwdTitle)]];
    
    
    [layouts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pwdBgView]-25-[loginBtn(==50)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(pwdBgView, loginBtn)]];
    [layouts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-198-[loginBtn(==100)]-100-[resetBtn(==loginBtn)]" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:0 views:NSDictionaryOfVariableBindings(loginBtn, resetBtn)]];
    
    [containerView addConstraints:layouts];
    
    [bgView locationAtSuperView:self.view edgeInsets:UIEdgeInsetsZero];
    
    //virtual data need
//    if (kNeedVirtualData) {
//        UIButton *tysxBtn = [self buttonWith:@"天翼视讯"
//                                 normalImage:@"orange.png"
//                                hightedImage:@"orange_d.png"
//                                      action:@selector(tysxAction)];
//        [self.view addSubview:tysxBtn];
//        tysxBtn.translatesAutoresizingMaskIntoConstraints = YES;
//        tysxBtn.frame = CGRectMake(150, 680, 100, 50);
//        
//        UIButton *iptvBtn = [self buttonWith:@"IPTV"
//                                 normalImage:@"orange.png"
//                                hightedImage:@"orange_d.png"
//                                      action:@selector(iptvAction)];
//        iptvBtn.translatesAutoresizingMaskIntoConstraints = YES;
//        [self.view addSubview:iptvBtn];
//        iptvBtn.frame = CGRectMake(350, 680, 100, 50);
//    }
}

- (UIView *)textFieldBgView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#635966"];
    bgView.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    bgView.layer.borderWidth = 1;
    bgView.layer.cornerRadius = 3;
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    return bgView;
}

- (UIButton *)buttonWith:(NSString *)title
             normalImage:(NSString *)normalImage
            hightedImage:(NSString *)hightedImage
                  action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitleColor:kDefaultTextColor forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:normalImage] stretchableInCenter] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:hightedImage] stretchableInCenter] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)textFieldTitleLabel:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.font = [UIFont systemFontOfSize:20];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = kDefaultTextColor;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

- (UITextField *)textField {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.tintColor = kDefaultTextColor;
    textField.returnKeyType = UIReturnKeyJoin;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:20];
    textField.textColor = kDefaultTextColor;
    return textField;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)rememberAction:(UIButton *)button {
    button.selected = !button.selected;
    USER_DFT.isRememberUserName = button.selected;
    if (!USER_DFT.isRememberUserName) {
        USER_DFT.userName = nil;
    }
}

- (void)loginAction {
//    if (safeCode.text.length == 0) {
//        showPrompt(@"请输入安全代码！", 1, YES);
//        return;
//    }
//    else if ([OSSMemberCache typeWithSafeCode:safeCode.text] == OrganizationType_None) {
//        showPrompt(@"安全代码码无效！", 1, YES);
//        return;
//    }
//    else {
//        [OSSMemberCache shareCache].organizationType = [OSSMemberCache typeWithSafeCode:safeCode.text];
//    }
    
    loginCtr.userName = [userName text];
    loginCtr.password = [password text];
    
//#if !has_netowrk
//    NetworkBaseParamError paramErro = [loginCtr checkParams];
//    if (paramErro != kNetworkBaseParamError_NoError) {
//        NSString *errInfo = [LoginCtr friendShowStrWithParamError:paramErro];
//        showPrompt(errInfo, 1, YES);
//        return;
//    }
//    showStatusView(YES);
//    [self performSelector:@selector(loginResult) withObject:nil afterDelay:1];
//    return;
//#endif
    NetworkBaseParamError *paramError = [loginCtr sendRequestWith:^{
        run_async_main(^{
            dismissStatusView();
            showPrompt(loginCtr.resultInfo, 1, YES);
            if (loginCtr.result == NetworkBaseResult_Success) {
                if (USER_DFT.isRememberUserName) {
                    USER_DFT.userName = loginCtr.userName;
                }
                OSSMemberCache *memCache = [OSSMemberCache shareCache];
                memCache.userName = loginCtr.userName;
                memCache.chartAuthList = loginCtr.chartAuthList;
                [memCache saveMember];
                //USER_DFT.safeCode = safeCode.text;
                [self dismissViewControllerAnimated:YES completion:NULL];
                
                TYSXBindAPNTokenCtr *bindAPNTokenCtr = [[TYSXBindAPNTokenCtr alloc] init];
                bindAPNTokenCtr.userName = loginCtr.userName;
                bindAPNTokenCtr.token = USER_DFT.deviceToken;
                [bindAPNTokenCtr sendRequestWith:NULL];
            }
        });
    }];
    if (paramError != kNetworkBaseParamError_NoError) {
        //NSString *errInfo = [LoginCtr friendShowStrWithParamError:paramError];
        showPrompt(loginCtr.resultInfo, 1, YES);
    }
    else {
        showStatusView(YES);
    }
}

- (void)resetAction {
    userName.text = nil;
    password.text = nil;
    //safeCode.text = nil;
    USER_DFT.isRememberUserName = NO;
    USER_DFT.userName = nil;
    USER_DFT.safeCode = nil;
    remember.selected = NO;
}

- (void)guestLookAction {
    OSSMemberCache *memCache = [OSSMemberCache shareCache];
    memCache.userName = @"游客";
    memCache.organizationType = OrganizationType_Guest;
    [memCache saveMember];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)loginResult {
    dismissStatusView();
    if (![loginCtr.userName isEqualToString:@"root"] ||
        ![loginCtr.password isEqualToString:@"123456"]) {
        showPrompt(@"用户名或密码错误", 1, YES);
    }
    else {
       // USER_DFT.isLogin = YES;
        showPrompt(@"登录成功", 1, YES);
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持的屏幕方向，此处可直接返回 UIInterfaceOrientationMask 类型
// 也可以返回多个 UIInterfaceOrientationMask 取或运算后的值
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
}

#pragma virtual process

- (void)tysxAction {
    [OSSMemberCache shareCache].organizationType = OrganizationType_TYSX;
    [OSSMemberCache shareCache].userName = @"root";
    [[OSSMemberCache shareCache] saveMember];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)iptvAction {
    [OSSMemberCache shareCache].organizationType = OrganizationType_IPTV;
    [OSSMemberCache shareCache].userName = @"root";
    [[OSSMemberCache shareCache] saveMember];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
