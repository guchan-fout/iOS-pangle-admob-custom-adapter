//
//  BUDAdmob_FullScreenVideoCustomEventAdapter.m
//  AdmobAdapterDemo
//
//  Created by Gu Chan on 2020/07/03.
//  Copyright © 2020 GuChan. All rights reserved.

#import "BUDAdmob_FullScreenVideoCustomEventAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import "BUDAdmob_PangleTool.h"

@interface BUDAdmob_FullScreenVideoCustomEventAdapter() <BUFullscreenVideoAdDelegate>
@property (nonatomic, strong) BUFullscreenVideoAd *fullScreenVideo;
@end

@implementation BUDAdmob_FullScreenVideoCustomEventAdapter
@synthesize delegate;
NSString *const INTERSTITIAL_PANGLE_PLACEMENT_ID = @"placementID";

- (void)presentFromRootViewController:(nonnull UIViewController *)rootViewController {
    [self.fullScreenVideo showAdFromRootViewController:rootViewController];
}

- (void)requestInterstitialAdWithParameter:(nullable NSString *)serverParameter label:(nullable NSString *)serverLabel request:(nonnull GADCustomEventRequest *)request {
    NSString *placementID = [self processParams:serverParameter];
    NSLog(@"placementID=%@",placementID);
    if (placementID != nil) {
        /// tag
        [BUDAdmob_PangleTool setPangleExtData];
        
        self.fullScreenVideo = [[BUFullscreenVideoAd alloc] initWithSlotID:placementID];
        self.fullScreenVideo.delegate = self;
        [self.fullScreenVideo loadAdData];
    } else {
        NSLog(@"no pangle placement ID for requesting.");
    }
}

#pragma mark - <BUFullscreenVideoAdDelegate>

- (void)fullscreenVideoMaterialMetaAdDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd{
    [self.delegate customEventInterstitialDidReceiveAd:self];
}

- (void)fullscreenVideoAd:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error{
    [self.delegate customEventInterstitial:self didFailAd:error];
    NSLog(@"interstitialAd with error %@", error.description);
}

- (void)fullscreenVideoAdVideoDataDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
}

- (void)fullscreenVideoAdWillVisible:(BUFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
}

- (void)fullscreenVideoAdDidVisible:(BUFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
    [self.delegate customEventInterstitialWillPresent:self];
}

- (void)fullscreenVideoAdDidClick:(BUFullscreenVideoAd *)fullscreenVideoAd{
    [self.delegate customEventInterstitialWasClicked:self];
}

- (void)fullscreenVideoAdWillClose:(BUFullscreenVideoAd *)fullscreenVideoAd{
    [self.delegate customEventInterstitialWillDismiss:self];
}

- (void)fullscreenVideoAdDidClose:(BUFullscreenVideoAd *)fullscreenVideoAd{
    [self.delegate customEventInterstitialDidDismiss:self];
}

- (void)fullscreenVideoAdDidPlayFinish:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error{
    NSLog(@"%s",__func__);
}

- (void)fullscreenVideoAdDidClickSkip:(BUFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
}

- (void)fullscreenVideoAdCallback:(BUFullscreenVideoAd *)fullscreenVideoAd withType:(BUFullScreenVideoAdType)fullscreenVideoAdType{
    NSLog(@"%s",__func__);
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
    NSString *placementID = json[INTERSTITIAL_PANGLE_PLACEMENT_ID];
    return placementID;
}

@end
