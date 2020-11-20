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
    
    public class IntellicheckDocumentError: Error {
        
        let result: IntellicheckDocumentData.Result
        let extendedResultCode: IntellicheckDocumentData.ExtendedResultCode
        
        init(result: IntellicheckDocumentData.Result, extendedResultCode: IntellicheckDocumentData.ExtendedResultCode) {
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
        var docData: IntellicheckDocumentData?
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
                docData = try JSONDecoder().decode(IntellicheckDocumentData.self, from: responseData)
            } catch {
                parserError = error
            }
        }
        task.resume()
        guard semaphore.wait(timeout: .now()+30.0) == .success else {
            throw IntellicheckParserError.timeout
        }
        if parserError != nil {
            throw parserError!
        }
        if let doc = docData {
            return doc
        } else {
            preconditionFailure("Either parse error or document must be defined")
        }
    }
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }
}
