//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
import AppLovinSDK
import VrtcalSDK

//AppLovin Interstitial Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventAppLovin: VRTAbstractInterstitialCustomEvent, MAAdDelegate {
    private var maIntersatitialAd: MAInterstitialAd?

    func loadInterstitialAd() {
        VRTLogWhereAmI()
        let maAdUnitId = customEventConfig.thirdPartyCustomEventData["adUnitId"] as? String
        maIntersatitialAd = MAInterstitialAd(adUnitIdentifier: maAdUnitId)
        maIntersatitialAd?.delegate = self
        maIntersatitialAd?.load()
    }

    func showInterstitialAd() {
        VRTLogWhereAmI()
        maIntersatitialAd?.show()
    }

    // MARK: - MAAdDelegate

    func didLoad(_ ad: MAAd?) {
        VRTLogWhereAmI()
        customEventLoadDelegate.customEventLoaded()
    }

    func didClick(_ ad: MAAd) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventClicked()
    }

    func didDisplay(_ ad: MAAd) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventDidPresentModal(VRTModalTypeInterstitial)
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
}

//AppLovin Interstitial Adapter, Vrtcal as Primary