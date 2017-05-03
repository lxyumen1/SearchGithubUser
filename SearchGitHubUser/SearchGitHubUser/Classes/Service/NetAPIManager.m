//
//  NetAPIManager.m
//  Copyright © 2016年 nimble. All rights reserved.
//

#import "NetAPIManager.h"
#import "NetAPIClicnet.h"
#import "ApiList.h"
@implementation NetAPIManager

+ (instancetype)sharedManager {
    static NetAPIManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}


/**
 查询用户
 */
-(void)request_queryUserWithTarget:(UIViewController*)target userName:(NSString*)userName  andBlock:(void (^)(id responseData, NSError *error))block{

    [[NetAPIClicnet sharedJsonClient]requestJsonDataWithPath:api_query_user(userName) withParams:nil withTarget:target withMethodType:Get withLoading:NO andBlock:^(id data, NSError *error) {
        if(data){
            block(data,nil);
        }else
        {
            block(nil,error);
        }
    }];
}

/**
 查询用户repos
 */
-(void)request_queryUserReposWithTarget:(UIViewController*)target userName:(NSString*)userName  andBlock:(void (^)(id responseData, NSError *error))block{
    [[NetAPIClicnet sharedJsonClient]requestJsonDataWithPath:api_query_user_repos(userName) withParams:nil withTarget:target withMethodType:Get withLoading:NO andBlock:^(id data, NSError *error) {
        if(data){
            block(data,nil);
        }else
        {
            block(nil,error);
        }
    }];
}
@end
