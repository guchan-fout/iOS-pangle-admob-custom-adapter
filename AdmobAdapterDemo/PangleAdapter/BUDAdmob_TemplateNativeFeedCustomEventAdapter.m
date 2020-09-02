//
//  BUDAdmob_TemplateNativeFeedCustomEventAdapter.m
//  AdmobAdapterDemo
//
//  Created by Chan Gu on 2020/09/01.
//  Copyright © 2020 GuChan. All rights reserved.
//

#import "BUDAdmob_TemplateNativeFeedCustomEventAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import <BUAdSDK/BUNativeExpressAdManager.h>
#import <BUAdSDK/BUNativeExpressAdView.h>
#import <GoogleMobileAds/GADCustomEventNativeAd.h>
#import <GoogleMobileAds/GADMultipleAdsAdLoaderOptions.h>
#import "BUDAdmob_TemplateNativeFeedAd.h"

@interface BUDAdmob_TemplateNativeFeedCustomEventAdapter ()<GADCustomEventNativeAd,BUNativeExpressAdViewDelegate>

@property (strong, nonatomic) NSMutableArray<__kindof BUNativeExpressAdView *> *expressAdViews;
@property (strong, nonatomic) BUNativeExpressAdManager *nativeExpressAdManager;

@property(strong, nonatomic) UIViewController *rootViewController;
@end

@implementation BUDAdmob_TemplateNativeFeedCustomEventAdapter

@synthesize delegate;

NSString *const TEMPLATE_FEED_PANGLE_PLACEMENT_ID = @"placementID";

- (void)getTemplateNativeAd:(NSString *)placementID count:(NSInteger)count {
    NSLog(@"placementID=%@",placementID);
    // load 3 ads a time
    // important: DO NOT set more than 3 one time
    int ad_count = 1;
    
    if (!self.expressAdViews) {
        self.expressAdViews = [NSMutableArray arrayWithCapacity:ad_count];
    }
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = placementID;
    slot.AdType = BUAdSlotAdTypeFeed;
    BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Banner600_500];
    slot.imgSize = imgSize;
    slot.position = BUAdSlotPositionFeed;
    slot.isSupportDeepLink = YES;
    
    
    // Please reset your ad view's size here
    CGFloat adViewWidth = 300;
    CGFloat adViewHeight = 250;
    
    self.nativeExpressAdManager = [[BUNativeExpressAdManager alloc] initWithSlot:slot adSize:CGSizeMake(adViewWidth, adViewHeight)];

    self.nativeExpressAdManager.delegate = self;
    
    [self.nativeExpressAdManager loadAd:ad_count];
}

#pragma mark - GADCustomEventNativeAd
- (void)requestNativeAdWithParameter:(NSString *)serverParameter request:(GADCustomEventRequest *)request adTypes:(NSArray *)adTypes options:(NSArray *)options rootViewController:(UIViewController *)rootViewController {
    
    NSInteger count = 1;
    
    self.rootViewController = rootViewController;
    for (id obj in options) {
        if ([obj isKindOfClass:[GADMultipleAdsAdLoaderOptions class]]) {
            count = ((GADMultipleAdsAdLoaderOptions *)obj).numberOfAds;
        }
    }
    NSString *placementID = [self processParams:serverParameter];
    if (placementID != nil){
        [self getTemplateNativeAd:placementID count:count];
    } else {
        NSLog(@"no pangle placement ID for requesting.");
    }
}

- (BOOL)handlesUserClicks {
    return NO;
}

- (BOOL)handlesUserImpressions {
    return NO;
}

#pragma mark - BUNativeExpressAdViewDelegate
- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAd views:(NSArray<__kindof BUNativeExpressAdView *> *)views {
    NSLog(@"nativeExpressAdSuccessToLoad");
    
    [self.expressAdViews removeAllObjects];
    if (views.count) {
        [self.expressAdViews addObjectsFromArray:views];
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
             
            BUNativeExpressAdView *expressView = (BUNativeExpressAdView *)obj;

                
            /*
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            UIViewController *rootViewController = window.rootViewController;
            while (rootViewController.presentedViewController) {
                rootViewController = rootViewController.presentedViewController;
            }
             
            expressView.rootViewController = rootViewController;
            [expressView render];
             */
            expressView.rootViewController = self.rootViewController;
            
            NSLog(@"%@", NSStringFromClass(expressView.rootViewController.class));
            [expressView render];
        }];
    }
}

- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAd error:(NSError *)error {
    NSLog(@"nativeExpressAdFailToLoad with error %@", error.description);
}

- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"nativeExpressAdViewRenderSuccess");
    
    BUDAdmob_TemplateNativeFeedAd *ad = [[BUDAdmob_TemplateNativeFeedAd alloc] initWithBUNativeAd:nativeExpressAdView];
    //BUDAdmob_TemplateNativeFeedAd *ad = BUD
    [self.delegate customEventNativeAd:self didReceiveMediatedUnifiedNativeAd:ad];
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView stateDidChanged:(BUPlayerPlayState)playerState {

    NSLog(@"nativeExpressAdView stateDidChanged BUPlayerPlayState:%ld",(long)playerState);
}

- (void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
    NSLog(@"nativeExpressAdViewRenderFail with error %@", error.description);
}

- (void)nativeExpressAdViewWillShow:(BUNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"nativeExpressAdViewWillShow");
}

- (void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"nativeExpressAdViewDidClick");
}

- (void)nativeExpressAdViewPlayerDidPlayFinish:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
    NSLog(@"nativeExpressAdViewPlayerDidPlayFinish with error %@", error.description);
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords {
    NSLog(@"nativeExpressAdView dislikeWithReason");
}

- (void)nativeExpressAdViewDidClosed:(BUNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"nativeExpressAdViewDidClosed");
}

- (void)nativeExpressAdViewWillPresentScreen:(BUNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"nativeExpressAdViewWillPresentScreen");
}

- (void)nativeExpressAdViewDidCloseOtherController:(BUNativeExpressAdView *)nativeExpressAdView interactionType:(BUInteractionType)interactionType {
    NSString *str = nil;
    if (interactionType == BUInteractionTypePage) {
        str = @"ladingpage";
    } else if (interactionType == BUInteractionTypeVideoAdDetail) {
        str = @"videoDetail";
    } else {
        str = @"appstoreInApp";
    }
    NSLog(@"nativeExpressAdViewDidCloseOtherController: %@", str);
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
    NSString *placementID = json[TEMPLATE_FEED_PANGLE_PLACEMENT_ID];
    return placementID;
}



@end

