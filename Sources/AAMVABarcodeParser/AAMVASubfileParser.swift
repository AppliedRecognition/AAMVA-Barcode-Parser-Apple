//
//  AamvaSubfileParser.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

class AAMVASubfileParser {
    
    enum AamvaSubfileParserError: Error {
        case missingMandatoryField, invalidFieldValue
    }
    
    let version: Int
    let separator: Data
    
    init?(aamvaVersion: Int, separator: Data) {
        if aamvaVersion > 8 {
            return nil
        }
        self.version = aamvaVersion
        self.separator = separator
    }
    
    func splitField(_ data: Data) -> (String,String)? {
        if let str = String(data: data, encoding: .utf8), str.count >= 3 {
            let key = String(str[str.startIndex..<str.index(str.startIndex, offsetBy: 3)])
            let val = String(str[str.index(str.startIndex, offsetBy: 3)..<str.endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !val.isEmpty {
                return(key,val)
            }
        }
        return nil
    }
    
    func parseFields(in data: Data) throws -> AAMVADocumentData {
        let documentData: AAMVADocumentData
        switch self.version {
        case 8:
            documentData = AAMVAv8DocumentData()
        case 7:
            documentData = AAMVAv7DocumentData()
        case 6:
            documentData = AAMVAv6DocumentData()
        case 5:
            documentData = AAMVAv5DocumentData()
        case 4:
            documentData = AAMVAv4DocumentData()
        case 3:
            documentData = AAMVAv3DocumentData()
        case 2:
            documentData = AAMVAv2DocumentData()
        case 1:
            documentData = AAMVAv1DocumentData()
        default:
            throw NSError()
        }
        documentData.rawData = data
        guard data.count >= 5 else {
            return documentData
        }
        let subData = data[data.startIndex..<data.index(data.startIndex, offsetBy: 2)]
        guard let type = String(data: subData, encoding: .utf8) else {
            return documentData
        }
        if type != "DL" && type != "ID" {
            return documentData
        }
        let cardType: CardType = type == "DL" ? .dl : .id
        let separator = Data([0x0A])
        var searchRange: Range<Data.Index> = data.index(data.startIndex, offsetBy: 2)..<data.endIndex
        var fields: [String:String] = [:]
        while let found = data.range(of: separator, options: [], in: searchRange) {
            let sub: Data = data.subdata(in: searchRange.lowerBound..<found.lowerBound)
            if let (key,val) = splitField(sub) {
                fields[key] = val
            }
            searchRange = found.upperBound..<searchRange.upperBound
        }
        let sub: Data = data[searchRange.lowerBound..<searchRange.upperBound]
        if let (key,val) = splitField(sub) {
            fields[key] = val
        }
        let elements = documentData.elements.filter({ $0.cardType.contains(cardType) })
        for element in elements {
            if let val = fields.removeValue(forKey: element.id) {
                documentData.setValue(DataField(description: element.description, originalValue: val, parsedValue: element.formatValue(val)), forEntryID: element.id)
                if !element.isValidValue(val) {
                    NSLog("Invalid value for %@ (%@)", element.description, element.id)
                }
            } else if element.mandatory {
//                throw AamvaSubfileParserError.missingMandatoryField
                NSLog("Missing mandatory value for %@", element.id)
            }
        }
        return documentData
    }
}
