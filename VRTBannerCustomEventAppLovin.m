//Header
#import "VRTBannerCustomEventAppLovin.h"

//Dependencies
#import "AppLovinSDK/AppLovinSDK.h"

@interface VRTBannerCustomEventAppLovin() <MAAdViewAdDelegate>
@property MAAdView *maAdView;
@end

//AppLovin Banner Adapter, Vrtcal as Primary
@implementation VRTBannerCustomEventAppLovin

- (void) loadBannerAd {
    VRTLogWhereAmI();
    NSString *maAdUnitId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];
    NSString *strWidth = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"width"];
    NSString *strHeight = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"height"];
    
    CGFloat width = [strWidth respondsToSelector:@selector(floatValue)] ? [strWidth floatValue] : 320;
    CGFloat height = [strWidth respondsToSelector:@selector(floatValue)] ? [strHeight floatValue] : 50;
    
    self.maAdView = [[MAAdView alloc] initWithAdUnitIdentifier:maAdUnitId];
    self.maAdView.frame = CGRectMake(0, 0, width, height);
    self.maAdView.delegate = self;
    [self.maAdView loadAd];
}

- (UIView*) getView {
    VRTLogWhereAmI();
    return self.maAdView;
}


#pragma mark - MAAdViewAdDelegate

- (void)didClickAd:(nonnull MAAd *)ad {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventClicked];
}

- (void)didDisplayAd:(nonnull MAAd *)ad {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventShown];
}

- (void)didFailToDisplayAd:(nonnull MAAd *)ad withError:(nonnull MAError *)error {
    // No Analog
    VRTLogWhereAmI();
}

- (void)didFailToLoadAdForAdUnitIdentifier:(nonnull NSString *)adUnitIdentifier withError:(nonnull MAError *)error {
    VRTLogWhereAmI();
    VRTError *vrtError = [VRTError errorWithCode:VRTErrorCodeCustomEvent message:error.message];
    [self.customEventLoadDelegate customEventFailedToLoadWithError:vrtError];
}

- (void)didHideAd:(nonnull MAAd *)ad {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeUnknown];
}

- (void)didLoadAd:(nonnull MAAd *)ad {
    VRTLogWhereAmI();
    [self.customEventLoadDelegate customEventLoaded];
}

- (void)didCollapseAd:(nonnull MAAd *)ad {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeUnknown];
}

- (void)didExpandAd:(nonnull MAAd *)ad {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventDidPresentModal:VRTModalTypeUnknown];
}

@end
