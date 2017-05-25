//
//  QJNetworkingRequest.h
//  QJBaseProject
//
//  Created by willwei on 17/3/24.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJNetworkingRequest : NSObject

+ (void)openNSURLCache;

+ (void)GET:(NSString *)URLPath
 parameters:(id)parameters
  needCache:(BOOL)needCache
    success:(void (^)(id operation, id responseObject))success
    failure:(void (^)(id operation, NSError *error))failure;

+ (void)POST:(NSString *)URLPath
  parameters:(id)parameters
     success:(void (^)(id operation, id responseObject))success
     failure:(void (^)(id operation, NSError *error))failure;

+ (void)PUT:(NSString *)URLPath
 parameters:(id)parameters
    success:(void (^)(id operation, id responseObject))success
    failure:(void (^)(id operation, NSError *error))failure;

+ (void)DELETE:(NSString *)URLPath
    parameters:(id)parameters
       success:(void (^)(id operation, id responseObject))success
       failure:(void (^)(id operation, NSError *error))failure;

@end
