//
//  BUDAdmob_NativeFeedAdModel.h
//  AdmobAdapterDemo
//
//  Created by Gu Chan on 2020/07/06.
//  Copyright © 2020 GuChan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <BUAdSDK/BUAdSDK.h>

@interface BUDAdmob_NativeFeedAdModel: NSObject <GADMediatedUnifiedNativeAd>

@property (nonatomic, strong) BUNativeAd *nativeAd;
@property (nonatomic, strong) BUNativeAdRelatedView *relatedView;

- (instancetype)initWithBUNativeAd:(BUNativeAd *)nativeAd;

@end
