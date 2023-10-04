
import AppLovinSDK
import VrtcalSDK

//AppLovin Interstitial Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventAppLovin: VRTAbstractInterstitialCustomEvent {
    private var maIntersatitialAd: MAInterstitialAd?
    private var maadDelegatePassthrough = MAAdDelegatePassthrough()
    
    override func loadInterstitialAd() {
        VRTLogInfo()
        
        
        let dict = customEventConfig.thirdPartyCustomEventData
        guard let maAdUnitId = dict["adUnitId"] as? String else {
            customEventLoadDelegate?.customEventFailedToLoad(
                vrtError: VRTError(
                    vrtErrorCode: .customEvent,
                    message: "Unable to extract adUnitId: \(dict)"
                )
            )
            return
        }
        
        maIntersatitialAd = MAInterstitialAd(adUnitIdentifier: maAdUnitId)
        
        maadDelegatePassthrough.customEventLoadDelegate = customEventLoadDelegate
        
        maIntersatitialAd?.delegate = maadDelegatePassthrough
        maIntersatitialAd?.load()
    }

    override func showInterstitialAd() {
        VRTLogInfo()
        maadDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        maIntersatitialAd?.show()
    }
}
