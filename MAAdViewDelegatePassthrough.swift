//
//  MAAdViewDelegatePassthrough.swift
//  Vrtcal-AppLovin-Adapters
//
//  Created by Scott McCoy on 9/15/23.
//

import AppLovinSDK
import VrtcalSDK

class MAAdViewAdDelegatePassthrough: NSObject, MAAdViewAdDelegate {
    
    public weak var customEventLoadDelegate: VRTCustomEventLoadDelegate?
    public weak var customEventShowDelegate: VRTCustomEventShowDelegate?
    
    func didClick(_ ad: MAAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }

    func didDisplay(_ ad: MAAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventShown()
    }

    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        // No Analog
        VRTLogInfo()
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        VRTLogInfo()
        let vrtError = VRTError(vrtErrorCode: .customEvent, message: error.message)
        customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
    }

    func didHide(_ ad: MAAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidDismissModal(.unknown)
    }

    func didLoad(_ ad: MAAd) {
        VRTLogInfo()
        customEventLoadDelegate?.customEventLoaded()
    }

    func didCollapse(_ ad: MAAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidDismissModal(.unknown)
    }

    func didExpand(_ ad: MAAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidPresentModal(.unknown)
    }
}
