//
//  AAMVADocumentData.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

public class AAMVADocumentData: DocumentData {
    
    let elements: [DataElement]
    
    lazy var elementIDs: [String] = {
        self.elements.map({ $0.id })
    }()
    
    var availableElementIDs: [String] {
        self.elements.compactMap({ self.fields.keys.contains($0.id) ? $0.id : nil })
    }
    
    init(elements: [DataElement]) {
        self.elements = elements
        super.init()
        self.updateCommonFields()
    }
    
    override func updateCommonFields() {
        self.firstName = self["DAC"]
        self.lastName = self["DCS"]
        let cityAndState = [self["DAI"],self["DAJ"]].filter({ $0 != nil && !$0!.isEmpty }).compactMap({ $0 }).joined(separator: ", ")
        self.address = [self["DAG"],self["DAH"],cityAndState,self["DAK"]].filter({ $0 != nil && !$0!.isEmpty }).compactMap({ $0 }).joined(separator: "\n")
        self.dateOfBirth = self["DBB"]
        self.dateOfIssue = self["DBD"]
        self.dateOfExpiry = self["DBA"]
        self.documentNumber = self["DAQ"]
        self.sex = self["DBC"]
    }
}
