//
//  PropertyInfo.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation

// Property Info
public struct PropertyInfo {
    public var raw: objc_property_t

    public func decodedReturnAttribute() -> String {
        var ret: String = ""
        guard attributes.count > 0 else {
            return ret
        }
        var attribute: String = String(attributes[0])
        if attribute.hasPrefix("T@\"") {
            attribute.removeFirst(3)
            attribute.removeLast()
            ret = attribute + " *"
        } else {
            attribute.removeFirst()
            ret = TypeDecoder.translate(types: attribute)[0]
        }
        if !ret.contains(" ") {
            ret += " "
        }
        return ret
    }

    public func decodedAttribute(at index: Int) -> String {
        var ret: String = ""
        guard index < attributes.count && index > -1 else {
            return ret
        }
        var attribute: String = String(attributes[index])
        if attribute.hasPrefix("T@\"") {
            attribute.removeFirst(3)
            attribute.removeLast()
            ret = attribute
        } else {
            ret = TypeDecoder.findPropertyAttribute(attribute)
        }
        return ret
    }

    public var attributes: [Substring] {
        return String(cString: property_getAttributes(raw)!).split(separator: ",")
    }

    public var name: String {
        return String(cString: property_getName(raw))
    }
}
