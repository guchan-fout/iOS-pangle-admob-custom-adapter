//
//  BUDAdmob_TemplateNativeFeedAd.m
//  AdmobAdapterDemo
//
//  Created by Chan Gu on 2020/09/01.
//  Copyright © 2020 GuChan. All rights reserved.
//

#import "BUDAdmob_TemplateNativeFeedAd.h"

@implementation BUDAdmob_TemplateNativeFeedAd

static NSString *const BUDNativeAdTranslateKey = @"bu_nativeAd";

- (instancetype)initWithBUNativeAd:(BUNativeExpressAdView *)expressAd {
    self = [super init];
    if (self) {
        self.expressAd = expressAd;
    }
    return self;
}

- (BOOL)hasVideoContent {
    return YES;
}

- (nullable UIView *)mediaView {

    return self.expressAd;
}

- (NSString *)headline {
    return nil;
}

- (NSString *)body {
    return nil;
}

- (NSString *)callToAction {
    return nil;
}

- (NSDecimalNumber *)starRating {
    return nil;
}

- (NSString *)advertiser {
    return nil;
}

- (GADNativeAdImage *)icon {
    return nil;
}

- (NSArray *)images {
    return nil;
}

- (NSDictionary *)extraAssets {
    return @{BUDNativeAdTranslateKey:self.expressAd};
}

- (NSString *)price {
    return nil;
}

- (NSString *)store {
    return nil;
}


@end
