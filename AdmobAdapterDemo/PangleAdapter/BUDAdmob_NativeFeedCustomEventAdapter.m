//
//  BUDAdmob_NativeFeedCustomEventAdapter.m
//  AdmobAdapterDemo
//
//  Created by Gu Chan on 2020/07/03.
//  Copyright © 2020 GuChan. All rights reserved.
//

#import "BUDAdmob_NativeFeedCustomEventAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import <GoogleMobileAds/GADCustomEventNativeAd.h>
#import <GoogleMobileAds/GADMultipleAdsAdLoaderOptions.h>
#import "BUDAdmob_NativeFeedAd.h"
#import "BUDAdmob_PangleTool.h"


@interface BUDAdmob_NativeFeedCustomEventAdapter ()<GADCustomEventNativeAd,BUNativeAdsManagerDelegate>

@property (nonatomic, strong, getter=getNativeAd)BUNativeAdsManager *adManager;

@end



@implementation BUDAdmob_NativeFeedCustomEventAdapter

@synthesize delegate;

NSString *const FEED_PANGLE_PLACEMENT_ID = @"placementID";

- (void)getNativeAd:(NSString *)placementID count:(NSInteger)count {
    if (self.adManager == nil) {
        BUAdSlot *slot = [[BUAdSlot alloc] init];
        //slot.ID = @"945292641" for video
        slot.ID = placementID;
        slot.AdType = BUAdSlotAdTypeFeed;
        slot.position = BUAdSlotPositionTop;
        slot.imgSize = [BUSize sizeBy:BUProposalSize_Banner600_400];
        self.adManager = [[BUNativeAdsManager alloc] initWithSlot:slot];
        self.adManager.delegate = self;
    }
    [self.adManager loadAdDataWithCount:count];
}

#pragma mark - GADCustomEventNativeAd
- (void)requestNativeAdWithParameter:(NSString *)serverParameter request:(GADCustomEventRequest *)request adTypes:(NSArray *)adTypes options:(NSArray *)options rootViewController:(UIViewController *)rootViewController {
    NSInteger count = 1;
    for (id obj in options) {
        if ([obj isKindOfClass:[GADMultipleAdsAdLoaderOptions class]]) {
            count = ((GADMultipleAdsAdLoaderOptions *)obj).numberOfAds;
        }
    }
    NSString *placementID = [self processParams:serverParameter];
    NSLog(@"placementID=%@",placementID);
    if (placementID != nil){
        /// tag
        [BUDAdmob_PangleTool setPangleExtData];
        
        [self getNativeAd:placementID count:count];
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

#pragma mark - BUNativeAdsManagerDelegate
- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray {

    for (BUNativeAd * nativeAd in nativeAdDataArray) {
        BUDAdmob_NativeFeedAd *ad = [[BUDAdmob_NativeFeedAd alloc] initWithBUNativeAd:nativeAd];

        [self.delegate customEventNativeAd:self didReceiveMediatedUnifiedNativeAd:ad];
    }
}

- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    NSLog(@"nativeAdsManager with error %@", error.description);
    [self.delegate customEventNativeAd:self didFailToLoadWithError:error];
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
    NSString *placementID = json[FEED_PANGLE_PLACEMENT_ID];
    return placementID;
}

@end
