//
//  BarcodeParserError.swift
//  AAMVABarcodeParser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

/// Barcode parser error
/// - Since: 1.0.0
@objc public enum BarcodeParserError: Int, Error {
    case aamvaVersionParsingError
    case subfileParserCreationError
    case numberOfEntriesParsingError
    case offsetParsingError
    case dataLengthParsingError
    case parseError, unsupportedBarcodeEncoding, emptyDocument
}
