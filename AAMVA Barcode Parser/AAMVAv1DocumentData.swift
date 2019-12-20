//
//  AAMVAv1DocumentData.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

@objc public class AAMVAv1DocumentData: AAMVADocumentData {
    
    public override var lastName: String? {
        self["DAB"]
    }
    
    init() {
        super.init(elements: [
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DAA", description: "Driver License Name", params: ElementParams("V150ANS")),
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DAG", description: "Driver Mailing Street Address 1", params: ElementParams("V150ANS")),
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DAI", description: "Driver Mailing City", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DAJ", description: "Driver Mailing Jurisdiction Code", params: ElementParams("V5ANS")),
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DAK", description: "Driver Mailing Postal Code", params: ElementParams("V11ANS")),
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DAQ", description: "Driver License/ID Number", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DAR", description: "Driver License Classification Code", params: ElementParams("F4AN")),
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DAS", description: "Driver License Restriction Code", params: ElementParams("F10AN")),
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DAT", description: "Driver License Endorsements Code", params: ElementParams("F5AN")),
            DateDataElement(mandatory: true, cardType: .dl, id: "DBA", description: "Driver License Expiration Date", params: ElementParams("F8N")),
            DateDataElement(mandatory: true, cardType: .dl, id: "DBB", description: "Date of Birth", params: ElementParams("F8N")),
            SexDataElement(mandatory: true, cardType: .dl, id: "DBC", description: "Driver Sex", params: ElementParams("F1N")),
            DateDataElement(mandatory: true, cardType: .dl, id: "DBD", description: "Driver License or ID Document Issue Date", params: ElementParams("F8N")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAU", description: "Height (FT/IN)", params: ElementParams("V10ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAW", description: "Weight (LBS)", params: ElementParams("V10ANS")),
            EyeColourDataElement(mandatory: false, cardType: .dl, id: "DAY", description: "Eye Color", params: ElementParams("F3A")),
            HairColourDataElement(mandatory: false, cardType: .dl, id: "DAZ", description: "Hair Color", params: ElementParams("V5ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBK", description: "Social Security Number", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "PAA", description: "Driver Permit Classification Code", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "PAB", description: "Driver Permit Expiration Date", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "PAC", description: "Permit Identifier", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "PAD", description: "Driver Permit Issue Date", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "PAE", description: "Driver Permit Restriction Code", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "PAF", description: "Driver Permit Endorsement Code", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAB", description: "Driver Last Name", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAC", description: "Driver First Name", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAD", description: "Driver Middle Name or Initial Driver Name Suffix", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAF", description: "Driver Name Prefix", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAH", description: "Driver Mailing Street Address 2", params: ElementParams("V100ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAL", description: "Driver Residence Street Address 1", params: ElementParams("V100ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAM", description: "Driver Residence Street Address 2", params: ElementParams("V100ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAN", description: "Driver Residence City", params: ElementParams("V100ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAO", description: "Driver Residence Jurisdiction Code", params: ElementParams("V100ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAP", description: "Driver Residence Postal Code", params: ElementParams("V11ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAV", description: "Height (CM)", params: ElementParams("V10ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DAX", description: "Weight (KG)", params: ElementParams("V10ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBE", description: "Issue Timestamp", params: ElementParams("V100ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBF", description: "Number of Duplicates", params: ElementParams("V5N")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBG", description: "Medical Indicator/Codes", params: ElementParams("V20ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBH", description: "Organ Donor", params: ElementParams("V20ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBI", description: "Non-Resident Indicator", params: ElementParams("V20ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBJ", description: "Unique Customer Identifier", params: ElementParams("V50ANS")),
            DateDataElement(mandatory: false, cardType: .dl, id: "DBL", description: "Driver \"AKA\" Date Of Birth", params: ElementParams("F8N")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBM", description: "Driver \"AKA\" Social Security Number", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBN", description: "Driver \"AKA\" Name", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBO", description: "Driver \"AKA\" Last Name", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBP", description: "Driver \"AKA\" First Name", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBQ", description: "Driver \"AKA\" Middle Name", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBR", description: "Driver \"AKA\" Suffix", params: ElementParams("V5ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DBS", description: "Driver \"AKA\" Prefix", params: ElementParams("V5ANS")),
        ])
    }
}
