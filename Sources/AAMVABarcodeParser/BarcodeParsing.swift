//
//  BarcodeParsing.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 19/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

/// Barcode parsing protocol
/// - Since: 1.0.0
@objc public protocol BarcodeParsing {
    
    /// Parse barcode data
    /// - Parameter data: Data to parse
    /// - Returns: Parsed document data
    /// - Since: 1.0.0
    func parseData(_ data: Data) throws -> DocumentData
}
