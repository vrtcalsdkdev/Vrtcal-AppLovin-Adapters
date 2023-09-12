//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
import AppLovinSDK

// Initialization configuration keys
private let keyAppId = "app_id"
typealias VRTAdapterInitializationCompletionHandler = (MAAdapterInitializationStatus, String?) -> Void

class VRTMediationAdapter: ALMediationAdapter, MAAdViewAdapter, VrtcalSdkDelegate, VRTBannerDelegate, MAInterstitialAdapter, VRTInterstitialDelegate {
    private var completionHandler: VRTAdapterInitializationCompletionHandler?
    private var vrtBanner: VRTBanner?
    private var bannerDelegate: MAAdViewAdapterDelegate?
    private var vrtInterstitial: VRTInterstitial?
    private var interstitialDelegate: MAInterstitialAdapterDelegate?

    // MARK: - ALMediationAdapter

    func initialize(with parameters: MAAdapterInitializationParameters, withCompletionHandler completionHandler: @escaping () -> Void) {
        VRTLogWhereAmI()
    }

    func initialize(with parameters: MAAdapterInitializationParameters?, completionHandler: @escaping (_ initializationStatus: MAAdapterInitializationStatus, _ errorMessage: String?) -> Void) {

        VRTLogWhereAmI()
        self.completionHandler = completionHandler

        let strAppId = parameters?.serverParameters[keyAppId] as? String
        if strAppId == nil || !(strAppId is NSString) {
            self.completionHandler(MAAdapterInitializationStatusInitializedFailure, "Unable to extract appId")
            return
        }

        let appId = Int(strAppId ?? "") ?? 0
        DispatchQueue.main.async(execute: { [self] in
            VrtcalSDK.initializeSdk(withAppId: appId, sdkDelegate: self)
            self.completionHandler(MAAdapterInitializationStatusInitializing, nil)
        })
    }

    func sdkInitializationFailedWithError(_ error: Error) {
        VRTLogWhereAmI()
        completionHandler?(MAAdapterInitializationStatusInitializedFailure, error.description())
    }

    func sdkInitialized() {
        VRTLogWhereAmI()
        completionHandler?(MAAdapterInitializationStatusInitializedSuccess, nil)
    }

    func destroy() {
        VRTLogWhereAmI()
    }

    // MARK: - MAAdViewAdapter

    func loadAdViewAd(for parameters: MAAdapterResponseParameters, adFormat: MAAdFormat, andNotify delegate: MAAdViewAdapterDelegate) {
        VRTLogWhereAmI()
        bannerDelegate = delegate


        let zoneId = parameters.thirdPartyAdPlacementIdentifier.intValue
        if zoneId <= 0 {
            let message = "Could not extract zoneId from parameters: \(parameters)"
            let error = MAAdapterError(code: MAAdapterError.errorCodeInvalidConfiguration, errorString: message)
            bannerDelegate?.didFailToLoadAdViewAdWithError(error)
            return
        }

        vrtBanner = VRTBanner(frame: CGRect(x: 0, y: 0, width: adFormat.size.width, height: adFormat.size.height))
        vrtBanner?.adDelegate = self
        vrtBanner?.loadAd(zoneId)
    }

    // MARK: - VRTBannerDelegate

    func vrtBannerAdClicked(_ vrtBanner: VRTBanner) {
        VRTLogWhereAmI()
        bannerDelegate?.didClickAdViewAd()
    }

    func vrtBannerAdFailed(toLoad vrtBanner: VRTBanner, error: Error) {
        VRTLogWhereAmI()
        bannerDelegate?.didFailToLoadAdViewAdWithError(MAAdapterError(nsError: error))
    }

    func vrtBannerAdLoaded(_ vrtBanner: VRTBanner, withAdSize adSize: CGSize) {
        VRTLogWhereAmI()
        bannerDelegate?.didLoadAd(forAdView: vrtBanner)
    }

    func vrtBannerAdWillLeaveApplication(_ vrtBanner: VRTBanner) {
        VRTLogWhereAmI()
        // No Analog
    }

    func vrtBannerDidDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogWhereAmI()
        bannerDelegate?.didCollapseAdViewAd()
    }

    func vrtBannerDidPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogWhereAmI()
        bannerDelegate?.didExpandAdViewAd()
    }

    func vrtBannerVideoCompleted(_ vrtBanner: VRTBanner) {
        VRTLogWhereAmI()
        // No Analog
    }

    func vrtBannerVideoStarted(_ vrtBanner: VRTBanner) {
        VRTLogWhereAmI()
        // No Analog
    }

    func vrtBannerWillDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogWhereAmI()
        // No Analog
    }

    func vrtBannerWillPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogWhereAmI()
        // No Analog
    }

    func vrtViewControllerForModalPresentation() -> UIViewController {
        return ALUtils.topViewControllerFromKeyWindow()
    }

    // MARK: - MAInterstitialAdapter

    func loadInterstitialAd(for parameters: MAAdapterResponseParameters, andNotify delegate: MAInterstitialAdapterDelegate) {
        VRTLogWhereAmI()

        interstitialDelegate = delegate

        let zoneId = parameters.thirdPartyAdPlacementIdentifier.intValue
        if zoneId <= 0 {
            let message = "Could not extract zoneId from parameters: \(parameters)"
            let error = MAAdapterError(code: MAAdapterError.errorCodeInvalidConfiguration, errorString: message)
            bannerDelegate?.didFailToLoadAdViewAdWithError(error)
            return
        }

        vrtInterstitial = VRTInterstitial()
        vrtInterstitial?.adDelegate = self
        vrtInterstitial?.loadAd(zoneId)
    }

    func showInterstitialAd(for parameters: MAAdapterResponseParameters, andNotify delegate: MAInterstitialAdapterDelegate) {
        VRTLogWhereAmI()
        vrtInterstitial?.showAd()
    }

    // MARK: - VRTInterstitialDelegate

    func vrtInterstitialAdClicked(_ vrtInterstitial: VRTInterstitial) {
        VRTLogWhereAmI()
        interstitialDelegate?.didClickInterstitialAd()
    }

    func vrtInterstitialAdDidDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogWhereAmI()
        interstitialDelegate?.didHideInterstitialAd()
    }

    func vrtInterstitialAdDidShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogWhereAmI()
        interstitialDelegate?.didDisplayInterstitialAd()
    }

    func vrtInterstitialAdFailed(toLoad vrtInterstitial: VRTInterstitial, error: Error) {
        VRTLogWhereAmI()
        interstitialDelegate?.didFailToLoadInterstitialAdWithError(MAAdapterError(nsError: error))
    }

    func vrtInterstitialAdFailed(toShow vrtInterstitial: VRTInterstitial, error: Error) {
        VRTLogWhereAmI()
        interstitialDelegate?.didFailToDisplayInterstitialAdWithError(MAAdapterError(nsError: error))
    }

    func vrtInterstitialAdLoaded(_ vrtInterstitial: VRTInterstitial) {
        interstitialDelegate?.didLoadInterstitialAd()
    }

    func vrtInterstitialAdWillDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogWhereAmI()
        // No Analog
    }

    func vrtInterstitialAdWillLeaveApplication(_ vrtInterstitial: VRTInterstitial) {
        VRTLogWhereAmI()
        // No Analog
    }

    func vrtInterstitialAdWillShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogWhereAmI()
        // No Analog
    }

    func vrtInterstitialVideoCompleted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogWhereAmI()
        // No Analog
    }

    func vrtInterstitialVideoStarted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogWhereAmI()
        // No Analog
    }
}