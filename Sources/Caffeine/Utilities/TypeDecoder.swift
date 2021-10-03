//
//  TypeDecoder.swift
//  dump
//
//  Created by Cero on 2021-09-27.
//

import Foundation

public struct TypeDecoder {

    public struct TypeDecoderJumpInfo {
        let continueIDX: Int
        var rawString: String
    }

    // ugly as stink I know, but efficient as hell
    public static var attributeMap: [String: String] = [
        "c": "BOOL",
        "i": "int",
        "s": "short",
        "l": "long",
        "q": "long long",
        "C": "char",
        "I": "unsigned int",
        "S": "unsigned short",
        "L": "unsigned long",
        "Q": "unsigned long long",
        "f": "float",
        "d": "double",
        "B": "bool", // C++: "bool", C99: "_Bool"
        "v": "void",
        "*": "char *",
        "@": "id",
        "#": "Class",
        ":": "SEL",
        "?": "IMP" // Usually is IMP not UNKNOWN_TYPE
    ]

    public static var descriptorMap: [String: String] = [
        "r": "const",
        "n": "in",
        "N": "inout",
        "o": "out",
        "O": "bycopy",
        "R": "byref",
        "V": "oneway"
    ]

    public static let propertyAttributes: [String: String] = [
        "R": "readonly",
        "C": "copy",
        "&": "retain",
        "N": "nonatomic",
        "W": "weak"
    ]

    public static func findReplacer(_ type: String) -> String {

        guard Int(type) == nil && type != "?" else {
            return ""
        }

        return attributeMap[type] ?? descriptorMap[type] ?? "UNKNOWN_TYPE_T /* \(type) */"

    }

    public static func findPropertyAttribute(_ attribute: String) -> String {
        return propertyAttributes[attribute] ?? "UNKNOWN_ATTRIBUTE_T /* \(attribute) */"
    }

    public static func getArrayType(fromString string: String, startIndex: Int) -> TypeDecoderJumpInfo {

        var chars: String = ""
        var index = 0
        var bracketsToFind = 1
        var done = false
        var returnIndex: Int?
        string.forEach({ charector in
            if index >= (startIndex + 1) && !done {
                if charector == "]" {
                    bracketsToFind -= 1
                    if bracketsToFind == 0 {
                        done = true
                        returnIndex = index + 1
                        return
                    }
                } else if charector == "[" {
                    bracketsToFind += 1
                }
                chars.append(String(charector))
            }
            index += 1
        })

        var parsedString = TypeDecoder.translate(types: chars)
        return TypeDecoderJumpInfo(continueIDX: returnIndex!, rawString: parsedString.joined() + "[]")

    }

    public static func getStructType(fromString string: String, startIndex: Int) -> TypeDecoderJumpInfo {

        var chars: String = ""
        var index = 0
        var bracketsToFind = 1
        var stepOne = false
        var stepTwo = false
        var endIndex: Int?
        string.forEach({ charector in
            if index >= (startIndex + 1) && !stepTwo {
                if !stepOne {
                    if charector == "=" {
                        stepOne = true
                        return
                    } else {
                        chars.append(String(charector))
                    }
                } else {
                    if charector == "{" {
                        bracketsToFind += 1
                    } else if charector == "}" {
                        bracketsToFind -= 1
                        if bracketsToFind == 0 {
                            stepTwo = true
                            endIndex = index + 2
                            return
                        }
                    }
                }
            }
            index += 1
        })
        
        if chars.hasPrefix("__") {
            chars.removeFirst(2)
        }
        return TypeDecoderJumpInfo(continueIDX: endIndex!, rawString: chars)

    }

    // swiftlint:disable:next function_body_length
    public static func translate(
        types: String,
        withClosure
            closure: (([String]) -> Void)? = nil
    ) -> [String] {

        var returning: [String] = []
        var appendAsterix = false
        var prependDescriptor = false
        var descriptorSwap: String = ""
        var index = 0
        while index < types.count {
            let swiftIndex = types.index(types.startIndex, offsetBy: index)
            let charector = types[swiftIndex]
            if charector == "{" { // Struct
                var info = getStructType(fromString: types, startIndex: index)
                if appendAsterix {
                    info.rawString += " *"
                    appendAsterix = false
                }
                returning.append(info.rawString)
                index = info.continueIDX
                continue
            } else if charector == "^" { // Pointer
                appendAsterix = true
                index += 1
                continue
            } else if charector == "[" { // Collection of sorts
                var info = getArrayType(fromString: types, startIndex: index)
                if appendAsterix {
                    info.rawString += " *"
                    appendAsterix = false
                }
                returning.append(info.rawString)
                index = info.continueIDX
                continue
            } else if descriptorMap[String(charector)] != nil {
                prependDescriptor = true
                descriptorSwap = descriptorMap[String(charector)]!
                index += 1
                continue
            }
            var endThingy = findReplacer("\(charector)")
            if endThingy != "" {
                if prependDescriptor {
                    endThingy = "\(descriptorSwap) \(endThingy)"
                    prependDescriptor = false
                    descriptorSwap = ""
                }
                if appendAsterix {
                    endThingy += " *"
                    appendAsterix = false
                }
                returning.append(endThingy)
            }
            index += 1
        }
        if closure != nil {
            closure!(returning)
        }
        return returning

    }
}
