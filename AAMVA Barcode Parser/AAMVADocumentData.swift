//
//  AAMVADocumentData.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

public class AAMVADocumentData: DocumentData {
    
    public override var firstName: String? {
        self["DAC"]
    }
    
    public override var lastName: String? {
        self["DCS"]
    }
    
    public override var address: String? {
        let cityAndState = [self["DAI"],self["DAJ"]].filter({ $0 != nil && !$0!.isEmpty }).compactMap({ $0 }).joined(separator: ", ")
        let address = [self["DAG"],self["DAH"],cityAndState,self["DAK"]].filter({ $0 != nil && !$0!.isEmpty }).compactMap({ $0 }).joined(separator: "\n")
        if !address.isEmpty {
            return address
        }
        return nil
    }
    
    public override var dateOfBirth: String? {
        self["DBB"]
    }
    
    public override var dateOfIssue: String? {
        self["DBD"]
    }
    
    public override var dateOfExpiry: String? {
        self["DBA"]
    }
    
    public override var documentNumber: String? {
        self["DAQ"]
    }
    
    public override var sex: String? {
        self["DBC"]
    }
    
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
    }
}
