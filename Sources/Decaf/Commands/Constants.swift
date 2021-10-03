//
//  Constants.swift
//  
//
//  Created by Cero on 2021-10-01.
//

import Foundation


let macOSMessage = coolify("""
Looks inside of /System/Library/Frameworks for all available framworks to load into runtime.
""")

let iOSMessage = coolify("""
Using the default base path, it looks inside of iOS path for all available frameworks to load into runtime.
~break
    'iPhoneOS.platform/Library/Developer/CoreSimulator/runtimes/iOS.simruntime/Resources/RuntimeRoot/System/Library/Frameworks'
""")

let tvOSMessage = coolify("""
Using the default base path, it looks inside of tvOS path for all available frameworks to load into runtime.
~break
    'AppleTVOS.platform/Library/Developer/CoreSimulator/runtimes/tvOS.simruntime/Resources/RuntimeRoot/System/Library/Frameworks'
""")

let watchOSMessage = coolify("""
Using the default base path, it looks inside of watchOS path for all available frameworks to load into runtime.
~break
    'watchOS.platform/Library/Developer/CoreSimulator/runtimes/watchOS.simruntime/Resources/RuntimeRoot/System/Library/Frameworks'
""")

let privateFrameworkMessage = coolify("""
Instead of looking in the 'Frameworks' directory, it will look in the 'PrivateFramworks' directory.
""")


let macDir = "/System/Library/Frameworks"

// Never gonna use these anywhere else anyways
fileprivate let simulatorFrameworksDir = ".simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks"
fileprivate let simulatorRuntimeDir = ".platform/Library/Developer/CoreSimulator/Profiles/Runtimes/"
fileprivate let xcodePrefix = "/Applications/Xcode.app/Contents/Developer/Platforms/"

func simDir(_ name: String, _ runtimeName: String = "") -> String {
    return "\(xcodePrefix)\(name)\(simulatorRuntimeDir)\(runtimeName != "" ? runtimeName : name)\(simulatorFrameworksDir)"
}
