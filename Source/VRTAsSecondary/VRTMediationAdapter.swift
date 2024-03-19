import AppLovinSDK
import VrtcalSDK

// Initialization configuration keys
private let keyAppId = "app_id"
typealias VRTAdapterInitializationCompletionHandler = (MAAdapterInitializationStatus, String?) -> Void

class VRTMediationAdapter: ALMediationAdapter {
    private var completionHandler: VRTAdapterInitializationCompletionHandler?
    private var vrtBanner: VRTBanner?
    private var bannerDelegate: MAAdViewAdapterDelegate?
    private var vrtInterstitial: VRTInterstitial?
    private var interstitialDelegate: MAInterstitialAdapterDelegate?

    override func initialize(
        with parameters: MAAdapterInitializationParameters,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        /*
         Note:
         This should be called when AppLovin initializes, but will not run when on simulator.
         Also, use ALSdk.shared()!.showMediationDebugger() to determine if Vrtcal is in the
         waterfall. Make sure to look for ❌ icons. May need to update SKAdNetworks.
        */
        VRTLogInfo()
    }
    
    override func initialize(
        with parameters: MAAdapterInitializationParameters?,
        completionHandler: @escaping (_ initializationStatus: MAAdapterInitializationStatus, _ errorMessage: String?) -> Void
    ) {
        
        VRTLogInfo()
        self.completionHandler = completionHandler
        
        guard let strAppId = parameters?.serverParameters[keyAppId] as? String,
        let appId = Int(strAppId) else {
            self.completionHandler?(.initializedFailure, "Unable to extract appId")
            return
        }
        
        DispatchQueue.main.async(execute: { [self] in
            VrtcalSDK.initializeSdk(withAppId: appId, sdkDelegate: self)
            self.completionHandler?(.initializing, nil)
        })
    }
}

extension VRTMediationAdapter: VrtcalSdkDelegate {
    func sdkInitializationFailedWithError(_ error: Error) {
        VRTLogInfo()
        completionHandler?(.initializedFailure, "\(error)")
    }

    func sdkInitialized() {
        VRTLogInfo()
        completionHandler?(.initializedSuccess, nil)
    }
}


extension VRTMediationAdapter: MAAdViewAdapter {
    // MARK: - MAAdViewAdapter
    func loadAdViewAd(for parameters: MAAdapterResponseParameters, adFormat: MAAdFormat, andNotify delegate: MAAdViewAdapterDelegate) {
        VRTLogInfo()
        bannerDelegate = delegate
        
        
        guard let zoneId = Int(parameters.thirdPartyAdPlacementIdentifier),
        zoneId > 0 else {
            let message = "Could not extract thirdPartyAdPlacementIdentifier (zoneId) from parameters: \(parameters)"
            
            let error = MAAdapterError(
                code: MAAdapterError.errorCodeInvalidConfiguration,
                errorString: message
            )
            bannerDelegate?.didFailToLoadAdViewAdWithError(error)
            return
        }
        
        vrtBanner = VRTBanner(frame: CGRect(x: 0, y: 0, width: adFormat.size.width, height: adFormat.size.height))
        vrtBanner?.adDelegate = self
        vrtBanner?.loadAd(zoneId)
    }
}


// MARK: - VRTBannerDelegate
extension VRTMediationAdapter: VRTBannerDelegate {

    func vrtBannerAdClicked(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        bannerDelegate?.didClickAdViewAd()
    }
    
    func vrtBannerAdFailedToLoad(_ vrtBanner: VRTBanner, error: Error) {
        VRTLogInfo()
        bannerDelegate?.didFailToLoadAdViewAdWithError(MAAdapterError(nsError: error))
    }
    
    func vrtBannerAdLoaded(_ vrtBanner: VRTBanner, withAdSize adSize: CGSize) {
        VRTLogInfo()
        bannerDelegate?.didLoadAd(forAdView: vrtBanner)
    }
    
    func vrtBannerAdWillLeaveApplication(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        // No Analog
    }
    
    func vrtBannerDidDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
        bannerDelegate?.didCollapseAdViewAd()
    }
    
    func vrtBannerDidPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
        bannerDelegate?.didExpandAdViewAd()
    }
    
    func vrtBannerVideoCompleted(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        // No Analog
    }
    
    func vrtBannerVideoStarted(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        // No Analog
    }
    
    func vrtBannerWillDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
        // No Analog
    }
    
    func vrtBannerWillPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
        // No Analog
    }
    
    func vrtViewControllerForModalPresentation() -> UIViewController? {
        return ALUtils.topViewControllerFromKeyWindow()
    }
}

// MARK: - MAInterstitialAdapter
extension VRTMediationAdapter: MAInterstitialAdapter {
    func loadInterstitialAd(for parameters: MAAdapterResponseParameters, andNotify delegate: MAInterstitialAdapterDelegate) {
        VRTLogInfo()
        
        interstitialDelegate = delegate
        
        guard let zoneId = Int(parameters.thirdPartyAdPlacementIdentifier),
        zoneId > 0 else {
            let message = "Could not extract thirdPartyAdPlacementIdentifier (zoneId) from parameters: \(parameters)"
            let error = MAAdapterError(code: MAAdapterError.errorCodeInvalidConfiguration, errorString: message)
            bannerDelegate?.didFailToLoadAdViewAdWithError(error)
            return
        }
        
        vrtInterstitial = VRTInterstitial()
        vrtInterstitial?.adDelegate = self
        vrtInterstitial?.loadAd(zoneId)
    }
    
    func showInterstitialAd(for parameters: MAAdapterResponseParameters, andNotify delegate: MAInterstitialAdapterDelegate) {
        VRTLogInfo()
        vrtInterstitial?.showAd()
    }
}

// MARK: - VRTInterstitialDelegate
extension VRTMediationAdapter: VRTInterstitialDelegate {
    func vrtInterstitialAdClicked(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        interstitialDelegate?.didClickInterstitialAd()
    }

    func vrtInterstitialAdDidDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        interstitialDelegate?.didHideInterstitialAd()
    }

    func vrtInterstitialAdDidShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        interstitialDelegate?.didDisplayInterstitialAd()
    }

    func vrtInterstitialAdFailed(toLoad vrtInterstitial: VRTInterstitial, error: Error) {
        VRTLogInfo()
        interstitialDelegate?.didFailToLoadInterstitialAdWithError(MAAdapterError(nsError: error))
    }

    func vrtInterstitialAdFailed(toShow vrtInterstitial: VRTInterstitial, error: Error) {
        VRTLogInfo()
        interstitialDelegate?.didFailToDisplayInterstitialAdWithError(MAAdapterError(nsError: error))
    }

    func vrtInterstitialAdLoaded(_ vrtInterstitial: VRTInterstitial) {
        interstitialDelegate?.didLoadInterstitialAd()
    }

    func vrtInterstitialAdWillDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No Analog
    }

    func vrtInterstitialAdWillLeaveApplication(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No Analog
    }

    func vrtInterstitialAdWillShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No Analog
    }

    func vrtInterstitialVideoCompleted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No Analog
    }

    func vrtInterstitialVideoStarted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No Analog
    }
}
