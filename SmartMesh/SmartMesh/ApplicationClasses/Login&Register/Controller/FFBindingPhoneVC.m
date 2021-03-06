//
//  FFBindingPhoneVC.m
//  SmartMesh
//
//  Created by Megan on 2017/10/13.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFBindingPhoneVC.h"
#import "FFSignUpViewController.h"
#import "FFNewFriendsViewController.h"
#import "FFBindingEmailVC.h"
#import "FFSecurityDetailVC.h"

@interface FFBindingPhoneVC ()
{
    UIView      * _contentView;
    UIImageView * _phoneIcon;
    UILabel     * _tips;
    UIButton    * _button1;
    UIButton    * _button2;
}
@end

@implementation FFBindingPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Binding mobile phone";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)buildUI
{
    _contentView = [[UIView alloc] initWithFrame:LC_RECT(0, 64, DDYSCREENW, 230)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    _phoneIcon = [[UIImageView alloc] initWithFrame:LC_RECT(0, 40, 70, 93)];
    _phoneIcon.viewCenterX = DDYSCREENW * 0.5;
    [_contentView addSubview:_phoneIcon];
    
    _tips = [[UILabel alloc] initWithFrame:LC_RECT(10, _phoneIcon.viewBottomY + 35, DDYSCREENW - 20, 25)];
    _tips.text = @"Your mobile phone number:3719782169901";
    _tips.font = NA_FONT(16);
    _tips.textColor = LC_RGB(51,51 ,51);
    _tips.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_tips];
    
    _button1 = [[UIButton alloc] initWithFrame:LC_RECT(40, _contentView.viewBottomY + 40, DDYSCREENW - 80, 45)];
    [_button1 setTitle:@"Mobile address book" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _button1.titleLabel.font = NA_FONT(15);
    _button1.backgroundColor = LC_RGB(248, 220, 74);
    _button1.layer.cornerRadius = 45/2;
    _button1.layer.masksToBounds = YES;
    [_button1 addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_button1];
    
    _button2 = [[UIButton alloc] initWithFrame:LC_RECT(40, _button1.viewBottomY + 20, DDYSCREENW - 80, 45)];
    [_button2 setTitle:@"Replace a phone number" forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _button2.titleLabel.font = NA_FONT(15);
    _button2.backgroundColor = [UIColor whiteColor];
    _button2.layer.cornerRadius = 45/2;
    _button2.layer.masksToBounds = YES;
    _button2.layer.borderWidth = 1;
    _button2.layer.borderColor = [UIColor blackColor].CGColor;
    [_button2 addTarget:self action:@selector(button2Action) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_button2];
    
    if (self.status == 0) {
        _phoneIcon.image = [UIImage imageNamed:@"phone_banding_icon"];
        _phoneIcon.viewSize = LC_SIZE(70, 93);
        _tips.text = LC_NSSTRING_FORMAT(@"Your mobile phone number:%@",[FFLocalUserInfo LCInstance].phonenumber);
        _button1.hidden = NO;
        [_button2 setTitle:@"Replace a phone number" forState:UIControlStateNormal];
    }
    else
    {
        _phoneIcon.image = [UIImage imageNamed:@"email_banding_icon"];
        _phoneIcon.viewSize = LC_SIZE(120,90);
        _tips.text = LC_NSSTRING_FORMAT(@"Your email :%@",[FFLocalUserInfo LCInstance].emailnumber);
        _button1.hidden = YES;
        [_button2 setTitle:@"Replace the email" forState:UIControlStateNormal];
    }
    
}

-(void)backAction
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFSecurityDetailVC class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


- (void)button1Action
{
    if (self.status == 0) {
        FFNewFriendsViewController * controller = [[FFNewFriendsViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)button2Action
{
    if (self.status == 0) {
        
        FFSignUpViewController * controller = [[FFSignUpViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        FFBindingEmailVC * controller = [[FFBindingEmailVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
