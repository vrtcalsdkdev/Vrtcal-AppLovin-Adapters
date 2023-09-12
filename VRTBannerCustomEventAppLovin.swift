//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
//Header
import AppLovinSDK
import VrtcalSDK

//AppLovin Banner Adapter, Vrtcal as Primary

class VRTBannerCustomEventAppLovin: VRTAbstractBannerCustomEvent, MAAdViewAdDelegate {
    private var maAdView: MAAdView?

    func loadBannerAd() {
        VRTLogWhereAmI()
        let maAdUnitId = customEventConfig.thirdPartyCustomEventData["adUnitId"] as? String
        let strWidth = customEventConfig.thirdPartyCustomEventData["width"] as? String
        let strHeight = customEventConfig.thirdPartyCustomEventData["height"] as? String

        let width = CGFloat(strWidth?.responds(to: Selector("floatValue")) ?? false ? Float(strWidth ?? "") ?? 0.0 : 320)
        let height = CGFloat(strWidth?.responds(to: Selector("floatValue")) ?? false ? Float(strHeight ?? "") ?? 0.0 : 50)

        maAdView = MAAdView(adUnitIdentifier: maAdUnitId)
        maAdView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        maAdView?.delegate = self
        maAdView?.loadAd()
    }

    func getView() -> UIView? {
        VRTLogWhereAmI()
        return maAdView
    }

    // MARK: - MAAdViewAdDelegate

    func didClick(_ ad: MAAd) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventClicked()
    }

    func didDisplay(_ ad: MAAd) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventShown()
    }

    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        // No Analog
        VRTLogWhereAmI()
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        VRTLogWhereAmI()
        let vrtError = VRTError(code: VRTErrorCodeCustomEvent, message: error.message)
        customEventLoadDelegate.customEventFailedToLoadWithError(vrtError)
    }

    func didHide(_ ad: MAAd) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventDidDismissModal(VRTModalTypeUnknown)
    }

    func didLoad(_ ad: MAAd) {
        VRTLogWhereAmI()
        customEventLoadDelegate.customEventLoaded()
    }

    func didCollapseAd(_ ad: MAAd) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventDidDismissModal(VRTModalTypeUnknown)
    }

    func didExpand(_ ad: MAAd) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventDidPresentModal(VRTModalTypeUnknown)
    }
}

//Dependencies

//AppLovin Banner Adapter, Vrtcal as Primary