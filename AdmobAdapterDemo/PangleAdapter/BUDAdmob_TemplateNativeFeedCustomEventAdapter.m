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

@interface BUDAdmob_TemplateNativeFeedCustomEventAdapter ()<GADCustomEventBanner,BUNativeExpressAdViewDelegate>

@property (strong, nonatomic) NSMutableArray<__kindof BUNativeExpressAdView *> *expressAdViews;
@property (strong, nonatomic) BUNativeExpressAdManager *nativeExpressAdManager;

@property(strong, nonatomic) UIViewController *rootViewController;
@end

@implementation BUDAdmob_TemplateNativeFeedCustomEventAdapter

@synthesize delegate;

NSString *const TEMPLATE_FEED_PANGLE_PLACEMENT_ID = @"placementID";

/*
+ (BUDAdmob_TemplateNativeFeedCustomEventAdapter *)sharedInstance {
    static BUDAdmob_TemplateNativeFeedCustomEventAdapter *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BUDAdmob_TemplateNativeFeedCustomEventAdapter alloc] init];
    });

     return sharedInstance;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"..." userInfo:nil];
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        
    }
    return self;
}
 */

- (void)requestBannerAd:(GADAdSize)adSize parameter:(nullable NSString *)serverParameter label:(nullable NSString *)serverLabel request:(nonnull GADCustomEventRequest *)request {
    NSInteger count = 1;
    
    NSString *placementID = [self processParams:serverParameter];
    if (placementID != nil){
        [self getTemplateNativeAd:placementID count:count];
    } else {
        NSLog(@"no pangle placement ID for requesting.");
    }
}

- (void)getTemplateNativeAd:(NSString *)placementID count:(NSInteger)count {
    NSLog(@"placementID=%@",placementID);
    // important: DO NOT set except 1, not ready for multi
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


#pragma mark - BUNativeExpressAdViewDelegate
- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAd views:(NSArray<__kindof BUNativeExpressAdView *> *)views {
    NSLog(@"nativeExpressAdSuccessToLoad");
    [self.expressAdViews removeAllObjects];
    
    if (views.count) {
        [self.expressAdViews addObjectsFromArray:views];
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BUNativeExpressAdView *expressView = (BUNativeExpressAdView *)obj;
            expressView.rootViewController = self.rootViewController;
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

    //NSUInteger index = [self.expressAdViews indexOfObject:nativeExpressAdView];
    //NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
   // [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.delegate customEventBannerWillLeaveApplication:self];
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

