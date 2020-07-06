//
//  BUDAdmob_NativeFeedAdModel.m
//  AdmobAdapterDemo
//
//  Created by Gu Chan on 2020/07/06.
//  Copyright © 2020 GuChan. All rights reserved.
//

#import "BUDAdmob_NativeFeedAdModel.h"

static NSString *const BUDNativeAdTranslateKey = @"bu_nativeAd";

@interface BUDAdmob_NativeFeedAdModel ()

@property(nonatomic, copy) NSArray *mappedImages;
@property(nonatomic, strong) GADNativeAdImage *mappedIcon;

@end

@implementation BUDAdmob_NativeFeedAdModel

- (instancetype)initWithBUNativeAd:(BUNativeAd *)nativeAd {
    self = [super init];
    if (self) {
        self.nativeAd = nativeAd;
        NSURL *imageUrl = [[NSURL alloc]initWithString:self.nativeAd.data.imageAry[0].imageURL];
        
        CGFloat scale = self.nativeAd.data.imageAry[0].width/(self.nativeAd.data.imageAry[0].height + 1e-4);
        self.mappedImages = @[[[GADNativeAdImage alloc] initWithURL:imageUrl scale:scale]];
    }
    return self;
}

- (GADNativeAdImage *)buImageToGADImage:(BUImage *)buImage {
    NSURL *url = [NSURL URLWithString:buImage.imageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData: data];
    GADNativeAdImage *gadImage = [[GADNativeAdImage alloc] initWithImage:image];
    return gadImage;
}


#pragma mark - getter methods
- (BOOL)hasVideoContent {
    if (self.nativeAd.data.imageMode == BUFeedVideoAdModeImage){
        return YES;
    }
    return NO;
}

- (nullable UIView *)mediaView {
    NSLog(@"mediaView");
    return self.relatedView;
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
    return [self buImageToGADImage:self.nativeAd.data.icon];
}

- (NSArray *)images {

    //return self.mappedImages;
    
    NSMutableArray *imgTemp = [[NSMutableArray alloc] initWithCapacity:self.nativeAd.data.imageAry.count];
    
    

    for (BUImage *img in self.nativeAd.data.imageAry) {
        [imgTemp addObject:[self buImageToGADImage:img]];
    }
    return [imgTemp copy];
     
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

@end
