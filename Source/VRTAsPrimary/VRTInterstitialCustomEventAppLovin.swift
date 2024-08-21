
import AppLovinSDK
import VrtcalSDK

//AppLovin Interstitial Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventAppLovin: VRTAbstractInterstitialCustomEvent {
    private var maIntersatitialAd: MAInterstitialAd?
    private var maadDelegatePassthrough = MAAdDelegatePassthrough()
    
    override func loadInterstitialAd() {
        VRTLogInfo()
        
        
        VRTAsPrimaryManager.singleton.initializeThirdParty(
            customEventConfig: customEventConfig
        ) { result in
            
            // Get the adUnitIdentifier or fail
            guard let maAdUnitId = self.customEventConfig.thirdPartyCustomEventDataValueOrFailToLoad(
                thirdPartyCustomEventKey: .adUnitId,
                customEventLoadDelegate: self.customEventLoadDelegate
            ) else {
                return
            }
            
            self.maIntersatitialAd = MAInterstitialAd(adUnitIdentifier: maAdUnitId)
            
            self.maadDelegatePassthrough.customEventLoadDelegate = self.customEventLoadDelegate
            
            self.maIntersatitialAd?.delegate = self.maadDelegatePassthrough
            self.maIntersatitialAd?.load()
        }
    }

    override func showInterstitialAd() {
        VRTLogInfo()
        maadDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        maIntersatitialAd?.show()
    }
}
