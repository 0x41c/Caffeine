//
//  PropertySection.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation

public struct PropertySection: DumpStringRepresentation, DumpSection {
    public var classInfo: ClassInfo

    public var propertyList: [PropertyInfo] {
        var arr: [PropertyInfo] = []
        var count: UInt32 = 0
        guard let rawList = class_copyPropertyList(classInfo.classImp, &count) else {
            return arr
        }
        for index in 0...Int(count)-1 {
            arr.append(PropertyInfo(raw: rawList[index]))
        }
        return arr
    }

    public var stringRepresenation: String {
        var ret = ""
        guard propertyList.count > 0 else {
            return ret
        }
        ret += "\n"
        var presentedProperties: [String] = []
        for property in propertyList {
            if !presentedProperties.contains(property.name) {
                ret += "@property "
                var newAttrubutes = property.attributes
                newAttrubutes.removeFirst()
                if newAttrubutes.count > 1 {
                    ret += "("
                    for attributeIndex in 1..<newAttrubutes.count {
                        let convertedProperty: String = property.decodedAttribute(at: attributeIndex)
                        ret += "\(convertedProperty), "
                    }
                    ret = String(ret.dropLast(2))
                    ret += ") "
                }
                ret += property.decodedReturnAttribute()
                ret += property.name + ";\n"
                presentedProperties.append(property.name)
            }
        }
        return ret
    }

    public init(withInfo info: ClassInfo) {
        self.classInfo = info

    }
}
