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
        guard let bundleId = Bundle.main.bundleIdentifier else {
            throw IntellicheckParserError.undefinedBundleIdentifier
        }
        let deviceName = UIDevice.current.name
        let base64Data = data.base64EncodedString()
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "device_os", value: "iOS"),
            URLQueryItem(name: "device_id", value: deviceId),
            URLQueryItem(name: "device_name", value: deviceName),
            URLQueryItem(name: "password", value: self.apiKey),
            URLQueryItem(name: "app_id", value: bundleId),
            URLQueryItem(name: "data", value: base64Data)
        ]
        guard let data = bodyComponents.query?.data(using: .utf8) else {
            throw IntellicheckParserError.httpBodyError
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
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
                docData.setValue(DataField(description: "Process result", originalValue: val, parsedValue: val), forEntryID: "processresult")
                result = Result(rawValue: val) ?? .documentProcessOK
            case "extendedresultcode":
                extendedResultCode = ExtendedResultCode(rawValue: val) ?? .b
                docData.setValue(DataField(description: "Extended result code", originalValue: val, parsedValue: val), forEntryID: "extendedresultcode")
            case "firstname":
                docData.setValue(DataField(description: "First name", originalValue: val, parsedValue: val), forEntryID: "firstname")
            case "middlename":
                docData.setValue(DataField(description: "Middle name", originalValue: val, parsedValue: val), forEntryID: "middlename")
            case "lastname":
                docData.setValue(DataField(description: "Last name", originalValue: val, parsedValue: val), forEntryID: "lastname")
            case "address1":
                docData.setValue(DataField(description: "Address 1", originalValue: val, parsedValue: val), forEntryID: "address1")
            case "address2":
                docData.setValue(DataField(description: "Address 2", originalValue: val, parsedValue: val), forEntryID: "address2")
            case "city":
                docData.setValue(DataField(description: "City", originalValue: val, parsedValue: val), forEntryID: "city")
            case "state":
                docData.setValue(DataField(description: "State/province", originalValue: val, parsedValue: val), forEntryID: "state")
            case "postalcode":
                docData.setValue(DataField(description: "Postal code", originalValue: val, parsedValue: val), forEntryID: "postalcode")
            case "dateofbirth":
                docData.setValue(DataField(description: "Date of birth", originalValue: val, parsedValue: val), forEntryID: "dateofbirth")
            case "heightcentimeters":
                 docData.setValue(DataField(description: "Height cm", originalValue: val, parsedValue: val), forEntryID: "heightcentimeters")
            case "heightfeetinches":
                docData.setValue(DataField(description: "Height ft/in", originalValue: val, parsedValue: val), forEntryID: "heightfeetinches")
            case "weightkilograms":
                docData.setValue(DataField(description: "Weight kg", originalValue: val, parsedValue: val), forEntryID: "weightkilograms")
            case "weightpounds":
                docData.setValue(DataField(description: "Weight lb", originalValue: val, parsedValue: val), forEntryID: "weightpounds")
            case "eyecolor":
                docData.setValue(DataField(description: "Eye color", originalValue: val, parsedValue: val), forEntryID: "eyecolor")
            case "haircolor":
                docData.setValue(DataField(description: "Hair color", originalValue: val, parsedValue: val), forEntryID: "haircolor")
            case "gender":
                docData.setValue(DataField(description: "Gender", originalValue: val, parsedValue: val), forEntryID: "gender")
            case "dlidnumberformatted":
                docData.setValue(DataField(description: "Document number formatted", originalValue: val, parsedValue: val), forEntryID: "dlidnumberformatted")
            case "endorsements":
                docData.setValue(DataField(description: "Endorsements", originalValue: val, parsedValue: val), forEntryID: "endorsements")
            case "restrictions":
                docData.setValue(DataField(description: "Restrictions", originalValue: val, parsedValue: val), forEntryID: "restrictions")
            case "driverclass":
                docData.setValue(DataField(description: "Driver class", originalValue: val, parsedValue: val), forEntryID: "driverclass")
            case "organdonor":
                docData.setValue(DataField(description: "Organ donor", originalValue: val, parsedValue: val), forEntryID: "organdonor")
            case "expirationdate":
                docData.setValue(DataField(description: "Date of expiry", originalValue: val, parsedValue: val), forEntryID: "expirationdate")
            case "issuedate":
                docData.setValue(DataField(description: "Date of issue", originalValue: val, parsedValue: val), forEntryID: "issuedate")
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
