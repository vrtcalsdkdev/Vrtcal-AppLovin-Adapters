#import "VRTMediationAdapter.h"
#import <VrtcalSDK/VrtcalSDK.h>

// Initialization configuration keys
static NSString * const keyAppId = @"app_id";

typedef void(^VRTAdapterInitializationCompletionHandler)(MAAdapterInitializationStatus initializationStatus, NSString *_Nullable errorMessage);

@interface VRTMediationAdapter() <MAAdViewAdapter, VrtcalSdkDelegate, VRTBannerDelegate, MAInterstitialAdapter, VRTInterstitialDelegate>
@property VRTAdapterInitializationCompletionHandler completionHandler;


@property VRTBanner *vrtBanner;
@property id <MAAdViewAdapterDelegate> bannerDelegate;

@property VRTInterstitial *vrtInterstitial;
@property id <MAInterstitialAdapterDelegate> interstitialDelegate;

@end

@implementation VRTMediationAdapter

#pragma mark - ALMediationAdapter
- (void)initializeWithParameters:(nonnull id<MAAdapterInitializationParameters>)parameters withCompletionHandler:(nonnull void (^)(void))completionHandler {
    VRTLogWhereAmI();
}


- (void)initializeWithParameters:(id<MAAdapterInitializationParameters>)parameters completionHandler:(void(^)(MAAdapterInitializationStatus initializationStatus, NSString *_Nullable errorMessage))completionHandler {
    
    VRTLogWhereAmI();
    self.completionHandler = completionHandler;
    
    NSString *strAppId = parameters.serverParameters[keyAppId];
    if (!strAppId || ![strAppId isKindOfClass:[NSString class]]) {
        self.completionHandler(MAAdapterInitializationStatusInitializedFailure, @"Unable to extract appId");
        return;
    }
    
    int appId = [strAppId intValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [VrtcalSDK initializeSdkWithAppId:appId sdkDelegate:self];
        self.completionHandler(MAAdapterInitializationStatusInitializing, nil);
    });
}

- (void)sdkInitializationFailedWithError:(nonnull NSError *)error {
    VRTLogWhereAmI();
    self.completionHandler(MAAdapterInitializationStatusInitializedFailure, [error description]);
}

- (void)sdkInitialized {
    VRTLogWhereAmI();
    self.completionHandler(MAAdapterInitializationStatusInitializedSuccess, nil);
}

- (void)destroy {
    VRTLogWhereAmI();
}


#pragma mark - MAAdViewAdapter

- (void)loadAdViewAdForParameters:(nonnull id<MAAdapterResponseParameters>)parameters adFormat:(nonnull MAAdFormat *)adFormat andNotify:(nonnull id<MAAdViewAdapterDelegate>)delegate {
    VRTLogWhereAmI();
    self.bannerDelegate = delegate;
    

    int zoneId = [parameters.thirdPartyAdPlacementIdentifier intValue];
    if (zoneId <= 0) {
        NSString *message = [NSString stringWithFormat:@"Could not extract zoneId from parameters: %@", parameters];
        MAAdapterError *error = [MAAdapterError errorWithCode:MAAdapterError.errorCodeInvalidConfiguration errorString:message];
        [self.bannerDelegate didFailToLoadAdViewAdWithError:error];
        return;
    }

    self.vrtBanner = [[VRTBanner alloc] initWithFrame:CGRectMake(0, 0, adFormat.size.width, adFormat.size.height)];
    self.vrtBanner.adDelegate = self;
    [self.vrtBanner loadAd:zoneId];
}


#pragma mark - VRTBannerDelegate
- (void)vrtBannerAdClicked:(nonnull VRTBanner *)vrtBanner {
    VRTLogWhereAmI();
    [self.bannerDelegate didClickAdViewAd];
}

- (void)vrtBannerAdFailedToLoad:(nonnull VRTBanner *)vrtBanner error:(nonnull NSError *)error {
    VRTLogWhereAmI();
    [self.bannerDelegate didFailToLoadAdViewAdWithError:[MAAdapterError errorWithNSError:error]];
}

- (void)vrtBannerAdLoaded:(nonnull VRTBanner *)vrtBanner withAdSize:(CGSize)adSize {
    VRTLogWhereAmI();
    [self.bannerDelegate didLoadAdForAdView:vrtBanner];
}

- (void)vrtBannerAdWillLeaveApplication:(nonnull VRTBanner *)vrtBanner {
    VRTLogWhereAmI();
    // No Analog
}

- (void)vrtBannerDidDismissModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    VRTLogWhereAmI();
    [self.bannerDelegate didCollapseAdViewAd];
}

- (void)vrtBannerDidPresentModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    VRTLogWhereAmI();
    [self.bannerDelegate didExpandAdViewAd];
}

- (void)vrtBannerVideoCompleted:(nonnull VRTBanner *)vrtBanner {
    VRTLogWhereAmI();
    // No Analog
}

- (void)vrtBannerVideoStarted:(nonnull VRTBanner *)vrtBanner {
    VRTLogWhereAmI();
    // No Analog
}

- (void)vrtBannerWillDismissModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    VRTLogWhereAmI();
    // No Analog
}

- (void)vrtBannerWillPresentModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    VRTLogWhereAmI();
    // No Analog
}

- (nonnull UIViewController *)vrtViewControllerForModalPresentation {
    return [ALUtils topViewControllerFromKeyWindow];
}





#pragma mark - MAInterstitialAdapter

- (void)loadInterstitialAdForParameters:(nonnull id<MAAdapterResponseParameters>)parameters andNotify:(nonnull id<MAInterstitialAdapterDelegate>)delegate {
    VRTLogWhereAmI();
    
    self.interstitialDelegate = delegate;
    
    int zoneId = [parameters.thirdPartyAdPlacementIdentifier intValue];
    if (zoneId <= 0) {
        NSString *message = [NSString stringWithFormat:@"Could not extract zoneId from parameters: %@", parameters];
        MAAdapterError *error = [MAAdapterError errorWithCode:MAAdapterError.errorCodeInvalidConfiguration errorString:message];
        [self.bannerDelegate didFailToLoadAdViewAdWithError:error];
        return;
    }
    
    self.vrtInterstitial = [[VRTInterstitial alloc] init];
    self.vrtInterstitial.adDelegate = self;
    [self.vrtInterstitial loadAd:zoneId];
}

- (void)showInterstitialAdForParameters:(nonnull id<MAAdapterResponseParameters>)parameters andNotify:(nonnull id<MAInterstitialAdapterDelegate>)delegate {
    VRTLogWhereAmI();
    [self.vrtInterstitial showAd];
}


#pragma mark - VRTInterstitialDelegate

- (void)vrtInterstitialAdClicked:(nonnull VRTInterstitial *)vrtInterstitial {
    VRTLogWhereAmI();
    [self.interstitialDelegate didClickInterstitialAd];
}


- (void)vrtInterstitialAdDidDismiss:(nonnull VRTInterstitial *)vrtInterstitial {
    VRTLogWhereAmI();
    [self.interstitialDelegate didHideInterstitialAd];
}


- (void)vrtInterstitialAdDidShow:(nonnull VRTInterstitial *)vrtInterstitial {
    VRTLogWhereAmI();
    [self.interstitialDelegate didDisplayInterstitialAd];
}


- (void)vrtInterstitialAdFailedToLoad:(nonnull VRTInterstitial *)vrtInterstitial error:(nonnull NSError *)error {
    VRTLogWhereAmI();
    [self.interstitialDelegate didFailToLoadInterstitialAdWithError:[MAAdapterError errorWithNSError:error]];
}


- (void)vrtInterstitialAdFailedToShow:(nonnull VRTInterstitial *)vrtInterstitial error:(nonnull NSError *)error {
    VRTLogWhereAmI();
    [self.interstitialDelegate didFailToDisplayInterstitialAdWithError:[MAAdapterError errorWithNSError:error]];
}


- (void)vrtInterstitialAdLoaded:(nonnull VRTInterstitial *)vrtInterstitial {
    [self.interstitialDelegate didLoadInterstitialAd];
}


- (void)vrtInterstitialAdWillDismiss:(nonnull VRTInterstitial *)vrtInterstitial {
    VRTLogWhereAmI();
    // No Analog
}


- (void)vrtInterstitialAdWillLeaveApplication:(nonnull VRTInterstitial *)vrtInterstitial {
    VRTLogWhereAmI();
    // No Analog
}


- (void)vrtInterstitialAdWillShow:(nonnull VRTInterstitial *)vrtInterstitial {
    VRTLogWhereAmI();
    // No Analog
}


- (void)vrtInterstitialVideoCompleted:(nonnull VRTInterstitial *)vrtInterstitial {
    VRTLogWhereAmI();
    // No Analog
}


- (void)vrtInterstitialVideoStarted:(nonnull VRTInterstitial *)vrtInterstitial {
    VRTLogWhereAmI();
    // No Analog
}



@end
