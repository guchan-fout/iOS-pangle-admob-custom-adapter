//
//  BUDAdmob_BannerCustomEventAdapter.m
//  AdmobAdapterDemo
//
//  Created by Chan Gu on 2020/09/04.
//  Copyright © 2020 GuChan. All rights reserved.
//

#import "BUDAdmob_BannerCustomEventAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import <BUAdSDK/BUNativeExpressBannerView.h>
#import <GoogleMobileAds/GADCustomEventBanner.h>
#import "BUDAdmob_PangleTool.h"

@interface BUDAdmob_BannerCustomEventAdapter ()<GADCustomEventBanner, BUNativeExpressBannerViewDelegate>

@property (strong, nonatomic) BUNativeExpressBannerView *nativeExpressBannerView;

@end

@implementation BUDAdmob_BannerCustomEventAdapter

@synthesize delegate;

NSString *const TEMPLATE_BANNER_PANGLE_PLACEMENT_ID = @"placementID";

- (void)requestBannerAd:(GADAdSize)adSize parameter:(nullable NSString *)serverParameter label:(nullable NSString *)serverLabel request:(nonnull GADCustomEventRequest *)request {
    
    NSString *placementID = [self processParams:serverParameter];
    if (placementID != nil){
        /// tag
        [BUDAdmob_PangleTool setPangleExtData];
        
        [self getTemplateBannerAd:placementID adSize:adSize];
    } else {
        NSLog(@"no pangle placement ID for requesting.");
    }
}


- (void)getTemplateBannerAd:(NSString *)placementID adSize:(GADAdSize)adSize {
    NSLog(@"placementID=%@",placementID);
    NSLog(@"request ad size width = %f",adSize.size.width);
    NSLog(@"request ad size height = %f",adSize.size.height);
    
    self.nativeExpressBannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:placementID rootViewController:self.delegate.viewControllerForPresentingModalView adSize:CGSizeMake(adSize.size.width, adSize.size.height)];
    
    self.nativeExpressBannerView.frame = CGRectMake(0, 0, adSize.size.width, adSize.size.height);
    self.nativeExpressBannerView.delegate = self;
    [self.nativeExpressBannerView loadAdData];
}

#pragma mark BUNativeExpressBannerViewDelegate
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {
    NSLog(@"nativeExpressBannerAdViewDidLoad");
    
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *)error {
    NSLog(@"nativeExpressAdFailToLoad with error %@", error.description);
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView {
    NSLog(@"nativeExpressBannerAdViewRenderSuccess");
    [self.delegate customEventBanner:self didReceiveAd:bannerAdView];
}

- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError *)error {
    NSLog(@"nativeExpressBannerAdViewRenderFail");
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {
    NSLog(@"nativeExpressBannerAdViewWillBecomVisible");
}

- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {
    NSLog(@"nativeExpressBannerAdViewDidClick");
    [self.delegate customEventBannerWasClicked:self];
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterwords {
    NSLog(@"nativeExpressBannerAdView dislikeWithReason");
    [self.delegate customEventBannerDidDismissModal:self];
}

- (NSString *)processParams:(NSString *)param {
    NSError *jsonReadingError;
    NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&jsonReadingError];
    
    if (jsonReadingError) {
        NSLog(@"jsonReadingError. data=[%@], error=[%@]", json, jsonReadingError);
        return nil;
    }
    
    if (![NSJSONSerialization isValidJSONObject:json]) {
        NSLog(@"This is NOT JSON data.[%@]", json);
        return nil;
    }
    NSString *placementID = json[TEMPLATE_BANNER_PANGLE_PLACEMENT_ID];
    return placementID;
}
@end

