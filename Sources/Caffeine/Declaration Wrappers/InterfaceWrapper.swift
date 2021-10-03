//
//  InterfaceWrapper.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation

public struct InterfaceWrapper: DumpStringRepresentation, DumpSection {
    public var classInfo: ClassInfo
    public var protocolSection: ProtocolSection
    public var ivarSection: IvarSection
    public var propertySection: PropertySection
    public var methodSection: MethodSection

    // On a scale of one to ten how messy does this look
    public var stringRepresenation: String {
        var sectionArray = [
            "@interface \(classInfo.className)",
            "\(classInfo.superClass != nil ? String(cString: class_getName(classInfo.superClass!)) + " " : "")",
            DumpOptions.sharedOptions.dumpProtocols ? protocolSection.stringRepresenation : "",
            DumpOptions.sharedOptions.dumpIvars ? ivarSection.stringRepresenation + "\n" : "",
            DumpOptions.sharedOptions.dumpProperties ? propertySection.stringRepresenation + "\n" : "",
            DumpOptions.sharedOptions.dumpMethods ?  methodSection.stringRepresenation + "\n" : "",
            "@end"
        ]

        if sectionArray[2] != "" || sectionArray[3] != "" {
            sectionArray.insert(" : ", at: 1)
        }

        return sectionArray.joined()
    }

    public init(withInfo info: ClassInfo) {
        self.classInfo = info
        self.protocolSection = ProtocolSection(withInfo: info)
        self.ivarSection = IvarSection(withInfo: info)
        self.propertySection = PropertySection(withInfo: info)
        self.methodSection = MethodSection(withInfo: info)
    }
}
