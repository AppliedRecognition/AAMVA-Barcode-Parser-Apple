//
//  IntellicheckBarcodeParser.swift
//  Ver-ID-Credentials
//
//  Created by Jakub Dolejs on 27/06/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import UIKit

/// Barcode parser using [Intellicheck](https://intellicheck.com) API to parse and verify the document
/// - Since: 1.0.0
@objc public class IntellicheckBarcodeParser: NSObject, BarcodeParsing, XMLParserDelegate {
    
    public enum Result: String {
        case documentProcessOK = "DocumentProcessOK",
        documentUnknown = "DocumentUnknown",
        documentBadRead = "DocumentBadRead",
        documentBadDevice = "DocumentBadDevice",
        documentFinancial = "DocumentFinancial",
        document1DDocument = "Document1DDocument",
        errorBadConfiguration = "ErrorBadConfiguration",
        unexpectedError = "UnexpectedError"
    }
    
    public enum ExtendedResultCode: String {
        case b = "B", uee = "UEE", f = "F", c = "C", t = "T", u = "U", l = "L", lawP = "LawP", lawS = "LawS", lawD = "LawD", y = "Y", ivc = "IVC", inc = "INC", ik = "IK", imb = "IMB", il = "IL", it = "IT", it1 = "IT1", it2 = "IT2", it3 = "IT3", iak = "IAK", idb = "IDB", ncf = "NCF", one = "1", rcf = "RCF", eml = "EML"
    }
    
    public class IntellicheckDocumentError: Error {
        
        let result: Result
        let extendedResultCode: ExtendedResultCode
        
        init(result: Result, extendedResultCode: ExtendedResultCode) {
            self.result = result
            self.extendedResultCode = extendedResultCode
        }
    }
    
    private let apiKey: String
    
    /// Initializer
    /// - Parameter apiKey: Intellicheck API key used to authenticate the requests
    /// - Since: 1.0.0
    @objc public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    /// Parse data in barcode and verify the result using the Intellicheck API
    /// - Parameter data: Data to parse
    /// - Returns: Parsed document data
    /// - Since: 1.0.0
    @objc public func parseData(_ data: Data) throws -> DocumentData {
        guard let intellicheckURL = Bundle(for: type(of: self)).object(forInfoDictionaryKey: "com.appliedrec.intellicheckURL") as? String else {
            throw IntellicheckParserError.invalidAPIURL
        }
        guard let url = URL(string: intellicheckURL) else {
            throw IntellicheckParserError.invalidAPIURL
        }
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
            throw IntellicheckParserError.undefinedDeviceId
        }
        let base64Data = data.base64EncodedString()
        guard let data = [
                "device_os": "iOS",
                "device_id": deviceId,
                "data": base64Data
            ].map({ $0+"="+$1 }).joined(separator: "&").data(using: .utf8) else {
            throw IntellicheckParserError.httpBodyError
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(self.apiKey, forHTTPHeaderField: "X-ApiKey")
        request.addValue(String(format: "%d", data.count), forHTTPHeaderField: "Content-Length")
        let session = URLSession(configuration: .ephemeral)
        let semaphore = DispatchSemaphore(value: 0)
        var parserError: Error? = nil
        var props = [String:String]()
        let task = session.dataTask(with: request) { data, response, err in
            defer {
                semaphore.signal()
            }
            if err != nil {
                parserError = err!
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                parserError = IntellicheckParserError.invalidAPIResponse
                return
            }
            if statusCode == 403 {
                parserError = IntellicheckParserError.invalidAPIKey
                return
            }
            guard statusCode == 200 else {
                parserError = IntellicheckParserError.invalidAPIResponseCode
                return
            }
            guard let responseData = data else {
                parserError = IntellicheckParserError.invalidResponseData
                return
            }
            do {
                guard var responseObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:[String:Any]] else {
                    parserError = IntellicheckParserError.parsingError
                    return
                }
                responseObject["document_t"]?.removeValue(forKey: "$")
                if let testCard = responseObject["document_t"]?["testCard"] as? Bool {
                    responseObject["document_t"]!["testCard"] = testCard ? "Yes" : "No"
                }
                guard let parsed = responseObject as? [String:[String:String]] else {
                    parserError = IntellicheckParserError.parsingError
                    return
                }
                if let docT = parsed["document_t"] {
                    props = docT
                }
            } catch {
                parserError = error
            }
        }
        task.resume()
        guard semaphore.wait(timeout: .now()+30.0) == .success else {
            throw IntellicheckParserError.timeout
        }
        var result: Result = .documentProcessOK
        var extendedResultCode: ExtendedResultCode = .b
        let docData = IntellicheckDocumentData()
        for (key,val) in props {
            if val.trimmingCharacters(in: .whitespaces).isEmpty {
                continue
            }
            switch key.lowercased() {
            case "processresult":
                docData.setValue(DataField(description: "Process result", originalValue: val, parsedValue: val), forField: "processresult")
                result = Result(rawValue: val) ?? .documentProcessOK
            case "extendedresultcode":
                extendedResultCode = ExtendedResultCode(rawValue: val) ?? .b
                docData.setValue(DataField(description: "Extended result code", originalValue: val, parsedValue: val), forField: "extendedresultcode")
            case "firstname":
                docData.setValue(DataField(description: "First name", originalValue: val, parsedValue: val), forField: "firstname")
            case "middlename":
                docData.setValue(DataField(description: "Middle name", originalValue: val, parsedValue: val), forField: "middlename")
            case "lastname":
                docData.setValue(DataField(description: "Last name", originalValue: val, parsedValue: val), forField: "lastname")
            case "address1":
                docData.setValue(DataField(description: "Address 1", originalValue: val, parsedValue: val), forField: "address1")
            case "address2":
                docData.setValue(DataField(description: "Address 2", originalValue: val, parsedValue: val), forField: "address2")
            case "city":
                docData.setValue(DataField(description: "City", originalValue: val, parsedValue: val), forField: "city")
            case "state":
                docData.setValue(DataField(description: "State/province", originalValue: val, parsedValue: val), forField: "state")
            case "postalcode":
                docData.setValue(DataField(description: "Postal code", originalValue: val, parsedValue: val), forField: "postalcode")
            case "dateofbirth":
                docData.setValue(DataField(description: "Date of birth", originalValue: val, parsedValue: val), forField: "dateofbirth")
            case "heightcentimeters":
                 docData.setValue(DataField(description: "Height cm", originalValue: val, parsedValue: val), forField: "heightcentimeters")
            case "heightfeetinches":
                docData.setValue(DataField(description: "Height ft/in", originalValue: val, parsedValue: val), forField: "heightfeetinches")
            case "weightkilograms":
                docData.setValue(DataField(description: "Weight kg", originalValue: val, parsedValue: val), forField: "weightkilograms")
            case "weightpounds":
                docData.setValue(DataField(description: "Weight lb", originalValue: val, parsedValue: val), forField: "weightpounds")
            case "eyecolor":
                docData.setValue(DataField(description: "Eye color", originalValue: val, parsedValue: val), forField: "eyecolor")
            case "haircolor":
                docData.setValue(DataField(description: "Hair color", originalValue: val, parsedValue: val), forField: "haircolor")
            case "gender":
                docData.setValue(DataField(description: "Gender", originalValue: val, parsedValue: val), forField: "gender")
            case "dlidnumberformatted":
                docData.setValue(DataField(description: "Document number formatted", originalValue: val, parsedValue: val), forField: "dlidnumberformatted")
            case "endorsements":
                docData.setValue(DataField(description: "Endorsements", originalValue: val, parsedValue: val), forField: "endorsements")
            case "restrictions":
                docData.setValue(DataField(description: "Restrictions", originalValue: val, parsedValue: val), forField: "restrictions")
            case "driverclass":
                docData.setValue(DataField(description: "Driver class", originalValue: val, parsedValue: val), forField: "driverclass")
            case "organdonor":
                docData.setValue(DataField(description: "Organ donor", originalValue: val, parsedValue: val), forField: "organdonor")
            case "expirationdate":
                docData.setValue(DataField(description: "Date of expiry", originalValue: val, parsedValue: val), forField: "expirationdate")
            case "issuedate":
                docData.setValue(DataField(description: "Date of issue", originalValue: val, parsedValue: val), forField: "issuedate")
            default:
                ()
            }
        }
        if parserError != nil {
            throw parserError!
        }
        if result == .documentProcessOK {
            return docData
        } else {
            throw IntellicheckDocumentError(result: result, extendedResultCode: extendedResultCode)
        }
    }
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }
}
