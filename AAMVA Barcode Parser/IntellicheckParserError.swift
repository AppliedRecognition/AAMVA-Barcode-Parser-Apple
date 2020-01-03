//
//  IntellicheckParserError.swift
//  AAMVABarcodeParser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

@objc public enum IntellicheckParserError: Int, Error {
    case invalidAPIURL
    case undefinedDeviceId
    case httpBodyError
    case invalidAPIResponse
    case invalidAPIKey
    case invalidAPIResponseCode
    case invalidResponseData
    case parsingError
    case timeout
    case unknownError
    case undefinedBundleIdentifier
}
