import AppLovinSDK
import VrtcalSDK

@objc(VRTMediationAdapter)
final class VRTMediationAdapter: ALMediationAdapter {

    // AppLovin
    override var thirdPartySdkName: String { "Vrtcal" }
    override var adapterVersion: String { "1.0.0.0" }
    override var sdkVersion: String { "2.0.0.0" }
    
    private var completionHandler: MAAdapterInitializationCompletionHandler?
    private var maAdViewAdapterDelegate: MAAdViewAdapterDelegate?
    private var maInterstitialAdapterDelegate: MAInterstitialAdapterDelegate?
    
    // Vrtcal
    private static let initialized = ALAtomicBoolean()
    private var vrtBanner: VRTBanner?
    private var vrtInterstitial: VRTInterstitial?
    
    // MARK: - Init
    override func initialize(
        with parameters: MAAdapterInitializationParameters,
        completionHandler: @escaping MAAdapterInitializationCompletionHandler
    ) {
        VRTLogInfo(parameters.longDescription)
        
        /*
         Note:
         This should be called when AppLovin initializes but will not run when on simulator.
         Use ALSdk.shared()!.showMediationDebugger() to determine if VrtcalSDK is in the
         waterfall. Make sure to look for ❌ icons. May need to update SKAdNetworks.
        */
        
        guard Self.initialized.compareAndSet(false, update: true) else {
            log(lifecycleEvent: .alreadyInitialized)
            completionHandler(.doesNotApply, nil)
            return
        }
        
        self.completionHandler = completionHandler
        
        // Get AppId or bail
        guard let strAppId = parameters.serverParameters["app_id"] as? String,
        let appId = Int(strAppId) else {
            VRTLogError("Unable to extract app_id")
            self.completionHandler?(.initializedFailure, "Unable to extract app_id")
            return
        }
        
        // Init VrtcalSDK
        completionHandler(.initializing, nil)
        VrtcalSDK.initializeSdk(withAppId: appId, sdkDelegate: self)
    }
    
    override func destroy() {
        VRTLogInfo()
        log(lifecycleEvent: .destroy)
        
        vrtBanner?.adDelegate = nil
        vrtBanner = nil
        
        vrtInterstitial?.adDelegate = nil
        vrtInterstitial = nil
    }
}

// MARK: VrtcalSdkDelegate
extension VRTMediationAdapter: VrtcalSdkDelegate {
    public func sdkInitializationFailedWithError(_ error: Error) {
        VRTLogError("error: \(error)")
        completionHandler?(.initializedFailure, "\(error)")
    }

    public func sdkInitialized() {
        VRTLogInfo()
        completionHandler?(.initializedSuccess, nil)
    }
}

// MARK: - MASignalProvider
extension VRTMediationAdapter: MASignalProvider
{
    func collectSignal(
        with parameters: MASignalCollectionParameters,
        andNotify delegate: MASignalCollectionDelegate
    ) {
        VRTLogInfo("parameters: \(parameters.longDescription)")
        log(signalEvent: .collecting)
    }
}



// MARK: - Banners



// MARK: MAAdViewAdapter
extension VRTMediationAdapter: MAAdViewAdapter {
    public func loadAdViewAd(
        for parameters: MAAdapterResponseParameters,
        adFormat: MAAdFormat,
        andNotify delegate: MAAdViewAdapterDelegate
    ) {
        VRTLogInfo("parameters: \(parameters.longDescription)")
        maAdViewAdapterDelegate = delegate
        
        guard let zoneId = Int(parameters.thirdPartyAdPlacementIdentifier),
        zoneId > 0 else {
            let message = "Could not extract thirdPartyAdPlacementIdentifier (zoneId) from parameters: \(parameters)"
            
            let error = MAAdapterError(
                code: MAAdapterError.errorCodeInvalidConfiguration,
                errorString: message
            )
            maAdViewAdapterDelegate?.didFailToLoadAdViewAdWithError(error)
            return
        }
        
        vrtBanner = VRTBanner(frame: CGRect(x: 0, y: 0, width: adFormat.size.width, height: adFormat.size.height))
        vrtBanner?.adDelegate = self
        vrtBanner?.loadAd(zoneId)
    }
}


// MARK: VRTBannerDelegate
extension VRTMediationAdapter: VRTBannerDelegate {

    public func vrtBannerAdClicked(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        maAdViewAdapterDelegate?.didClickAdViewAd()
    }
    
    public func vrtBannerAdFailedToLoad(_ vrtBanner: VRTBanner, error: Error) {
        VRTLogInfo()
        maAdViewAdapterDelegate?.didFailToLoadAdViewAdWithError(MAAdapterError(nsError: error))
    }
    
    public func vrtBannerAdLoaded(_ vrtBanner: VRTBanner, withAdSize adSize: CGSize) {
        VRTLogInfo()
        maAdViewAdapterDelegate?.didLoadAd(forAdView: vrtBanner)
        maAdViewAdapterDelegate?.didDisplayAdViewAd()
    }
    
    public func vrtBannerAdWillLeaveApplication(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        // No Analog
    }
    
    public func vrtBannerDidDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
        maAdViewAdapterDelegate?.didCollapseAdViewAd()
    }
    
    public func vrtBannerDidPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
        maAdViewAdapterDelegate?.didExpandAdViewAd()
    }
    
    @objc public func vrtBannerVideoCompleted(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        // No Analog
    }
    
    public func vrtBannerVideoStarted(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        // No Analog
    }
    
    public func vrtBannerWillDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
        // No Analog
    }
    
    public func vrtBannerWillPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
        // No Analog
    }
    
    public func vrtViewControllerForModalPresentation() -> UIViewController? {
        return ALUtils.topViewControllerFromKeyWindow()
    }
}

// MARK: - Interstitials




// MARK: MAInterstitialAdapter
extension VRTMediationAdapter: MAInterstitialAdapter {
    public func loadInterstitialAd(
        for parameters: MAAdapterResponseParameters,
        andNotify delegate: MAInterstitialAdapterDelegate
    ) {
        VRTLogInfo("parameters: \(parameters.longDescription)")
        
        maInterstitialAdapterDelegate = delegate
        
        guard let zoneId = Int(parameters.thirdPartyAdPlacementIdentifier),
        zoneId > 0 else {
            let message = "Could not extract thirdPartyAdPlacementIdentifier (zoneId) from parameters: \(parameters)"
            let error = MAAdapterError(code: MAAdapterError.errorCodeInvalidConfiguration, errorString: message)
            maAdViewAdapterDelegate?.didFailToLoadAdViewAdWithError(error)
            return
        }
        
        vrtInterstitial = VRTInterstitial()
        vrtInterstitial?.adDelegate = self
        vrtInterstitial?.loadAd(zoneId)
    }
    
    public func showInterstitialAd(
        for parameters: MAAdapterResponseParameters,
        andNotify delegate: MAInterstitialAdapterDelegate
    ) {
        VRTLogInfo("parameters: \(parameters.longDescription)")
        vrtInterstitial?.showAd()
    }
}

// MARK: VRTInterstitialDelegate
extension VRTMediationAdapter: VRTInterstitialDelegate {
    public func vrtInterstitialAdClicked(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        maInterstitialAdapterDelegate?.didClickInterstitialAd()
    }

    public func vrtInterstitialAdDidDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        maInterstitialAdapterDelegate?.didHideInterstitialAd()
    }

    public func vrtInterstitialAdDidShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        maInterstitialAdapterDelegate?.didDisplayInterstitialAd()
    }

    public func vrtInterstitialAdFailed(toLoad vrtInterstitial: VRTInterstitial, error: Error) {
        VRTLogInfo()
        maInterstitialAdapterDelegate?.didFailToLoadInterstitialAdWithError(MAAdapterError(nsError: error))
    }

    public func vrtInterstitialAdFailed(toShow vrtInterstitial: VRTInterstitial, error: Error) {
        VRTLogInfo()
        maInterstitialAdapterDelegate?.didFailToDisplayInterstitialAdWithError(MAAdapterError(nsError: error))
    }

    public func vrtInterstitialAdLoaded(_ vrtInterstitial: VRTInterstitial) {
        maInterstitialAdapterDelegate?.didLoadInterstitialAd()
    }

    public func vrtInterstitialAdWillDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No Analog
    }

    public func vrtInterstitialAdWillLeaveApplication(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No Analog
    }

    public func vrtInterstitialAdWillShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No Analog
    }

    public func vrtInterstitialVideoCompleted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No Analog
    }

    public func vrtInterstitialVideoStarted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No Analog
    }
}
