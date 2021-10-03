//
//  ProtocolInfo.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation
import ObjectiveC
// Protocol Info
public struct ProtocolInfo {
    public var raw: Protocol
    public var name: String {
        return String(cString: protocol_getName(raw))
    }

    public init(withProtocol proto: Protocol) {
        raw = proto
    }
}
