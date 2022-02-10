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
    NSString *maAdUnitId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];
    NSString *strWidth = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"width"];
    NSString *strHeight = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"height"];
    
    CGFloat width = [strWidth respondsToSelector:@selector(floatValue)] ? [strWidth floatValue] : 0;
    CGFloat height = [strWidth respondsToSelector:@selector(floatValue)] ? [strHeight floatValue] : 0;
    
    self.maAdView = [[MAAdView alloc] initWithAdUnitIdentifier:maAdUnitId];
    self.maAdView.frame = CGRectMake(0, 0, width, height);
    self.maAdView.delegate = self;
    [self.maAdView loadAd];
}

- (UIView*) getView {
    return self.maAdView;
}


#pragma mark - MAAdViewAdDelegate

- (void)didClickAd:(nonnull MAAd *)ad {
    [self.customEventShowDelegate customEventClicked];
}

- (void)didDisplayAd:(nonnull MAAd *)ad {
    [self.customEventShowDelegate customEventShown];
}

- (void)didFailToDisplayAd:(nonnull MAAd *)ad withError:(nonnull MAError *)error {
    // No Analog
}

- (void)didFailToLoadAdForAdUnitIdentifier:(nonnull NSString *)adUnitIdentifier withError:(nonnull MAError *)error {
    VRTError *vrtError = [VRTError errorWithCode:VRTErrorCodeCustomEvent message:error.message];
    [self.customEventLoadDelegate customEventFailedToLoadWithError:vrtError];
}

- (void)didHideAd:(nonnull MAAd *)ad {
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeUnknown];
}

- (void)didLoadAd:(nonnull MAAd *)ad {
    [self.customEventLoadDelegate customEventLoaded];
}

- (void)didCollapseAd:(nonnull MAAd *)ad {
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeUnknown];
}

- (void)didExpandAd:(nonnull MAAd *)ad {
    [self.customEventShowDelegate customEventDidPresentModal:VRTModalTypeUnknown];
}

@end
