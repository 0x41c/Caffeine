//
//  Options+Protocols.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation

var sharedDumpOptions: DumpOptions?
public struct DumpOptions {
    public var dumpProtocols: Bool
    
    public var dumpIvars: Bool
    
    public var dumpProperties: Bool
    
    public var dumpMethods: Bool
    
    public var includeProtocolDefinitions: Bool
    
    public var sortProtocolsAlphabetically: Bool
    
    public var sortIvarsAlphabetically: Bool
    
    public var sortPropertiesAlphabetically: Bool
    
    public var sortMethodsAlphabetically: Bool
    
    public var includeIvarOffsets: Bool
    
    public static var sharedOptions: DumpOptions {
        if sharedDumpOptions == nil {
            sharedDumpOptions = DumpOptions(
                dumpProtocols: true,
                dumpIvars: true,
                dumpProperties: true,
                dumpMethods: true,
                includeProtocolDefinitions: true,
                sortProtocolsAlphabetically: true,
                sortIvarsAlphabetically: true,
                sortPropertiesAlphabetically: true,
                sortMethodsAlphabetically: true,
                includeIvarOffsets: true
            )
        }
        return sharedDumpOptions!
    }
}

public protocol DumpSection {
    var classInfo: ClassInfo { get }
    init(withInfo info: ClassInfo)
}

// MARK: Runtime Info Things
public protocol DumpStringRepresentation {
    var stringRepresenation: String { get }
}
