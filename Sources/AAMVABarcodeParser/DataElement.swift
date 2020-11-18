//
//  DataElement.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

protocol DataElement {
    var mandatory: Bool { get }
    var cardType: CardType { get }
    var id: String { get }
    var description: String { get }
    var params: ElementParams { get }
    func formatValue(_ value: String) -> String
}

extension DataElement {
    
    func isValidValue(_ value: String) -> Bool {
        if value.count > params.length {
            return false
        }
        let range = NSRange(location: 0, length: value.count)
        if !params.validChars.contains(.numeric), let regex = try? NSRegularExpression(pattern: "[0-9 ]", options: .caseInsensitive), regex.numberOfMatches(in: value, options: [], range: range) > 0 {
            return false
        }
        if !params.validChars.contains(.alpha), let regex = try? NSRegularExpression(pattern: "[a-z ]", options: .caseInsensitive), regex.numberOfMatches(in: value, options: [], range: range) > 0 {
            return false
        }
        if !params.validChars.contains(.special), let regex = try? NSRegularExpression(pattern: "[^0-9a-z ]", options: .caseInsensitive), regex.numberOfMatches(in: value, options: [], range: range) > 0 {
            return false
        }
        return true
    }
    
}
