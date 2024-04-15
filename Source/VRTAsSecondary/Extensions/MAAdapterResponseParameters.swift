//
//  MAAdapterResponseParameters.swift
//  Vrtcal-AppLovin-Adapters
//
//  Created by Scott McCoy on 4/15/24.
//

import Foundation

import AppLovinSDK

extension MAAdapterResponseParameters {
    var longDescription: String {
        """
        MAAdapterResponseParameters [
            thirdPartyAdPlacementIdentifier: \(thirdPartyAdPlacementIdentifier),
            bidResponse: \(bidResponse)
            isBidding: \(isBidding)
            bidExpirationMillis: \(bidExpirationMillis)
        \(self.longDescriptionMaAdapterParameters)
        ]
        """
    }
}
