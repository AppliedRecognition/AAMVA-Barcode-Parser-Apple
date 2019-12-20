//
//  MagStripeDocumentData.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

@objc public class MagStripeDocumentData: DocumentData {
    
    override func updateCommonFields() {
        self.firstName = self["First name"]
        self.lastName = self["Last name"]
        self.address = self["Address"]
        self.dateOfBirth = self["Date of birth"]
        self.dateOfExpiry = self["Date of expiry"]
        self.sex = self["Sex"]
        self.documentNumber = self["DL/ID#"]
    }
}
