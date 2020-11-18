//
//  CardType.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

struct CardType: OptionSet {
    let rawValue: Int
    static let dl = CardType(rawValue: 1 << 0)
    static let id = CardType(rawValue: 1 << 1)
    static let both: CardType = [.dl,.id]
}
