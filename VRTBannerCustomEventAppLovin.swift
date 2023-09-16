
//Header
import AppLovinSDK
import VrtcalSDK

//AppLovin Banner Adapter, Vrtcal as Primary

class VRTBannerCustomEventAppLovin: VRTAbstractBannerCustomEvent {
    private var maAdView: MAAdView?
    private var maaAdViewAdDelegatePassthrough = MAAdViewAdDelegatePassthrough()

    override func loadBannerAd() {
        VRTLogInfo()
        
        guard let adUnitIdentifier = customEventConfig.thirdPartyAdUnitId(
            customEventLoadDelegate: customEventLoadDelegate
        ) else {
            return
        }
                
        guard let width = customEventConfig.thirdPartyWidth(
            customEventLoadDelegate: customEventLoadDelegate
        ) else {
            return
        }
        
        guard let height = customEventConfig.thirdPartyHeight(
            customEventLoadDelegate: customEventLoadDelegate
        ) else {
            return
        }
        
        maAdView = MAAdView(adUnitIdentifier: adUnitIdentifier)
        maAdView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        maaAdViewAdDelegatePassthrough.customEventLoadDelegate = customEventLoadDelegate
        maaAdViewAdDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        
        maAdView?.delegate = maaAdViewAdDelegatePassthrough
        maAdView?.loadAd()
    }

    override func getView() -> UIView? {
        VRTLogInfo()
        return maAdView
    }
}
