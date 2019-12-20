//
//  ValidChars.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

struct ValidChars: OptionSet {
    let rawValue: Int
    static let alpha = ValidChars(rawValue: 1 << 0)
    static let numeric = ValidChars(rawValue: 1 << 1)
    static let special = ValidChars(rawValue: 1 << 2)
    static let any: ValidChars = [.alpha,.numeric,.special]
}
