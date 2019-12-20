//
//  SexDataElement.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

struct SexDataElement: DataElement {
    
    let mandatory: Bool
    let cardType: CardType
    let id: String
    let description: String
    let params: ElementParams
    
    init(mandatory: Bool, cardType: CardType, id: String, description: String, params: ElementParams) {
        self.mandatory = mandatory
        self.cardType = cardType
        self.id = id
        self.description = description
        self.params = params
    }
    
    func formatValue(_ value: String) -> String {
        return value == "1" ? "Male" : (value == "2" ? "Female" : value)
    }
}
