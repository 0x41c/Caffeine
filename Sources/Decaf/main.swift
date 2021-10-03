//
//  main.swift
//  
//
//  Created by Cero on 2021-09-29.
//

import Foundation
import ArgumentParser

// haha imagine not liking this better than "true, false"
let YES = true
let NO = false

let banner = checkScreenWidth(70) ? """
        /~~~~~~~~~~~~~~~~~~~~~~~/|
       /              /######/ / |
      /              /______/ /  |
     ========================= /||
     |_______________________|/ ||
      |  \\****/     \\__,,__/    ||
      |===\\**/       __,,__     ||     // Copyright © c0dine, all rights reserved
      |______________\\====/%____||     // Banner by Joe Jacques
      |   ___        /~~~~\\ %  / |
     _|  |===|===   /      \\%_/  |
    | |  |###|     |########| | /
    |____\\###/______\\######/__|/
    ~~~~~~~~~~~~~~~~~~~~~~~~~~

- "Make it decaf"
""" : ""

@available(macOS 10.13, *)
struct Decaf : ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "decaf",
        abstract: "A simple yet effective framework dumper.",
        discussion: "\(banner)\n\n" + coolify("""
        A runtime dumper made with frameworks in mind. Other types of binaries are TBD.
        """),
        version: "Version 0.1.1",
        shouldDisplay: YES,
        subcommands: [List.self, Brew.self]
    )
    
    mutating func run(_ arguments: [String]) throws {
        // TODO: Get the heart up and running <3
    }
}

if #available(macOS 10.13, *) {
    Decaf.main()
} else {
    // Fallback on earlier versions
}


// Copy pasted from: https://stackoverflow.com/a/50035059/13343654
// Felt lazy... anyways, thx
func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}
