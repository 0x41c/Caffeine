//
//  IvarSection.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation

public struct IvarSection: DumpStringRepresentation, DumpSection {
    public var classInfo: ClassInfo

    public var ivarList: [IvarInfo] {
        var arr: [IvarInfo] = []
        var count: UInt32 = 0
        guard let rawList = class_copyIvarList(classInfo.classImp, &count) else {
            return arr
        }
        for index in 0...Int(count)-1 {
            arr.append(IvarInfo(raw: rawList[index]))
        }
        return arr
    }

    public var stringRepresenation: String {
        var ret: String = ""
        if ivarList.count > 0 {
            ret += "{\n\n"
            for ivarInfo in ivarList {
                ret += "    \(ivarInfo.returnValue)"
                if !ivarInfo.returnValue.contains(" ") {
                    ret += " "
                }
                ret += "\(ivarInfo.name);"
                if DumpOptions.sharedOptions.includeIvarOffsets {
                    ret += " // offset: \(ivarInfo.offset)"
                }
                ret += "\n"
            }
            ret += "\n}\n"
        }
        return ret
    }
    public init(withInfo info: ClassInfo) {
        self.classInfo = info

    }
}
