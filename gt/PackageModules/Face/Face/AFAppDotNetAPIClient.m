// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFAppDotNetAPIClient.h"

@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
		_sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //返回数据格式
          _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        //请求数据格式
//        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //设置请求头Content-Type/
        
//        [_sharedClient.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"]; 
        //请求超时时间
        _sharedClient.requestSerializer.timeoutInterval = 10;
//        _sharedClient.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;

        //请求头转码格式
       _sharedClient.requestSerializer.stringEncoding = NSUTF8StringEncoding;
//        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        policy.validatesDomainName = YES;
//        _sharedClient.securityPolicy = policy;
//        _sharedClient.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
    _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml",@"multipart/form-data",@"text/plain", nil];
    });
	
    return _sharedClient;
}

@end







