//
//  M.swift
//  Vrtcal-AppLovin-Adapters
//
//  Created by Scott McCoy on 4/15/24.
//

import AppLovinSDK

extension MAAdapterParameters {
    var longDescriptionMaAdapterParameters: String {
        """
            serverParameters: \(self.serverParameters),
            adUnitIdentifier: \(self.adUnitIdentifier),
            customParameters: \(self.customParameters),
            isTesting: \(self.isTesting),
            localExtraParameters: \(self.localExtraParameters),
            ageRestrictedUser: \(String(describing: self.ageRestrictedUser)),
            consentString: \(String(describing: self.consentString)),
            doNotSell: \(String(describing: self.doNotSell)),
            presentingViewController: \(String(describing: self.presentingViewController)),
            userConsent: \(String(describing: self.userConsent))
        """
    }
}
