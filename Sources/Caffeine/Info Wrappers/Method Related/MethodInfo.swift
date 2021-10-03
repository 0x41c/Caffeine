//
//  MethodInfo.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation
import ObjectiveC

public struct MethodInfo: DumpStringRepresentation {
    public var classInfo: ClassInfo
    public var isClassMethod: Bool
    public var stringRepresenation: String {
        return propagateMethod(
            withName: name,
            attributes: typeEncoding,
            returnType: returnType,
            isClassMethod: isClassMethod
        )
    }
    public var raw: Method
    public var name: String {
        return String(cString: sel_getName(method_getName(raw)))
    }

    // Gonna bite the bullet here
    public var returnType: String {
        let rawReturnType = method_copyReturnType(raw)
        let returnTypes = TypeDecoder.translate(types: String(cString: rawReturnType))
        guard returnTypes.first != nil else {
            return TypeDecoder.findReplacer("?")
        }

        return returnTypes.first!
    }

    public var numberOfArguments: UInt32 {
        return method_getNumberOfArguments(raw)
    }

    public func argumentTypes() -> [String] {
        var returnVal: [String]?
        _ = TypeDecoder.translate(types: typeEncoding) { array in
            returnVal = array
        }
        while returnVal == nil {}
        return returnVal!
    }

    public var typeEncoding: String {
        return String(cString: method_getTypeEncoding(raw)!)
             .components(separatedBy: "@0:").last!
    }

    public init(withMethod method: Method, isClassMethod: Bool, classInfo: ClassInfo) {
        raw = method
        self.isClassMethod = isClassMethod
        self.classInfo = classInfo
        // Init Argument Types
        _ = argumentTypes
    }
}
