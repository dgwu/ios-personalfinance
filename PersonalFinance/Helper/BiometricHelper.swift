//
//  BiometricHelper.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 02/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touch
    case face
}


class BiometricHelper {
    static func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
}
