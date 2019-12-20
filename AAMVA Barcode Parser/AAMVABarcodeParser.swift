//
//  BarcodeParser.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 19/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

/// Parses barcodes on North American ID cards encoded in the American Association of Motor Vehicle Administrators (AAMVA) standard.
///
/// Specification is available on the [AAMVA website](https://www.aamva.org/DL-ID-Card-Design-Standard/).
/// - Since: 1.0.0
@objc public class AAMVABarcodeParser: NSObject, BarcodeParsing {
    
    /// Parse data in barcode
    /// - Parameter data: Data to parse
    /// - Returns: Parsed document data
    /// - Since: 1.0.0
    @objc public func parseData(_ data: Data) throws -> DocumentData {
        if data.count >= 30 {
            let complianceIndicator = data[0]
            if complianceIndicator == 0x40 {
                // May be AAMVA
                let elementSeparator = data[1..<2]
//                let recordSeparator = data[2]
//                let segmentTerminator = data[3]
//                let fileType = data[4..<9]
//                let iin = data[9..<15]
                guard let aamvaVersionNumber = dataToInt(data[15..<17]) else {
                    throw BarcodeParserError.aamvaVersionParsingError
                }
                guard let subfileParser = AAMVASubfileParser(aamvaVersion: aamvaVersionNumber, separator: elementSeparator) else {
                    throw BarcodeParserError.subfileParserCreationError
                }
//                let jurisdictionVersionNumber = data[17..<19]
                guard let numberOfEntries = dataToInt(data[19..<21]) else {
                    throw BarcodeParserError.numberOfEntriesParsingError
                }
                var index = 21
                var documentData: AAMVADocumentData?
                for _ in 0..<numberOfEntries {
//                    guard let subFileType = String(data: data[index..<index+2], encoding: .utf8) else {
//                        throw BarcodeParserError.parseError
//                    }
                    guard var offset = dataToInt(data[index+2..<index+6]) else {
                        throw BarcodeParserError.offsetParsingError
                    }
                    guard let length = dataToInt(data[index+6..<index+10]) else {
                        throw BarcodeParserError.dataLengthParsingError
                    }
                    if offset == 0 && numberOfEntries == 1 {
                        offset = data.count - length
                    }
                    let start = min(offset, data.count)
                    let end = min(offset+length, data.count)
                    let subData = try subfileParser.parseFields(in: data.subdata(in: start..<end))
                    if documentData == nil {
                        documentData = subData
                        documentData?.rawData = data
                    } else {
                        documentData!.appendFields(from: subData)
                    }
                    index += 10
                }
                if documentData == nil || documentData!.isEmpty {
                    throw BarcodeParserError.emptyDocument
                }
                return documentData!
            } else if var track = String(data: data, encoding: .ascii), let idx = track.firstIndex(of: "%") {
                let docData = MagStripeDocumentData()
                docData.rawData = data
                track.removeFirst(idx.utf16Offset(in: track)+1)
                let stateProvince = remove(2, charactersFromString: &track)
                docData.setValue(DataField(description: "State/Province", originalValue: stateProvince, parsedValue: stateProvince), forEntryID: "State/Province")
                let city = string(&track, toDelimiter: "^", maxLength: 13)
                docData.setValue(DataField(description: "City", originalValue: city, parsedValue: city), forEntryID: "City")
                let name = string(&track, toDelimiter: "^", maxLength: 35)
                let names = name.components(separatedBy: "$")
                if names.count > 2 {
                    docData.setValue(DataField(description: "Title", originalValue: names[2], parsedValue: names[2].trimmingCharacters(in: CharacterSet(charactersIn: ",/ "))), forEntryID: "Title")
                }
                if names.count > 1 {
                    docData.setValue(DataField(description: "First name", originalValue: names[1], parsedValue: names[1].trimmingCharacters(in: CharacterSet(charactersIn: ",/ "))), forEntryID: "First name") 
                }
                if names.count > 0 {
                    docData.setValue(DataField(description: "Last name", originalValue: names[0], parsedValue: names[0].trimmingCharacters(in: CharacterSet(charactersIn: ",/ "))), forEntryID: "Last name") 
                }
                let address = string(&track, toDelimiter: "^", maxLength: 77-name.count-city.count).components(separatedBy: "$").joined(separator: "\n")
                docData.setValue(DataField(description: "Address", originalValue: address, parsedValue: address), forEntryID: "Address") 
                if track.first! == "?" {
                    track.removeFirst()
                }
                if let idx = track.firstIndex(of: ";") {
                    track.removeFirst(idx.utf16Offset(in: track)+1)
                    let iin = remove(6, charactersFromString: &track)
                    docData.setValue(DataField(description: "IIN", originalValue: iin, parsedValue: iin), forEntryID: "IIN") 
                    var dlNo = string(&track, toDelimiter: "=", maxLength: 13)
                    var expiryYear = remove(2, charactersFromString: &track)
                    let expiryMonth = remove(2, charactersFromString: &track)
                    let birthYear = remove(4, charactersFromString: &track)
                    let birthMonth = remove(2, charactersFromString: &track)
                    let birthDate = remove(2, charactersFromString: &track)
                    let expiryDate: String?
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "YYYY/MM/dd"
                    let originalDate = expiryYear+expiryMonth
                    expiryYear = "20"+expiryYear
                    if expiryMonth == "77" {
                        expiryDate = "non-expiring"
                    } else if expiryMonth == "88" {
                        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: nil, year: Int(birthYear)!+1, month: Int(birthMonth)!+1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
                        if let date = dateComponents.date {
                            expiryDate = dateFormatter.string(from: date)
                        } else {
                            expiryDate = nil
                        }
                    } else if expiryMonth == "99" {
                        expiryDate = expiryYear+"/"+birthMonth+"/"+birthDate
                    } else {
                        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: nil, year: Int(expiryYear), month: Int(expiryMonth)!+1, day: 0, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
                        if let date = dateComponents.date {
                            expiryDate = dateFormatter.string(from: date)
                        } else {
                            expiryDate = nil
                        }
                    }
                    if let date = expiryDate {
                        docData.setValue(DataField(description: "Date of expiry", originalValue: originalDate, parsedValue: date), forEntryID: "Date of expiry") 
                    }
                    docData.setValue(DataField(description: "Date of birth", originalValue: birthYear+birthMonth+birthDate, parsedValue: birthYear+"/"+birthMonth+"/"+birthDate), forEntryID: "Date of birth") 
                    dlNo += string(&track, toDelimiter: "=", maxLength: 5)
                    docData.setValue(DataField(description: "DL/ID#", originalValue: dlNo, parsedValue: dlNo), forEntryID: "DL/ID#") 
                    if let idx = track.firstIndex(of: "%") {
                        track.removeFirst(idx.utf16Offset(in: track)+1)
                        let versionNumber = remove(1, charactersFromString: &track)
                        docData.setValue(DataField(description: "Version #", originalValue: versionNumber, parsedValue: versionNumber), forEntryID: "Version #") 
                        let securityVersionNumber = remove(1, charactersFromString: &track)
                        docData.setValue(DataField(description: "Security v. #", originalValue: securityVersionNumber, parsedValue: securityVersionNumber), forEntryID: "Security v. #") 
                        let postalCode = remove(11, charactersFromString: &track).trimmingCharacters(in: .whitespaces)
                        docData.setValue(DataField(description: "Postal code", originalValue: postalCode, parsedValue: postalCode), forEntryID: "Postal code") 
                        let dlClass = remove(2, charactersFromString: &track).trimmingCharacters(in: .whitespaces)
                        if !dlClass.isEmpty {
                            docData.setValue(DataField(description: "Class", originalValue: dlClass, parsedValue: dlClass), forEntryID: "Class") 
                        }
                        let restrictions = remove(10, charactersFromString: &track).trimmingCharacters(in: .whitespaces)
                        if !restrictions.isEmpty {
                            docData.setValue(DataField(description: "Restrictions", originalValue: restrictions, parsedValue: restrictions), forEntryID: "Restrictions") 
                        }
                        let endorsements = remove(4, charactersFromString: &track).trimmingCharacters(in: .whitespaces)
                        if !endorsements.isEmpty {
                            docData.setValue(DataField(description: "Endorsements", originalValue: endorsements, parsedValue: endorsements), forEntryID: "Endorsements") 
                        }
                        let sex = remove(1, charactersFromString: &track)
                        docData.setValue(DataField(description: "Sex", originalValue: sex, parsedValue: sex), forEntryID: "Sex") 
                        let height = remove(3, charactersFromString: &track).trimmingCharacters(in: .whitespaces)
                        if !height.isEmpty {
                            docData.setValue(DataField(description: "Height", originalValue: height, parsedValue: height), forEntryID: "Height") 
                        }
                        let weight = remove(3, charactersFromString: &track).trimmingCharacters(in: .whitespaces)
                        if !weight.isEmpty {
                            docData.setValue(DataField(description: "Weight", originalValue: weight, parsedValue: weight), forEntryID: "Weight") 
                        }
                        let hairColor = remove(3, charactersFromString: &track).trimmingCharacters(in: .whitespaces)
                        if !hairColor.isEmpty {
                            docData.setValue(DataField(description: "Hair color", originalValue: hairColor, parsedValue: AAMVABarcodeParser.hairColour(hairColor)), forEntryID: "Hair color") 
                        }
                        let eyeColor = remove(3, charactersFromString: &track).trimmingCharacters(in: .whitespaces)
                        if !eyeColor.isEmpty {
                            docData.setValue(DataField(description: "Eye color", originalValue: eyeColor, parsedValue: AAMVABarcodeParser.eyeColour(eyeColor)), forEntryID: "Eye color") 
                        }
                    }
                }
                if docData.isEmpty {
                    throw BarcodeParserError.emptyDocument
                }
                return docData
            }
        }
        throw BarcodeParserError.unsupportedBarcodeEncoding
    }
    
    private func dataToInt(_ data: Data) -> Int? {
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return Int(str)
    }
    
    private func string(_ string: inout String, toDelimiter delimiter: Character, maxLength: Int) -> String {
        let chunk = String(string[string.startIndex..<string.index(string.startIndex, offsetBy: maxLength)])
        if let delimiterIndex = chunk.firstIndex(of: delimiter) {
            string.removeFirst(delimiterIndex.utf16Offset(in: string)+1)
            return String(chunk[chunk.startIndex..<delimiterIndex])
        } else {
            string.removeFirst(maxLength)
            return chunk
        }
    }
    
    private func remove(_ count: Int, charactersFromString string: inout String) -> String {
        let offset = count > string.count ? string.count : count
        let chunk = String(string[string.startIndex..<string.index(string.startIndex, offsetBy: offset)])
        string.removeFirst(offset)
        return chunk
    }
    
    static func hairColour(_ abbreviation: String) -> String {
        switch abbreviation {
        case "BAL":
            return"Bald"
        case "BLK":
            return"Black"
        case "BLN":
            return"Blond"
        case "BRO":
            return"Brown"
        case "GRY":
            return"Gray"
        case "RED":
            return"Red/Auburn"
        case "SDY":
            return"Sandy"
        case "WHI":
            return"White"
        case "UNK":
            return"Unknown"
        default:
            return abbreviation
        }
    }
    
    static func eyeColour(_ abbreviation: String) -> String {
        switch abbreviation {
        case "BLK":
            return"Black"
        case "BLU":
            return"Blue"
        case "BRO":
            return"Brown"
        case "DIC":
            return"Dichromatic"
        case "GRY":
            return"Gray"
        case "GRN":
            return"Green"
        case "HAZ":
            return"Hazel"
        case "MAR":
            return"Maroon"
        case "PNK":
            return"Pink"
        case "UNK":
            return"Unknown"
        default:
            return abbreviation
        }
    }
}
