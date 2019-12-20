//
//  AAMVAv6DocumentData.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

@objc public class AAMVAv6DocumentData: AAMVADocumentData {
    
    init() {
        super.init(elements: [
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DCA", description: "Jurisdiction-specific vehicle class", params: ElementParams("V6ANS")),
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DCB", description: "Jurisdiction-specific restriction codes", params: ElementParams("V12ANS")),
            SimpleDataElement(mandatory: true, cardType: .dl, id: "DCD", description: "Jurisdiction-specific endorsement codes", params: ElementParams("V5ANS")),
            DateDataElement(mandatory: true, cardType: .both, id: "DBA", description: "Document Expiration Date", params: ElementParams("F8N")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DCS", description: "Customer Family Name", params: ElementParams("V40ANS")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DAC", description: "Customer First Name", params: ElementParams("V40ANS")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DAD", description: "Customer Middle Name(s)", params: ElementParams("V40ANS")),
            DateDataElement(mandatory: true, cardType: .both, id: "DBD", description: "Document Issue Date", params: ElementParams("F8N")),
            DateDataElement(mandatory: true, cardType: .both, id: "DBB", description: "Date of Birth", params: ElementParams("F8N")),
            SexDataElement(mandatory: true, cardType: .both, id: "DBC", description: "Physical Description – Sex", params: ElementParams("F1N")),
            EyeColourDataElement(mandatory: true, cardType: .both, id: "DAY", description: "Physical Description – Eye Color", params: ElementParams("F3A")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DAU", description: "Physical Description – Height", params: ElementParams("F6AN")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DAG", description: "Address – Street 1", params: ElementParams("V35ANS")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DAI", description: "Address – City", params: ElementParams("V20ANS")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DAJ", description: "Address – Jurisdiction Code", params: ElementParams("F2A")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DAK", description: "Address – Postal Code", params: ElementParams("F11AN")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DAQ", description: "Customer ID Number", params: ElementParams("V25ANS")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DCF", description: "Document Discriminator", params: ElementParams("V25ANS")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DCG", description: "Country Identification", params: ElementParams("F3A")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DDE", description: "Family name truncation", params: ElementParams("F1A")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DDF", description: "First name truncation", params: ElementParams("F1A")),
            SimpleDataElement(mandatory: true, cardType: .both, id: "DDG", description: "Middle name truncation", params: ElementParams("F1A")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DAH", description: "Address – Street 2", params: ElementParams("V35ANS")),
            HairColourDataElement(mandatory: false, cardType: .both, id: "DAZ", description: "Hair color", params: ElementParams("V12A")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DCI", description: "Place of birth", params: ElementParams("V33A")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DCJ", description: "Audit information", params: ElementParams("V25ANS")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DCK", description: "Inventory control number", params: ElementParams("V25ANS")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DBN", description: "Alias / AKA Family Name", params: ElementParams("V10ANS")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DBG", description: "Alias / AKA Given Name", params: ElementParams("V15ANS")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DBS", description: "Alias / AKA Suffix Name", params: ElementParams("V5ANS")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DCU", description: "Name Suffix", params: ElementParams("V5ANS")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DCE", description: "Physical Description – Weight Range", params: ElementParams("F1N")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DCL", description: "Race / ethnicity", params: ElementParams("F3A")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DCM", description: "Standard vehicle classification", params: ElementParams("F4AN")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DCN", description: "Standard endorsement code", params: ElementParams("F5AN")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DCO", description: "Standard restriction code", params: ElementParams("F12AN")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DCP", description: "Jurisdiction-specific vehicle classification description", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DCQ", description: "Jurisdiction-specific endorsement code description", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .dl, id: "DCR", description: "Jurisdiction-specific restriction code description", params: ElementParams("V50ANS")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DDA", description: "Compliance Type", params: ElementParams("F1A")),
            DateDataElement(mandatory: false, cardType: .both, id: "DDB", description: "Card Revision Date", params: ElementParams("F8N")),
            DateDataElement(mandatory: false, cardType: .dl, id: "DDC", description: "HAZMAT Endorsement Expiration Date", params: ElementParams("F8N")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DDD", description: "Limited Duration Document Indicator", params: ElementParams("F1N")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DAW", description: "Weight (pounds)", params: ElementParams("F3N")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DAX", description: "Weight (kilograms)", params: ElementParams("F3N")),
            DateDataElement(mandatory: false, cardType: .both, id: "DDH", description: "Under 18 Until", params: ElementParams("F8N")),
            DateDataElement(mandatory: false, cardType: .both, id: "DDI", description: "Under 19 Until", params: ElementParams("F8N")),
            DateDataElement(mandatory: false, cardType: .both, id: "DDJ", description: "Under 21 Until", params: ElementParams("F8N")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DDK", description: "Organ Donor Indicator", params: ElementParams("F1N")),
            SimpleDataElement(mandatory: false, cardType: .both, id: "DDL", description: "Veteran Indicator", params: ElementParams("F1N"))
        ])
    }
}
