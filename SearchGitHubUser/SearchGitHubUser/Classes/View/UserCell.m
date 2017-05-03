//
//  UserCell.m
//  SearchGitHubUser
//
//  Created by 李翔 on 2017/5/2.
//  Copyright © 2017年 lx. All rights reserved.
//

#import "UserCell.h"

@interface UserCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;

@end

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(UserModel*)model language:(NSString*)language{
    self.avatarImage.layer.cornerRadius =  25;
    self.avatarImage.layer.masksToBounds = YES;
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url ]];
    self.userNameLabel.text = model.login;
    self.languageLabel.text = language == nil ?  @"暂无" : language;
}
@end
