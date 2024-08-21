
// Header
import AppLovinSDK
import VrtcalSDK

// AppLovin Banner Adapter, Vrtcal as Primary

class VRTBannerCustomEventAppLovin: VRTAbstractBannerCustomEvent {
    private var maAdView: MAAdView?
    private var maaAdViewAdDelegatePassthrough = MAAdViewAdDelegatePassthrough()

    override func loadBannerAd() {
        VRTLogInfo()
        
        VRTAsPrimaryManager.singleton.initializeThirdParty(
            customEventConfig: customEventConfig
        ) { result in
            
            // Bail if initializing AppLovin failed
            guard result.isSuccessful else {
                self.customEventLoadDelegate?.customEventFailedToLoad(vrtError: result.error!)
                return
            }
            
            // Get the adUnitIdentifier or fail
            guard let adUnitIdentifier = self.customEventConfig.thirdPartyCustomEventDataValueOrFailToLoad(
                thirdPartyCustomEventKey: .adUnitId,
                customEventLoadDelegate: self.customEventLoadDelegate
            ) else {
                return
            }
            
            // Get the banner size and make the banner
            let cgSize = self.customEventConfig.thirdPartyBannerSize
            self.maAdView = MAAdView(adUnitIdentifier: adUnitIdentifier)
            self.maAdView?.frame = CGRect(x: 0, y: 0, width: cgSize.width, height: cgSize.height)
            
            // Set the banner's delegate
            self.maaAdViewAdDelegatePassthrough.customEventLoadDelegate = self.customEventLoadDelegate
            self.maAdView?.delegate = self.maaAdViewAdDelegatePassthrough
            
            // Load the banner
            self.maAdView?.loadAd()
        }
    }

    override func getView() -> UIView? {
        VRTLogInfo()
        maaAdViewAdDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        return maAdView
    }
}
