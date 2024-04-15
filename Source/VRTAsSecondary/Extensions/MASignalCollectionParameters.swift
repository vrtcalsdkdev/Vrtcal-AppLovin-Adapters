//
//  MASignalCollectionParameters.swift
//  Vrtcal-AppLovin-Adapters
//
//  Created by Scott McCoy on 4/15/24.
//

import AppLovinSDK

extension MASignalCollectionParameters {
    var longDescription: String {
        """
        MASignalCollectionParameters [
            adFormat: \(self.adFormat),
        \(self.longDescriptionMaAdapterParameters)
        ]
        """
    }
}

