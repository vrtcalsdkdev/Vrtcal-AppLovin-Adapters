//
//  MAAdDelegatePassthrough.swift
//  Vrtcal-AppLovin-Adapters
//
//  Created by Scott McCoy on 9/15/23.
//

import AppLovinSDK
import VrtcalSDK

class MAAdDelegatePassthrough: NSObject, MAAdDelegate {
    
    public weak var customEventLoadDelegate: VRTCustomEventLoadDelegate?
    public weak var customEventShowDelegate: VRTCustomEventShowDelegate?

    func didLoad(_ ad: MAAd) {
        VRTLogInfo()
        customEventLoadDelegate?.customEventLoaded()
    }

    func didClick(_ ad: MAAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }

    func didDisplay(_ ad: MAAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidPresentModal(.interstitial)
        customEventShowDelegate?.customEventShown()
    }

    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        // No Analog
        VRTLogInfo()
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        VRTLogInfo()
        let vrtError = VRTError(
            vrtErrorCode: .customEvent,
            message: error.message
        )
        customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
    }

    func didHide(_ ad: MAAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidDismissModal(.unknown)
    }
}
