//
//  MethodPropagator.swift
//  dump
//
//  Created by Cero on 2021-09-28.
//

import Foundation

func propagateMethod(
    withName name: String,
    attributes: String,
    returnType: String? = nil,
    isClassMethod: Bool? = nil
) -> String {
    var part: String

    if isClassMethod != nil {
        part = (isClassMethod! ? "+" : "-") + " () "
    } else {
        part = "(- +) () "
    }

    part += name

    let colonExists = part.contains(":")
    var argumentArray = part.split(separator: ":")

    if returnType == nil {
        var returnType: String
        var attributes = attributes
        let attributesSplit = attributes.components(separatedBy: "@0:")

        returnType = String(attributes.removeFirst())
        attributes = attributesSplit.joined()
        _ = returnType
    }

    let argumentTypesStored = TypeDecoder.translate(types: attributes)

    if colonExists {

        for index in 0...argumentArray.count-1 {

            var currentThingy = argumentArray[index]
            currentThingy += ":"
            currentThingy += "(\(argumentTypesStored[index]))arg\(index + 1)"
            argumentArray[index] = currentThingy

        }

        part = argumentArray.joined(separator: " ")
    }

    part = part.replacingOccurrences(of: "()", with: "(\(returnType!))") // Already checked if it was nil, it won't be
    part += ";"
    if argumentTypesStored.contains("UNKNOWN_TYPE_T") {

        part += "\n// Type encoding: \(attributes)\n// \(argumentTypesStored)\n"

    }
    return part
}
