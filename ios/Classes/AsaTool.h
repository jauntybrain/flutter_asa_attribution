#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AsaTool : NSObject

+ (void)requestAttributionWithComplete:(void(^)(NSDictionary *data, NSError *error))complete;

@end

NS_ASSUME_NONNULL_END
