//
//  ProtocolSection.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation
import ObjectiveC

public struct ProtocolSection: DumpStringRepresentation, DumpSection {
    public var classInfo: ClassInfo
    public var protocolList: [ProtocolInfo] {
        var arr: [ProtocolInfo] = []
        var count: UInt32 = 0
        guard let rawList = class_copyProtocolList(classInfo.classImp, &count) else {
            return arr
        }
        for index in 0...count-1 {
            arr.append(ProtocolInfo(withProtocol: rawList[Int(index)]))
        }
        return arr
    }

    public var stringRepresenation: String {
        var returnString: String = ""
        if protocolList.count > 0 {
            returnString += "<"
            for protoIDX in 0..<protocolList.count {
                let proto: ProtocolInfo = protocolList[protoIDX]
                returnString += proto.name
                if protocolList.count > 1 && protoIDX != protocolList.count - 1 {
                    returnString += ", "
                }
            }
            returnString += "> "
        }
        return returnString
    }

    public init(withInfo info: ClassInfo) {
        self.classInfo = info

    }
}
