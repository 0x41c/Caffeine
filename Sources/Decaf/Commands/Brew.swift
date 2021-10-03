//
//  Brew.swift
//  
//
//  Created by Cero on 2021-10-01.
//

import Foundation
import ArgumentParser
import ObjectiveC
import Caffeine
import CoreFoundation

@available(macOS 10.13, *)
struct Brew : ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "brew",
        abstract: "Dump a frameworks classes.",
        discussion: "\(banner)\n\n" + coolify("""
        Allows you to view either specific information about a framework and it's classes,
        Or you can choose to completely dump a framework. There are multiple options available to determine
        the format of the dump.
        
        Work is being made to have this command actually do parsing of the binary, but this only loads a framework into
        runtime, and gets runtime information about it. You might be able to expect this in the future, but for now it's
        all about having wishful thinking!
        """),
        version: "0.0.1",
        shouldDisplay: YES
    )
    
    @Flag(
        name: [.customShort("m", allowingJoined: NO), .long],
        help: ArgumentHelp(
            "Look for MacOS Frameworks",
            discussion: macOSMessage
        )
    ) var macos: Bool = NO
    
    @Flag(
        name: [.customShort("i", allowingJoined: NO), .long],
        help: ArgumentHelp(
            "Look for iOS Frameworks",
            discussion: iOSMessage
        )
    ) var ios: Bool = NO
    
    @Flag(
        name: [.customShort("t", allowingJoined: NO), .long],
        help: ArgumentHelp(
            "Look for tvOS Frameworks",
            discussion: tvOSMessage
        )
    ) var tvos: Bool = NO
    
    @Flag(
        name: [.customShort("w", allowingJoined: NO), .long],
        help: ArgumentHelp(
            "Look for watchOS Frameworks",
            discussion: watchOSMessage
        )
    ) var watchos: Bool = NO
    
    @Flag(
        name: [.customShort("p", allowingJoined: NO), .customLong("private", withSingleDash: NO)],
        help: ArgumentHelp(
            "Use Private FrameWorks",
            discussion: coolify("""
            Instead of looking in the 'Frameworks' directory, it will look in the 'PrivateFramworks' directory.
            """)
        )
    ) var usePrivateFrameworks: Bool = NO
    
    @Flag(
        help: ArgumentHelp(
            "",
            discussion: coolify("""
            Determines whether to dump framwork information or the framework itself.
            Leaving this option unchecked will dump the framework
            """)
        )
    ) var info: Bool = NO
    
    @Argument(
        help: ArgumentHelp(
            "The framework to dump"
        )
    ) var frameworkName: String = ""
    
    
    // TODO adapt this tool to build for the iOS and iPadOS architectures. Maybe even for the simulator 👀
    mutating func run() throws {
        if frameworkName == "" {
            throw ValidationError("Hey, kinda need a framework name to list/dump")
        }
        
        let inputArr: [Bool] = [
            macos,
            ios,
            tvos,
            watchos
        ]
        
        guard (macos || ios || tvos || watchos) else {
            throw ValidationError("Expected an OS type flag and received none")
        }
        
        if inputArr.firstIndex(of: YES) != inputArr.lastIndex(of: YES) {
            throw ValidationError("More than one framework OS type flag was given. Expected 1")
        }
        
        var frameworkPath: String = ""
        
        if macos {
            frameworkPath = macDir
        } else if ios {
            frameworkPath = simDir("iPhoneOS", "iOS")
        } else if tvos {
            frameworkPath = simDir("AppleTVOS", "tvOS")
        } else if watchos {
            frameworkPath = simDir("watchOS")
        }
        
        if usePrivateFrameworks {
            frameworkPath = frameworkPath.replacingOccurrences(of: "frameworks", with: "PrivateFrameworks", options: .caseInsensitive)
        }
        
        if info {
            printInfo(frameworkPath)
            return
        }
        
        let framework: Framework = try Framework(withPath: frameworkPath + "/\(frameworkName).framework/")
        NotificationCenter.default.addObserver(forName: Bundle.didLoadNotification, object: framework.bundle, queue: nil) { notification in
            let classes: [CFString] = notification.userInfo![NSLoadedClasses] as! [CFString]
            for classIDX in 0..<classes.count {
                // Ughhhh this is so ugly
                let classNameRef: CFString = classes[classIDX]
                let string: NSString = classNameRef as NSString
                let char: UnsafePointer<CChar> = string.utf8String!
                let classImp: AnyClass? = objc_getClass(char) as! AnyClass?
                let classInfo: ClassInfo = ClassInfo(withClass: classImp ?? NSObject.self)
                let wrapper: InterfaceWrapper = InterfaceWrapper(withInfo: classInfo)
                print(wrapper.stringRepresenation + "\n")
            }
        }
        framework.bundle.load()
    }
}
