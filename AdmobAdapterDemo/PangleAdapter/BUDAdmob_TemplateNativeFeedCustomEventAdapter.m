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
#import <GoogleMobileAds/GADCustomEventBanner.h>
#import "BUDAdmob_PangleTool.h"

@interface BUDAdmob_TemplateNativeFeedCustomEventAdapter ()<GADCustomEventBanner, BUNativeExpressAdViewDelegate>

@property (strong, nonatomic) NSMutableArray<__kindof BUNativeExpressAdView *> *expressAdViews;
@property (strong, nonatomic) BUNativeExpressAdManager *nativeExpressAdManager;

@end

@implementation BUDAdmob_TemplateNativeFeedCustomEventAdapter

@synthesize delegate;

NSString *const TEMPLATE_FEED_PANGLE_PLACEMENT_ID = @"placementID";


- (void)requestBannerAd:(GADAdSize)adSize parameter:(nullable NSString *)serverParameter label:(nullable NSString *)serverLabel request:(nonnull GADCustomEventRequest *)request {

    NSString *placementID = [self processParams:serverParameter];
    if (placementID != nil){
        /// tag
        [BUDAdmob_PangleTool setPangleExtData];
        
        [self getTemplateNativeAd:placementID adSize:adSize];
    } else {
        NSLog(@"no pangle placement ID for requesting.");
    }
}

- (void)getTemplateNativeAd:(NSString *)placementID adSize:(GADAdSize)adSize {
    NSLog(@"placementID=%@",placementID);
    NSLog(@"request ad size width = %f",adSize.size.width);
    NSLog(@"request ad size height = %f",adSize.size.height);
    
    // IMPORTANT: DO NOT set except 1, not ready for multiple request
    int ad_count = 1;
    
    if (!self.expressAdViews) {
        self.expressAdViews = [NSMutableArray arrayWithCapacity:ad_count];
    }
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = placementID;
    slot.AdType = BUAdSlotAdTypeFeed;
    BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Feed228_150];
    slot.imgSize = imgSize;
    slot.position = BUAdSlotPositionFeed;
    
    // Please set your ad view's size here
    CGFloat adViewWidth = adSize.size.width;
    CGFloat adViewHeight = adSize.size.height;
    
    self.nativeExpressAdManager = [[BUNativeExpressAdManager alloc] initWithSlot:slot adSize:CGSizeMake(adViewWidth, adViewHeight)];
    self.nativeExpressAdManager.delegate = self;
    
    [self.nativeExpressAdManager loadAdDataWithCount:ad_count];
}


#pragma mark - BUNativeExpressAdViewDelegate
- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAd views:(NSArray<__kindof BUNativeExpressAdView *> *)views {
    NSLog(@"nativeExpressAdSuccessToLoad");
    [self.expressAdViews removeAllObjects];
    
    if (views.count) {
        [self.expressAdViews addObjectsFromArray:views];
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BUNativeExpressAdView *expressView = (BUNativeExpressAdView *)obj;
            expressView.rootViewController = self.delegate.viewControllerForPresentingModalView;
            
            //Please make sure you have a UIWindow in your AppDelegate,or maybe crash
            [expressView render];
        }];
    }
}

- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAd error:(NSError *)error {
    NSLog(@"nativeExpressAdFailToLoad with error %@", error.description);
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"nativeExpressAdViewRenderSuccess");
    [self.delegate customEventBanner:self didReceiveAd:nativeExpressAdView];
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView stateDidChanged:(BUPlayerPlayState)playerState {
    NSLog(@"nativeExpressAdView stateDidChanged BUPlayerPlayState:%ld",(long)playerState);
}

- (void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
    NSLog(@"nativeExpressAdViewRenderFail with error %@", error.description);
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)nativeExpressAdViewWillShow:(BUNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"nativeExpressAdViewWillShow");
}

- (void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"nativeExpressAdViewDidClick");
    [self.delegate customEventBannerWasClicked:self];
}

- (void)nativeExpressAdViewPlayerDidPlayFinish:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
    NSLog(@"nativeExpressAdViewPlayerDidPlayFinish with error %@", error.description);
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords {
    NSLog(@"nativeExpressAdView dislikeWithReason");
    [self.expressAdViews removeObject:nativeExpressAdView];
    [self.delegate customEventBannerDidDismissModal:self];
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
        NSLog(@"This is NOT JSON data.");
        return nil;
    }
    NSString *placementID = json[TEMPLATE_FEED_PANGLE_PLACEMENT_ID];
    return placementID;
}

@end

