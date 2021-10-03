//
//  Framework.swift
//  
//
//  Created by Cero on 2021-09-30.
//

import Foundation
import ArgumentParser



struct Framework {
    
    private var dict: [String: Any] = [:]
    
    var bundle: Bundle
    
    var fullPath: String
    
    var name: String {
        return String(describing: dict["CFBundleName"] ?? "No Name")
    }
    
    var version: String {
        return String(describing: dict["CFBundleShortVersionString"] ?? "No Version")
    }
    
    var minimumiOSVersion: String {
        return String(describing: dict["MinimumOSVersion"] ?? "No Minimum Version")
    }
    
    var bundleID: String {
        return String(describing: dict["CFBundleIdentifier"] ?? "No bundle ID")
    }
    
    @available(macOS 10.13, *)
    init(withPath path: String) throws {
        self.fullPath = path
        let optionalBundle: Bundle? = Bundle(path: path)
        if optionalBundle != nil {
            self.bundle = optionalBundle!
            if self.bundle.infoDictionary != nil {
                self.dict = self.bundle.infoDictionary!
            }
        } else {
            throw ValidationError("Invalid framework at \(path)\n")
        }
    }
}
