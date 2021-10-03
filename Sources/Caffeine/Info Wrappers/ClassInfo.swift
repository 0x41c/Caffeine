//
//  ClassInfo.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation
import ObjectiveC

// Class Info
public struct ClassInfo {
    public var classImp: AnyClass
    public var className: String {
        return String(cString: class_getName(classImp))
    }
    public var superClass: AnyClass? {
        return class_getSuperclass(classImp)
    }
    
    public init(withClass: AnyClass) {
        classImp = withClass
    }
}
