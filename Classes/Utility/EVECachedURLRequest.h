//
//  EVECachedURLRequest.h
//  EVEOnlineAPI
//
//  Created by Artem Shimanski on 8/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EVECachedURLRequestErrorDomain @"EVECachedURLRequestErrorDomain"

typedef enum {
	EVERequestCacheStyleShort,
	EVERequestCacheStyleModifiedShort,
	EVERequestCacheStyleLong
} EVERequestCacheStyle;


@interface EVECachedURLRequest : NSObject

@property (assign, nonatomic, readonly, getter = isCashed) BOOL cached;
@property (strong, nonatomic) NSDate* cacheDate;
@property (strong, nonatomic) NSDate* cacheExpireDate;
@property (strong, nonatomic) NSURL* url;

+ (void) setOfflineMode:(BOOL) offlineMode;
+ (BOOL) isOfflineMode;

- (id) initWithURL: (NSURL*) url cachePolicy:(NSURLRequestCachePolicy) cachePolicy error:(NSError **)errorPtr progressHandler:(void(^)(CGFloat progress, BOOL* stop)) progressHandler;
- (id) initWithURL: (NSURL*) url bodyData:(NSData*) bodyData contentType:(NSString*) contentType cachePolicy:(NSURLRequestCachePolicy) cachePolicy error:(NSError **)errorPtr progressHandler:(void(^)(CGFloat progress, BOOL* stop)) progressHandler;
- (id) initWithRequest:(NSURLRequest*) request error:(NSError **)errorPtr progressHandler:(void(^)(CGFloat progress, BOOL* stop)) progressHandler;

- (NSError*) parseData: (NSData*) data;

@end
