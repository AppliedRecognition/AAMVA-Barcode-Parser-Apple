//
//  ElementParams.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

struct ElementParams {
    let fixed: Bool
    let length: Int
    let validChars: ValidChars
    
    init!(_ string: String) {
        guard let regex = try? NSRegularExpression(pattern: "(V|F)(\\d+)([ANS]+)") else {
            return nil
        }
        guard let match = regex.matches(in: string, range: NSRange(string.startIndex..., in: string)).first else {
            return nil
        }
        guard match.numberOfRanges == 4 else {
            return nil
        }
        guard let l = Int((string as NSString).substring(with: match.range(at: 2))) else {
            return nil
        }
        fixed = (string as NSString).substring(with: match.range(at: 1)) == "F"
        length = l
        let validStr = (string as NSString).substring(with: match.range(at: 3))
        var valid: ValidChars = []
        if validStr.contains("A") {
            valid.insert(.alpha)
        }
        if validStr.contains("N") {
            valid.insert(.numeric)
        }
        if validStr.contains("S") {
            valid.insert(.special)
        }
        validChars = valid
    }
}
