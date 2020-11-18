//
//  DateDataElement.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

struct DateDataElement: DataElement {
    
    let mandatory: Bool
    let cardType: CardType
    let id: String
    let description: String
    let params: ElementParams
    let dateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
    let dateParser: DateFormatter = DateFormatter()
    
    init(mandatory: Bool, cardType: CardType, id: String, description: String, params: ElementParams) {
        self.mandatory = mandatory
        self.cardType = cardType
        self.id = id
        self.description = description
        self.params = params
        dateParser.timeStyle = .none
        dateParser.dateFormat = "MMddyyyy"
    }
    
    func formatValue(_ value: String) -> String {
        if let date = dateParser.date(from: value) {
            return dateFormatter.string(from: date)
        }
        return value
    }
}
