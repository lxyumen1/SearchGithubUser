//
//  UserCell.h
//  SearchGitHubUser
//
//  Created by 李翔 on 2017/5/2.
//  Copyright © 2017年 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserCell : UITableViewCell
-(void)setModel:(UserModel*)model language:(NSString*)language;
@end
