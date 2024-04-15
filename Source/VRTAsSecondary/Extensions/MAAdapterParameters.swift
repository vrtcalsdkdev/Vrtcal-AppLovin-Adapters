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

/*
@property (nonatomic, assign, readonly, getter=isTesting) BOOL testing;
@property (nonatomic, copy, readonly) NSString *adUnitIdentifier;
@property (nonatomic, copy, readonly, nullable) NSString *consentString;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *customParameters;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *localExtraParameters;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *serverParameters;
@property (nonatomic, strong, readonly, nullable, getter=hasUserConsent) NSNumber *userConsent;
@property (nonatomic, strong, readonly, nullable, getter=isAgeRestrictedUser) NSNumber *ageRestrictedUser;
@property (nonatomic, strong, readonly, nullable, getter=isDoNotSell) NSNumber *doNotSell;
@property (nonatomic, weak, readonly, nullable) UIViewController *presentingViewController;
*/
