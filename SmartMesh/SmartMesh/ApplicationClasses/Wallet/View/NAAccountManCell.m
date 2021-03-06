//
//  NAAccountCell.m
//  SmartMesh
//
//  Created by Rain on 17/9/11.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.

#import "NAAccountManCell.h"
#import "AvatarImg.h"

@interface NAAccountManCell ()

@property (nonatomic, strong) UIImageView   *avatarView;
@property (nonatomic, strong) UILabel       *nameLbl;
@property (nonatomic, strong) UILabel       *pwdLbl;
@property (nonatomic, strong) UIImageView   *arrowView;

@end


@implementation NAAccountManCell

 
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 5;
    frame.size.height -= 5;
    
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI
{
    _avatarView = [[UIImageView alloc] init];
    _avatarView.image = [UIImage imageNamed:@"defaul_head_icon"];
    
    _nameLbl = [[UILabel alloc] init];
    _nameLbl.font = NA_FONT(16);
    _nameLbl.textColor = [UIColor blackColor];
    
    _pwdLbl = [[UILabel alloc] init];
    _pwdLbl.font = NA_FONT(15);
    _pwdLbl.textColor = rgba(151,151,151,1);
    _pwdLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    [self addSubview:_avatarView];
    [self addSubview:_nameLbl];
    [self addSubview:_pwdLbl];
    
    [self layoutContentSubViews];
}

- (void)loadTmpData
{
    _nameLbl.text = @"werjlwjfk";
    _pwdLbl.text = @"0x23435e3485023849383432";
    
}

- (void)setAddress:(Address *)address {
    
    _address = address;

    _address.nickName = [WALLET nicknameForAccount:address];
    _nameLbl.text = _address.nickName;
    _pwdLbl.text  = address.checksumAddress;
    
    _avatarView.image = [AvatarImg avatarImgFromAddress:address];
}

- (void)layoutContentSubViews
{
    _avatarView.frame = CGRectMake(20, 15, 45, 45);
    
    _nameLbl.frame = CGRectMake(_avatarView.ddy_right + 10, _avatarView.ddy_y, ScreenWidth, 22.5);
    
    _pwdLbl.frame = CGRectMake(_nameLbl.ddy_x, _avatarView.ddy_bottom - 20, ScreenWidth - _nameLbl.ddy_x - 30, 20);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
