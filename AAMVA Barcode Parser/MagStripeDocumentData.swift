//
//  MagStripeDocumentData.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

@objc public class MagStripeDocumentData: DocumentData {
    
    public override var firstName: String? {
        self["First name"]
    }
    
    public override var lastName: String? {
        self["Last name"]
    }
    
    public override var address: String? {
        self["Address"]
    }
    
    public override var dateOfBirth: String? {
        self["Date of birth"]
    }
    
    public override var dateOfExpiry: String? {
        self["Date of expiry"]
    }
    
    public override var sex: String? {
        self["Sex"]
    }
    
    public override var documentNumber: String? {
        self["DL/ID#"]
    }
}
