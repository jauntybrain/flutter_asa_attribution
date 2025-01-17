#import "AsaTool.h"

// Conditionally import AdServices using weak linking.
#ifdef __has_include
  #if __has_include(<AdServices/AdServices.h>)
    #define HAS_ADSERVICES 1
    #import <AdServices/AdServices.h>
  #else
    #define HAS_ADSERVICES 0
  #endif
#else
  #define HAS_ADSERVICES 0
#endif

@implementation AsaTool

+ (NSString * _Nullable)attributionToken {
#if HAS_ADSERVICES
    if (@available(iOS 14.3, *)) {
        NSError *error;
        // Request the attribution token using the AdServices API.
        NSString *token = [AAAttribution attributionTokenWithError:&error];
        if (error) {
            NSLog(@"[FlutterAsaAttribution]: Failed to retrieve attribution token: %@", error.localizedDescription);
        }
        return token;
    } else {
        NSLog(@"[FlutterAsaAttribution]: Only support iOS 14.3 and later");
        return nil;
    }
#else
    NSLog(@"[FlutterAsaAttribution]: AdServices framework not available");
    return nil;
#endif
}

+ (void)requestAttributionWithComplete:(void(^)(NSDictionary * _Nullable data, NSError * _Nullable error))complete {
#if HAS_ADSERVICES
    if (@available(iOS 14.3, *)) {
        NSError *error;
        NSString *token = [self attributionToken];
        if (token.length > 0) {
            [self requestAttributionWithToken:token complete:complete];
        } else {
            if (complete) {
                complete(nil, error ?: [NSError errorWithDomain:@"app"
                                                             code:-1
                                                         userInfo:@{NSLocalizedDescriptionKey: @"Failed to retrieve attribution token"}]);
            }
        }
    } else {
        if (complete) {
            complete(nil, [NSError errorWithDomain:@"app"
                                                code:-1
                                            userInfo:@{NSLocalizedDescriptionKey: @"ATTracking Not Allowed"}]);
        }
    }
#else
    if (complete) {
        complete(nil, [NSError errorWithDomain:@"app"
                                            code:-1
                                        userInfo:@{NSLocalizedDescriptionKey: @"AdServices framework not available"}]);
    }
#endif
}

+ (void)requestAttributionWithToken:(NSString *)token complete:(void(^)(NSDictionary * _Nullable data, NSError * _Nullable error))complete {
    NSString *urlString = @"https://api-adservices.apple.com/api/v1/";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    [request addValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [token dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData * _Nullable data,
                                                                                         NSURLResponse * _Nullable response,
                                                                                         NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) complete(nil, error);
            });
            return;
        }

        NSError *jsonError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(result ?: @{}, jsonError);
            }
        });
    }];

    [dataTask resume];
}

@end
