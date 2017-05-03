//
//  NetAPIClicnet.m
//  GongFu
//
//  Created by 李翔 on 2017/2/27.
//  Copyright © 2017年 nimble. All rights reserved.
//

#import "NetAPIClicnet.h"
#import "MBProgressHUD+MJ.h"
#import "ApiList.h"
#import "UIViewController+KSNoNetController.h"
#define DEF_ALERTMESSAGE @"加载中···"

@implementation NetAPIClicnet
+ (NetAPIClicnet *)sharedJsonClient {
    static NetAPIClicnet *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetAPIClicnet alloc] initWithBaseURL:[NSURL URLWithString:DEF_NETPATH_BASEURL]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    //    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/html", @"text/javascript", @"text/json", nil];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    self.securityPolicy.allowInvalidCertificates = NO;
    self.requestSerializer.timeoutInterval = 40;
    
    return self;
}

/**
 *  判断网络状态
 *
 *  @return 返回状态 YES 为有网 NO 为没有网
 */
- (BOOL)checkNetState
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus > 0;
}

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
                       andBlock:(void (^)(id data, NSError *error))block{
    
    //    NSLog(@"%@",params);
    NSLog(@"%@",params);
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //是否需要loading加载框
    if(isLoading)
        [MBProgressHUD showMessage:DEF_ALERTMESSAGE toView:[[UIApplication sharedApplication].delegate window]];
    
    [target hiddenNonetWork];
    //发起请求
    switch (NetworkMethod) {
        case Get:{
            
            [self GET:aPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSLog(@"\n===========responseObject===========\n aPath = %@:\n responseObject = %@ \n", aPath, responseObject);
                  
                  [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                  block(responseObject, nil);
                  
                  
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                  NSLog(@"\n===========error===========\n aPath = %@:\n error = %@ \n", aPath, error);
                  
                  [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                  block(nil, error);
              }];
            break;
        }
        case Post:{
            [self POST:aPath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"\n===========responseObject===========\n aPath = %@:\n responseObject = %@ \n", aPath, responseObject);
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                block(responseObject, nil);
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"\n===========error===========\n aPath = %@:\n error = %@ \n", aPath, error);
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                block(nil, error);
            }];
            
            break;
        }
    }
}

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
                       andBlock:(void (^)(id data, NSError *error))block{
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:aPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath_] name:name fileName:fileName mimeType:@"application/octet-stream" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        NSLog(@"请求成功：%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSLog(@"请求失败：%@",error);
    }];
}

/**
 *  AFN3.0 下载
 */
- (void)requestDownLoadWithFilePath:(NSString *)filePath
{
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.确定请求的URL地址
    NSURL *url = [NSURL URLWithString:filePath];
    
    //3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //打印下下载进度
        NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载地址
        NSLog(@"默认下载地址:%@",targetPath);
        
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        return [NSURL URLWithString:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载完成调用的方法
        NSLog(@"下载完成：");
        NSLog(@"%@--%@",response,filePath);
    }];
    
    //开始启动任务
    [task resume];
}

@end
