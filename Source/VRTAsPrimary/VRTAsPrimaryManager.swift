//
//  VRTAsPrimaryManager.swift
//  Vrtcal-AppLovin-Adapters
//
//  Created by Scott McCoy on 8/19/24.
//

import AppLovinSDK
import VrtcalSDK

class VRTAsPrimaryManager {
    static let singleton = VRTAsPrimaryManager()
    private var shouldInit = true
    
    func initializeThirdParty(
        customEventConfig: VRTCustomEventConfig,
        completionHandler: @escaping (Result<Void,VRTError>) -> ()
    ) {

        // Bail if already initialized
        guard shouldInit else {
            completionHandler(.success())
            return
        }
        
        // Require the sdkKey and adUnitIdentifiers array
        guard let sdkKey = customEventConfig.thirdPartyCustomEventDataValue(
            thirdPartyCustomEventKey: .appId
        ).getSuccess(failureHandler: { vrtError in
            completionHandler(.failure(vrtError))
        }) else {
            return
        }

        guard let adUnitIdentifiers = customEventConfig.thirdPartyCustomEventDataValue(
            thirdPartyCustomEventKey: .custom("adUnitIdentifiers")
        ).getSuccess(failureHandler: { vrtError in
            completionHandler(.failure(vrtError))
        }) else {
            return
        }

        // Create the initialization configuration
        let alSdkInitializationConfiguration = ALSdkInitializationConfiguration(
            sdkKey: sdkKey
        ) { (alSdkInitializationConfigurationBuilder: ALSdkInitializationConfigurationBuilder) in
            alSdkInitializationConfigurationBuilder.mediationProvider = ALMediationProviderMAX
            alSdkInitializationConfigurationBuilder.adUnitIdentifiers = adUnitIdentifiers.components(separatedBy: ",")
        }
        
        // Enable verbose logging
        ALSdk.shared().settings.isVerboseLoggingEnabled = true
        
        ALSdk.shared().initialize(with: alSdkInitializationConfiguration) { (configuration: ALSdkConfiguration) in
            VRTLogInfo("AppLovin Initialized. configuration: \(configuration)")
            self.shouldInit = false
            completionHandler(.success())
        }
    }
}
