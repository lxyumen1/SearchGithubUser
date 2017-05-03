
//  NetAPIManager.h
//  Copyright © 2016年 nimble. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetAPIManager : NSObject
+ (instancetype)sharedManager;

/**
 查询用户
 */
-(void)request_queryUserWithTarget:(UIViewController*)target userName:(NSString*)userName  andBlock:(void (^)(id responseData, NSError *error))block;

/**
 查询用户repos
 */
-(void)request_queryUserReposWithTarget:(UIViewController*)target userName:(NSString*)userName  andBlock:(void (^)(id responseData, NSError *error))block;
@end
