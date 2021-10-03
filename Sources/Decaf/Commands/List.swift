//
//  List.swift
//  
//
//  Created by Cero on 2021-09-29.
//

import Foundation
import ArgumentParser

@available(macOS 10.13, *)
struct List : ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "list",
        abstract: "List available frameworks",
        discussion: "\(banner)\n\n" + coolify("""
        Allows you to list all the available frameworks, whether they are private, public, or even iOS.

        Non MacOS locations default to:
           /Applications/Xcode.app/Contents/Developer/Platforms

        To specify a different base location use the "--location" argument
        ~break
        Does require command line tools and simulators installed for non MacOS options
        """, false),
        version: "0.0.1",
        shouldDisplay: YES
    )
    
    @Flag(
        name: [.customShort("m", allowingJoined: NO), .long],
        help: ArgumentHelp(
            "List MacOS Frameworks",
            discussion: macOSMessage
        )
    ) var macos: Bool = NO
    
    @Flag(
        name: [.customShort("i", allowingJoined: NO), .long],
        help: ArgumentHelp(
            "List iOS Frameworks",
            discussion: iOSMessage
        )
    ) var ios: Bool = NO
    
    @Flag(
        name: [.customShort("t", allowingJoined: NO), .long],
        help: ArgumentHelp(
            "List tvOS Frameworks",
            discussion: tvOSMessage
        )
    ) var tvos: Bool = NO
    
    @Flag(
        name: [.customShort("w", allowingJoined: NO), .long],
        help: ArgumentHelp(
            "List watchOS Frameworks",
            discussion: watchOSMessage
        )
    ) var watchos: Bool = NO
    
    @Flag(
        name: [.customShort("p", allowingJoined: NO), .customLong("private", withSingleDash: NO)],
        help: ArgumentHelp(
            "Use Private FrameWorks",
            discussion: privateFrameworkMessage
        )
    ) var usePrivateFrameworks: Bool = NO
    
    @Flag(
        name: [.customShort("a", allowingJoined: NO), .customLong("all", withSingleDash: NO)],
        help: ArgumentHelp(
            "List all the Frameworks",
            discussion: coolify("""
            This is quite the hail mary command, as the entirety of the framworks for every platform will be listed.
            Duplicates are bound to occur
            """)
        )
    ) var listAll: Bool = NO
    
    @Option(
        name: [.customShort("c", allowingJoined: YES),.customLong("custom", withSingleDash: NO)],
        help: ArgumentHelp(
            "Define a custom path to list frameworks in",
            discussion: coolify("""
            Allows you to choose a custom path to list a framework in.
            It will also notify you when no frameworks exist in that path, or no valid ones do.
            """)
        )
    ) var customDirectory: String = ""
    
    @Option(
        name: [.long],
        help: ArgumentHelp(
            "",
            discussion: """
            """
        )
    ) var limit: Int = 50
    
    mutating func run() throws {
        if !(macos || ios || tvos || watchos) && !listAll && customDirectory == "" {
            throw ValidationError("No required flags were given\n")
        }
        
        
        if customDirectory {
            print("Custom: ")
            try listPath(customDirectory, false, limit)
            return
        }
        
        if listAll {
            self.macos = true
            self.watchos = true
            self.ios = true
            self.tvos = true
        }
        
        let iOSDir = simDir("iPhoneOS", "iOS")
        let watchOSDir = simDir("watchOS")
        let appleTVOSDir = simDir("AppleTVOS", "tvOS")
        
        if macos {
            print("MacOS: ")
            try listPath(macDir, usePrivateFrameworks, limit)
        }
        
        if tvos {
            print("TVOS: ")
            try listPath(appleTVOSDir, usePrivateFrameworks, limit)
        }
        
        if watchos {
            print("watchOS: ")
            try listPath(watchOSDir, usePrivateFrameworks, limit)
        }
        
        if ios {
            print("iOS : ")
            try listPath(iOSDir, usePrivateFrameworks, limit)
        }
        
    }
}


@available(macOS 10.13, *)
func listPath(_ path: String,_ usePrivateFrameworks: Bool, _ limit: Int = -1) throws {
    var path = path
    if usePrivateFrameworks {
        path = path.replacingOccurrences(
            of: "Frameworks",
            with: "PrivateFrameworks",
            options: .caseInsensitive
        )
    }
    
    let output: String = shell("ls \(path)")
    guard output != "", output.contains(".framework") else {
        throw ValidationError("""
            The specified path: "\(path)" does not contain any frameworks.
            Please check the path for spelling mistakes.
            """
        )
    }
    let outputSplit: [String] = output.split(separator: "\n").map { string in
        String(string)
    }
    
    var printVal: String = ""
    var more = 0
    if limit > 0 && limit < outputSplit.count-1 {
        more = outputSplit.count - (1 + limit)
    }
    
    var index = 0
    
    func addProperty(_ propertyName: String, _ value: String) {
        printVal += "~break\n"
        printVal += "       \(propertyName): \(value)\n"
    }
    
    for frameworkName in outputSplit {
        if index < limit {
            let addition = path + "/\(frameworkName)/"
            let framework: Framework
            do {
                framework = try Framework(withPath: addition)
            } catch {
                throw ValidationError("Encountered issue loading a framework\nIs there a faux framework?")
            }
            printVal += "\(framework.name)\n"
            addProperty("Version", framework.version)
            addProperty("BundleID", framework.bundleID)
            if index != limit-1 {
                printVal += "~break\n"
            }
        }
        index += 1
    }
    
    if more != 0 {
        printVal += "~break\n"
        printVal += "\(more) more..."
    }
    
    print(coolify(printVal + "\n"))
}
