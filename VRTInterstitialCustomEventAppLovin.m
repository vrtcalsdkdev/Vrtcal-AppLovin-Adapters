#import <AppLovinSDK/AppLovinSDK.h>
#import "VRTInterstitialCustomEventAppLovin.h"

//AppLovin Interstitial Adapter, Vrtcal as Primary
@interface VRTInterstitialCustomEventAppLovin() <MAAdDelegate>
@property MAInterstitialAd *maIntersatitialAd;
@end


@implementation VRTInterstitialCustomEventAppLovin

- (void) loadInterstitialAd {
    NSString *maAdUnitId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];
    self.maIntersatitialAd = [[MAInterstitialAd alloc] initWithAdUnitIdentifier:maAdUnitId];
    self.maIntersatitialAd.delegate = self;
    [self.maIntersatitialAd loadAd];
}

- (void) showInterstitialAd {
    [self.maIntersatitialAd showAd];
}

#pragma mark - MAAdDelegate
- (void)didLoadAd:(MAAd *)ad {
    [self.customEventLoadDelegate customEventLoaded];
}


- (void)didClickAd:(nonnull MAAd *)ad {
    [self.customEventShowDelegate customEventClicked];
}

- (void)didDisplayAd:(nonnull MAAd *)ad {
    [self.customEventShowDelegate customEventDidPresentModal:VRTModalTypeInterstitial];
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



@end
