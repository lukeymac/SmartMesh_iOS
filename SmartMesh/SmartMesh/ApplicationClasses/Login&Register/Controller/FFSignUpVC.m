//
//  FFSignUpVC.m
//  SmartMesh
//
//  Created by Megan on 2017/10/12.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFSignUpVC.h"
#import "FFCreatSuccessVC.h"
#import "XMPPStream.h"
#import "LC_UIHud.h"
#import "FFTabBarController.h"
#import "FFAppDelegate.h"
#import "NATextField.h"
#import "NAPersonalDataBase.h"
#import "NAUserModel.h"

@interface FFSignUpVC ()<UITextFieldDelegate>
{
    UIView      * _contentView;

    NATextField * _username;
    NATextField * _setpwd;
    NATextField * _confirmpwd;
    NATextField * _prompt;

    UIButton    * _signBtn;
    UIButton    * _openPwd;
    UIView      * _line;
}

@end


@implementation FFSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (self.viewType == LoginType) {
        
        self.title = DDYLocalStr(@"LoginTitle");
    }
    else if (self.viewType == SignupType)
    {
        self.title = DDYLocalStr(@"SignupTitle");
    }
    else
    {
        self.title = DDYLocalStr(@"WalletCreateAccountTitle");
    }

    [self observeNotification:UIKeyboardWillShowNotification];
    [self observeNotification:UIKeyboardWillHideNotification];
    [self observeNotification:UITextFieldTextDidChangeNotification];
}

-(void)buildUI
{
    self.view.backgroundColor = LC_RGB(245, 245, 245);
    [self.view addTapTarget:self action:@selector(tapAction)];
    
    _contentView = [[UIView alloc] initWithFrame:LC_RECT(0, 64, DDYSCREENW, 150)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    _username = [[NATextField alloc] initWithFrame:CGRectMake(20, 0, DDYSCREENW - 56, 50)];
    _username.font = NA_FONT(15);
    _username.placeholder = DDYLocalStr(@"SignupUserName");
    _username.textColor = LC_RGB(42, 42, 42);
    _username.delegate = self;
    _username.keyboardType = UIKeyboardTypeDefault;
    [_username setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_contentView addSubview:_username];
    
    _setpwd = [[NATextField alloc] initWithFrame:CGRectMake(20, 50, DDYSCREENW - 56, 50)];
    _setpwd.font = NA_FONT(15);
    _setpwd.placeholder = DDYLocalStr(@"SignupPassword");
    _setpwd.textColor = LC_RGB(42, 42, 42);
    _setpwd.delegate = self;
    _setpwd.keyboardType = UIKeyboardTypeASCIICapable;
    _setpwd.secureTextEntry = YES;
    [_contentView addSubview:_setpwd];
    
    _openPwd = [[UIButton alloc] initWithFrame:CGRectMake(DDYSCREENW - 25.5 - 10, 0, 22, 16)];
    _openPwd.viewCenterY = _setpwd.viewCenterY;
    [_openPwd setBackgroundImage:[UIImage imageNamed:@"regs_close_password"] forState:UIControlStateNormal];
    [_openPwd setBackgroundImage:[UIImage imageNamed:@"regs_open_password"] forState:UIControlStateSelected];
    [_openPwd addTarget:self action:@selector(openPassword) forControlEvents:UIControlEventTouchUpInside];
    _openPwd.showsTouchWhenHighlighted = YES;
    _openPwd.hidden = YES;
    [_contentView addSubview:_openPwd];
    
    _confirmpwd = [[NATextField alloc] initWithFrame:CGRectMake(20, 100, DDYSCREENW - 56, 50)];
    _confirmpwd.font = NA_FONT(15);
    _confirmpwd.placeholder = DDYLocalStr(@"SignupConfirm");
    _confirmpwd.textColor = LC_RGB(42, 42, 42);
    _confirmpwd.delegate = self;
    _confirmpwd.keyboardType = UIKeyboardTypeASCIICapable;
    _confirmpwd.secureTextEntry = YES;
    [_contentView addSubview:_confirmpwd];
    
    _prompt = [[NATextField alloc] initWithFrame:CGRectMake(20, 150, DDYSCREENW - 56, 50)];
    _prompt.font = NA_FONT(15);
    _prompt.placeholder = DDYLocalStr(@"SignupPasswordHint");
    _prompt.textColor = LC_RGB(42, 42, 42);
    _prompt.delegate = self;
    [_contentView addSubview:_prompt];
    _prompt.hidden = YES;
    
    for (int i = 0; i < 4; i++)
    {
        _line = [[UIView alloc] initWithFrame:LC_RECT(10, 50 + i * 50, DDYSCREENW - 10, 1)];
        _line.backgroundColor = LC_RGB(235, 235, 235);
        _line.tag = i;
        [_contentView addSubview:_line];
    }
    
    _signBtn = [[UIButton alloc] initWithFrame:LC_RECT(37.5, _contentView.viewBottomY + 45, DDYSCREENW - 75, 50)];
    [_signBtn setTitle:DDYLocalStr(@"SignupSignup") forState:UIControlStateNormal];
    _signBtn.titleLabel.font = NA_FONT(18);
    [_signBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    [_signBtn setBackgroundColor:LC_RGB(230, 230, 230)];
    [_signBtn addTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signBtn];
    _signBtn.layer.cornerRadius = 25;
    _signBtn.layer.masksToBounds = YES;
    [_signBtn setUserInteractionEnabled:NO];
    
    if (self.viewType == walletType) {
         _prompt.hidden = NO;
        _contentView.viewFrameHeight = 200;
         _signBtn.viewFrameY = _contentView.viewBottomY + 45;
        [_signBtn setTitle:DDYLocalStr(@"WalletNewAccount") forState:UIControlStateNormal];
    }
    else if(self.viewType == LoginType){
        
        _username.placeholder = DDYLocalStr(@"SignupUserName");
        _contentView.viewFrameHeight = 100;
        _confirmpwd.hidden = YES;
        [_signBtn setTitle:DDYLocalStr(@"LoginLogin") forState:UIControlStateNormal];
        [_signBtn removeTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
        [_signBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        
        if (_line.tag == 3) {
            
            _line.hidden = YES;
        }
        
        _signBtn.viewFrameY = _contentView.viewBottomY + 45;
    }
}

-(void) handleNotification:(NSNotification *)notification
{
    if ([notification is:UIKeyboardWillShowNotification]) {
        
        [self keyboardWillShow:notification];
        
    }else if ([notification is:UIKeyboardWillHideNotification]){
        
        [self keyboardWillHide:notification];
    }
    else if ([notification is:UITextFieldTextDidChangeNotification]){
        
        [self textFieldChange];
        
    }
    
}


-(void) openPassword
{
    if (_openPwd.selected == NO) {
        
        _setpwd.secureTextEntry = NO;
        _openPwd.selected = YES;
    }
    else{
        
        _setpwd.secureTextEntry = YES;
        _openPwd.selected = NO;
    }
    
}

- (void)tapAction
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark Responding to keyboard events

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldChange
{
    BOOL isEnabled;
    
    _openPwd.hidden = _setpwd.text.length != 0 ? NO : YES;
    
    if (self.viewType == LoginType) {
        
        isEnabled = (_username.text.length != 0 && _setpwd.text.length != 0);
    }
    else
    {
        isEnabled = (_username.text.length != 0 && _setpwd.text.length != 0 && _confirmpwd.text.length != 0);
    }
    
    if (isEnabled)
    {
        [_signBtn setUserInteractionEnabled:YES];
        [_signBtn setBackgroundColor:LC_RGB(248, 220, 74)];
        [_signBtn setTitleColor:LC_RGB(51, 51, 51) forState:UIControlStateNormal];
    }
    else
    {
        [_signBtn setUserInteractionEnabled:NO];
        [_signBtn setBackgroundColor:LC_RGB(230, 230, 230)];
        [_signBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
        
    }
    
}

#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:65 withDuration:animationDuration + 0.5];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0 withDuration:animationDuration+0.2];
}

- (void) moveInputBarWithKeyboardHeight:(float)height withDuration:(NSTimeInterval)interval
{
    [UIView animateWithDuration:interval animations:^{
        
        //        [_contentScrollView setContentOffset:CGPointMake(0, height)];
    }];
}

- (void)signAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (self.viewType == walletType) {
        
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(creatNewAcount:) object:sender];
        [self performSelector:@selector(creatNewAcount:) withObject:sender afterDelay:0.5f];
        
    } else if (self.viewType == SignupType) {
        
        if ([[FFLoginDataBase sharedInstance] userExist:_username.text]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:DDYLocalStr(@"SignupAlertTip")
                                                                           message:DDYLocalStr(@"SignupAccountExist")
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:DDYLocalStr(@"SignupCancel")
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *action) { }];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:DDYLocalStr(@"SignupOK")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:cancelAction];
            [alert addAction:OKAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [self allResignFirstResponder];
            
            NSString *localID = [XMPPStream generateUUID];
            if ([[FFLoginDataBase sharedInstance] setLoginUser:localID active:YES password:_setpwd.text userName:_username.text]) {
                [self postNotification:FFLoginSuccessdNotification];
            }
            
            FFTabBarController *vc = [[FFTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
        }
    }
    else
    {
        
    }
    
}

- (void)creatNewAcount:(UIButton *)sender
{
    [self conditionExclusive:^(BOOL isFinish) {
        
        //NAAccountItem
        if (isFinish)
        {
            MBProgressHUD *hud0 =  [self showHudWithText:DDYLocalStr(@"SignupCreating")];

            
            [WALLET createAccount:_username.text password:_setpwd.text callback:^(NSString *json, Account *account) {
                
                if (![NSString ddy_blankString:_prompt.text]) {
                    [[NAPersonalDataBase sharedInstance] insertUserDataWithModel:[[NAUserModel alloc] initWithAddress:account.address.checksumAddress tip:_prompt.text] insertResult:^(BOOL result) { }];
                }
                WALLET.activeAccount = account.address;
                
                sender.enabled = YES;
                [hud0 hideAnimated:YES];
                FFCreatSuccessVC * controller = [[FFCreatSuccessVC alloc] init];
                controller.account = account;
                [self.navigationController pushViewController:controller animated:YES];

            }];
            
        }
    }];
}

- (void)conditionExclusive:(void(^)(BOOL isFinish))finished
{
    if ([NSString ddy_blankString:_username.text]) {
        [self showAlertViewWithTitle:DDYLocalStr(@"SignupAlertTip") message:DDYLocalStr(@"SignupAlertNotUserName") delegate:self isShowPwd:NO cancelButtonTitle:DDYLocalStr(@"SignupOK") otherButtonTitles:nil];
    } else if ([NSString ddy_blankString:_setpwd.text]) {
        [self showAlertViewWithTitle:DDYLocalStr(@"SignupAlertTip") message:DDYLocalStr(@"SignupAlertNotPassword") delegate:self isShowPwd:NO cancelButtonTitle:DDYLocalStr(@"SignupOK") otherButtonTitles:nil];
    } else if (_setpwd.text.length < 6 || _setpwd.text.length > 16) {
        [self showAlertViewWithTitle:DDYLocalStr(@"SignupAlertTip") message:DDYLocalStr(@"SignupPasswordLengthWarning") delegate:self isShowPwd:NO cancelButtonTitle:DDYLocalStr(@"SignupOK") otherButtonTitles:nil];
    } else if (![_setpwd.text isEqualToString:_confirmpwd.text]) {
        
        [self showAlertViewWithTitle:DDYLocalStr(@"SignupAlertTip") message:DDYLocalStr(@"SignupPasswordNotMatch") delegate:self isShowPwd:NO cancelButtonTitle:DDYLocalStr(@"SignupOK") otherButtonTitles:nil];
    } else {
        
        if (finished) {
            finished(YES);
        }
    }
    
}

-(void) loginAction
{
    [self allResignFirstResponder];
    
    if (_username.text.length < 1) {
        [self showHudWithText:DDYLocalStr(@"LoginPhoneBlankTip")];
        return;
    }
    if (_setpwd.text.length < 1) {
        [self showHudWithText:DDYLocalStr(@"LoginPasswordBlankTip")];
        return;
    }
    
    [self showText:DDYLocalStr(@"LoginValidating")];
    
    [FFLocalUserInfo LCInstance].isRSAKey = YES;
    NSDictionary * params = @{@"loginid": _username.text, @"password":_setpwd.text};
    __weak __typeof__(self) weakSelf = self;
    [NANetWorkRequest na_postDataWithService:@"user" action:@"login" parameters:params results:^(BOOL status, NSDictionary *result) {
        if (status) {
            
            NSDictionary * dict = [result objectForKey:@"data"];

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dict objectForKey:@"localid"] forKey:@"localid"];
            [defaults setObject:[dict objectForKey:@"uid"] forKey:@"uid"];
            [defaults setObject:[dict objectForKey:@"username"] forKey:@"uid"];
          
            [FFLocalUserInfo LCInstance].isRSAKey = NO;

            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[FFLoginDataBase sharedInstance] setLoginUser:dict[@"localid"] active:YES password:_setpwd.text userName:dict[@"username"]]) {
                    [[FFLoginDataBase sharedInstance] saveUID:dict[@"uid"]];
                    [[FFLoginDataBase sharedInstance] saveToken:dict[@"token"]];
                    
                    FFUser *myUser = [[FFUser alloc] init];
                    myUser.localid = dict[@"localid"];
                    myUser.nickName = dict[@"username"];
                    myUser.friend_log = @"-1";
                    [[FFUserDataBase sharedInstance] saveUser:myUser];
                    
                    [weakSelf postNotification:FFLoginSuccessdNotification];
                }
            });
            [self showImage:[UIImage imageNamed:@"icon_login_successful"] text:@"Login successful"];
            
        }
        else
        {
            [self showErrorText:DDYLocalStr(@"SingupWrongPassword")];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 测试 无网时候走
                if ([[FFLoginDataBase sharedInstance] userExist:_username.text]) {
                    if ([[FFLoginDataBase sharedInstance] loginWithUserName:_username.text password:_setpwd.text]) {
                        [self postNotification:FFLoginSuccessdNotification];
                    } else {
                        [self showHudWithText:DDYLocalStr(@"LoginPasswordError")];
                        
                    }
                } else {
                    
                }
            });
        }
    }];
}

-(void) allResignFirstResponder
{
    [_username resignFirstResponder];
    [_setpwd resignFirstResponder];
    [_confirmpwd resignFirstResponder];
}



@end
