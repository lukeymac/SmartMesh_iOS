//
//  FFApplyFriendVC.m
//  SmartMesh
//
//  Created by Megan on 2017/12/15.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFApplyFriendVC.h"

@interface FFApplyFriendVC ()<UITextFieldDelegate>
{
    UILabel     * _tips;
    UITextField * _application;
    UILabel     * _tips1;
    UITextField * _addnotes;
}

@property(nonatomic,strong)FFUser * user;

@end

@implementation FFApplyFriendVC

-(instancetype)initWithUser:(FFUser *)user
{
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"Friends validation";
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"  style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    [self observeNotification:UIKeyboardWillShowNotification];
    [self observeNotification:UIKeyboardWillHideNotification];
    [self observeNotification:UITextFieldTextDidChangeNotification];
}

-(void)buildUI
{
    [self.view addTapTarget:self action:@selector(tapAction)];
    
    _tips = [[UILabel alloc] initWithFrame:LC_RECT(10, 64, DDYSCREENW - 30,40)];
    _tips.text = @"You need to send varification application ,please each other through";
    _tips.textColor = LC_RGB(133, 133, 133);
    _tips.font = NA_FONT(14);
    _tips.numberOfLines = 2;
    [self.view addSubview:_tips];
    
    _application = [[UITextField alloc] initWithFrame:CGRectMake(10, _tips.viewBottomY + 10, DDYSCREENW - 20, 90)];
    _application.font = NA_FONT(17);
    _application.backgroundColor = LC_RGB(230, 230, 230);
    _application.placeholder = @"varification application";
    _application.textColor = LC_RGB(142, 142, 142);
    _application.delegate = self;
    _application.keyboardType = UIKeyboardTypeDefault;
    _application.layer.cornerRadius = 5;
    _application.layer.masksToBounds = YES;
    [self.view addSubview:_application];
    
    _tips1 = [[UILabel alloc] initWithFrame:LC_RECT(10, _application.viewBottomY + 15, DDYSCREENW - 30,40)];
    _tips1.text = @"Add notes";
    _tips1.textColor = LC_RGB(133, 133, 133);
    _tips1.font = NA_FONT(14);
    [self.view addSubview:_tips1];
    
    _addnotes = [[UITextField alloc] initWithFrame:CGRectMake(10, _tips1.viewBottomY + 10, DDYSCREENW - 20, 40)];
    _addnotes.backgroundColor = LC_RGB(230, 230, 230);
    _addnotes.font = NA_FONT(17);
    _addnotes.placeholder = @"Add notes";
    _addnotes.textColor = LC_RGB(142, 142, 142);
    _addnotes.delegate = self;
    _addnotes.keyboardType = UIKeyboardTypeDefault;
    _addnotes.layer.cornerRadius = 5;
    _addnotes.layer.masksToBounds = YES;
    [self.view addSubview:_addnotes];
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

-(void)sendAction
{
    [_application resignFirstResponder];
    [_addnotes resignFirstResponder];
    
    NSDictionary * params = @{@"flocalid": self.user.localid,
                              @"content": _application.text,
                              @"note" : _addnotes.text
                              };
    [self showLoading];
    [NANetWorkRequest na_postDataWithService:@"friend" action:@"add_friend" parameters:params results:^(BOOL status, NSDictionary *result) {
        
        if (status) {
            
            NSLog(@"===添加成功==");
            [self showSuccessText:@"添加成功!"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"==网络异常===");
            [self showErrorText:[result objectForKey:@"msg"]];
        }
        
    }];
    
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
    if (_application.text.length != 0)
    {
    
    }
    else
    {
       
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


@end
