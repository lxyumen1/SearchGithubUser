//
//  NetAPIClicnet.h
//  GongFu
//
//  Created by 李翔 on 2017/2/27.
//  Copyright © 2017年 nimble. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;

@interface NetAPIClicnet : AFHTTPSessionManager
+ (NetAPIClicnet *)sharedJsonClient;

/**
 *  NetWorking
 *
 *  @param aPath         接口路径
 *  @param params        接口所需要的参数
 *  @param NetworkMethod 请求类型
 *  @param isLoading     是否需要loading框
 *  @param block         返回数据和错误信息
 */
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                     withTarget:(UIViewController*)target
                 withMethodType:(int)NetworkMethod
                    withLoading:(BOOL)isLoading
                       andBlock:(void (^)(id data, NSError *error))block;

/**
 *  AFMultipartFormData 方式上传图片
 *
 *  @param aPath        接口路径
 *  @param params       接口所需要的参数
 *  @param name         图片名称不带后缀
 *  @param fileName     图片名称带后缀
 *  @param filePath_    图片物理路径
 *  @param NetworkMetho 请求类型
 *  @param block        返回数据或者错误信息
 */
-(void)requestImageDataWithPath:(NSString *)aPath withParams:(NSDictionary*)params WithName:(NSString *)name fileName:(NSString *)fileName filePath:(NSString *)filePath_ withMethodType:(int)NetworkMetho
                       andBlock:(void (^)(id data, NSError *error))block;
@end
