//
//  BUDAdmob_TemplateNativeFeedAd.h
//  AdmobAdapterDemo
//
//  Created by Chan Gu on 2020/09/01.
//  Copyright © 2020 GuChan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <BUAdSDK/BUAdSDK.h>

@interface BUDAdmob_TemplateNativeFeedAd : NSObject <GADMediatedUnifiedNativeAd>

@property (nonatomic, strong) BUNativeExpressAdView *expressAd;

- (instancetype)initWithBUNativeAd:(BUNativeExpressAdView *)expressAd;


@end

