//
//  IvarInfo.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation
import ObjectiveC

// Ivar Info
public struct IvarInfo {
    public var raw: Ivar
    public var returnValue: String {
        let stringValue = String(encoding[0])
        if stringValue.contains("@\"") && !stringValue.contains("{") {
            return stringValue.replacingOccurrences(of: "@", with: "").replacingOccurrences(of: "\"", with: "") +  " *"
        }
        return TypeDecoder.translate(types: stringValue)[0]
    }

    public var offset: Int {
        return ivar_getOffset(raw)
    }

    public var encoding: [Substring] {
        return String(cString: ivar_getTypeEncoding(raw)!).split(separator: ",")
    }

    public var name: String {
        return String(cString: ivar_getName(raw)!)
    }
}
