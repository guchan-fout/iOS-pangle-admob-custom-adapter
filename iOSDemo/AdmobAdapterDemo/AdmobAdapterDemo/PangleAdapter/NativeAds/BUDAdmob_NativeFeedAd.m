//
//  BUDAdmob_NativeFeedAd.m
//  AdmobAdapterDemo
//
//  Created by Gu Chan on 2020/07/06.
//  Copyright © 2020 GuChan. All rights reserved.
//

#import "BUDAdmob_NativeFeedAd.h"

static NSString *const BUDNativeAdTranslateKey = @"bu_nativeAd";

@interface BUDAdmob_NativeFeedAd ()

@property (nonatomic, strong) BUNativeAd *nativeAd;
@property (nonatomic, strong) BUNativeAdRelatedView *relatedView;
@property(nonatomic, copy) NSArray<GADNativeAdImage *> *mappedImages;
@property(nonatomic, strong) GADNativeAdImage *mappedIcon;

@end

@implementation BUDAdmob_NativeFeedAd

- (instancetype)initWithBUNativeAd:(BUNativeAd *)nativeAd {
    self = [super init];
    if (self) {
        self.nativeAd = nativeAd;
        // video view
        if (self.nativeAd.data.imageMode == BUFeedVideoAdModeImage){
            NSLog(@"imagemode is %ld",self.nativeAd.data.imageMode );
            self.relatedView = [[BUNativeAdRelatedView alloc] init];
            self.relatedView.videoAdView.hidden = NO;
            
            [self.relatedView refreshData:nativeAd];
        }
        // main image of the ad
        if (self.nativeAd.data.imageAry[0].imageURL != nil){
            GADNativeAdImage *adImage = [[GADNativeAdImage alloc] initWithImage:[self loadImage:self.nativeAd.data.imageAry[0].imageURL]];
            self.mappedImages = @[adImage];
        }
        
        // icon image of the ad
        if (self.nativeAd.data.icon.imageURL != nil){
            GADNativeAdImage *iconImage = [[GADNativeAdImage alloc] initWithImage:[self loadImage:self.nativeAd.data.icon.imageURL]];
            self.mappedIcon = iconImage;
        }
    }
    return self;
}

- (UIImage *)loadImage:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData: data];
    return image;
}


#pragma mark - getter methods
- (BOOL)hasVideoContent {
    if (self.nativeAd.data.imageMode == BUFeedVideoAdModeImage){
        return YES;
    }
    return NO;
}

- (nullable UIView *)mediaView {
    UIImageView *logoView = self.relatedView.logoImageView;
    CGRect parentFrame = self.relatedView.videoAdView.frame;
    logoView.frame = CGRectMake(parentFrame.size.width-20, parentFrame.size.height-20, 20, 20);
    [self.relatedView.videoAdView addSubview:logoView];
    return self.relatedView.videoAdView;
}

- (NSString *)headline {
    return self.nativeAd.data.AdTitle;
}

- (NSString *)body {
    return self.nativeAd.data.AdDescription;
}

- (NSString *)callToAction {
    return self.nativeAd.data.buttonText;
}

- (NSDecimalNumber *)starRating {
    return [[NSDecimalNumber alloc] initWithInteger:self.nativeAd.data.score];
}

- (NSString *)advertiser {
    return self.nativeAd.data.source;
}

- (GADNativeAdImage *)icon {
    return self.mappedIcon;
}

- (NSArray *)images {
    return self.mappedImages;
}

- (NSDictionary *)extraAssets {
    return @{BUDNativeAdTranslateKey:self.nativeAd};
}

- (NSString *)price {
    return nil;
}

- (NSString *)store {
    return nil;
}

- (CGFloat)mediaContentAspectRatio {
    if (self.nativeAd.data.imageAry[0].height) {
        return self.nativeAd.data.imageAry[0].width / (self.nativeAd.data.imageAry[0].height + 1e-4);
    }
    return 0.0f;
}


- (nullable UIView *)adChoicesView {
    return nil;
}


- (void)didRenderInView:(nonnull UIView *)view
    clickableAssetViews:
(nonnull NSDictionary<GADUnifiedNativeAssetIdentifier, UIView *> *)clickableAssetViews
 nonclickableAssetViews:
(nonnull NSDictionary<GADUnifiedNativeAssetIdentifier, UIView *> *)nonclickableAssetViews
         viewController:(nonnull UIViewController *)viewController {
    [self.nativeAd registerContainer:view withClickableViews:@[view]];
}


@end
