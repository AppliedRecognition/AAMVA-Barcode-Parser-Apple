//
//  IntellicheckDocumentData.swift
//  AAMVABarcodePaser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

@objc public class IntellicheckDocumentData: DocumentData {
    
    override func updateCommonFields() {
        self.firstName = self["firstname"]
        self.lastName = self["lastname"]
        let cityAndState = [self["city"],self["state"]].filter({ $0 != nil && !$0!.isEmpty }).compactMap({ $0 }).joined(separator: ", ")
        let address = [self["address1"],self["address2"],cityAndState,self["postalcode"]].filter({ $0 != nil && !$0!.isEmpty }).compactMap({ $0 }).joined(separator: "\n")
        if !address.isEmpty {
            self.address = address
        }
        self.dateOfBirth = self["dateofbirth"]
        self.dateOfIssue = self["issuedate"]
        self.dateOfExpiry = self["expirationdate"]
        self.documentNumber = self["dlidnumberformatted"]
        self.sex = self["gender"]
    }
}
