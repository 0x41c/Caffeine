//
//  MethodSection.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation
import ObjectiveC

public struct MethodSection: DumpStringRepresentation, DumpSection {
    public var classInfo: ClassInfo
    public func getMethodInfos(forClass: AnyClass) -> [MethodInfo] {
        var methodCount: UInt32 = 0
        let rawMethods = class_copyMethodList(forClass, &methodCount)!
        guard methodCount > 0 else {
            return []
        }
        var finalArray: [MethodInfo] = []
        for currentIdx in 0...Int(methodCount)-1 {
            finalArray.append(
                MethodInfo(
                    withMethod: rawMethods[currentIdx],
                    isClassMethod:
                        class_isMetaClass(forClass),
                    classInfo: classInfo
                )
            )
        }
        return finalArray
    }
    public var instanceMethods: [MethodInfo] {
        return getMethodInfos(forClass: classInfo.classImp)
    }

    public var classMethods: [MethodInfo] {
        guard let metaClass: AnyClass = objc_getMetaClass(classInfo.className) as? AnyClass else {
            return []
        }
        return getMethodInfos(forClass: metaClass)
    }
    public var stringRepresenation: String {
        var final = ""
        if classMethods.count > 0 {
            for classMethodIdx in 0...classMethods.count-1 {
                final.append(classMethods[classMethodIdx].stringRepresenation + "\n")
            }
        }
        if instanceMethods.count > 0 {
            for instanceMethodIdx in 0...instanceMethods.count-1 {
                final.append(instanceMethods[instanceMethodIdx].stringRepresenation + "\n")
            }
        }
        return final
    }

    public init(withInfo info: ClassInfo) {
        self.classInfo = info
    }
}
