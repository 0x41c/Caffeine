//
//  TableParsing.swift
//  
//
//  Created by Cero on 2021-09-29.
//

import Foundation
import Darwin

var globalLongest: Int = 0
var windowSize: winsize = winsize()
let validWindow = (ioctl(STDOUT_FILENO, TIOCGWINSZ, &windowSize) == 0)


func checkScreenWidth(_ targetWidth: Int) -> Bool {
    // Not a valid terminal window, return true.
    guard validWindow else {
        return true
    }
    
    return windowSize.ws_col >= targetWidth
}


func coolify(_ message: String,_ useGlobalLongest: Bool = true) -> String {
    
    var message = message // Mutable trick
    var messageLines = message.split(separator: "\n").map { substring in
        String(substring)
    }
    
    // Just making sure that it is being formatted in a good environment
    guard #available(macOS 10.0, *), checkScreenWidth(150) else {
        messageLines.removeAll(where: { char in
            char == "~break"
        })
        return messageLines.joined(separator: "\n")
    }
    
    var longestLine: Int = 0

    var barIndexes: [Int] = []
    for lineNumber in 0..<messageLines.count {
        let line = messageLines[lineNumber]
        if line.count > longestLine {
            longestLine = line.count + 2
        }
        if line == "~break" {
            barIndexes.insert(lineNumber, at: barIndexes.count)
            continue
        }
        messageLines[lineNumber] = line
    }
    
    if useGlobalLongest {
        if longestLine > globalLongest {
            globalLongest = longestLine
        } else {
            longestLine = globalLongest
        }
    }
    let filler = String(repeating: "─", count: longestLine)
    let topCap = "┌\(filler)┐"
    let bottomCap = "└\(filler)┘"
    
    for barIndex in 0..<messageLines.count {
        var line = messageLines[barIndex]
        if barIndexes.contains(barIndex) {
            line = "├\(filler)┤"
        } else {
            line = "│ \(line)\(String(repeating: " ", count: longestLine - line.count-1))│"
        }
        messageLines[barIndex] = line
    }
    message = messageLines.joined(separator: "\n")
    message = "\(topCap)\n\(message)"
    message = "\(message)\n\(bottomCap)"
    return message
}
