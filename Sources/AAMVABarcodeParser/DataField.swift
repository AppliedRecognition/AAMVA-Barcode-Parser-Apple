//
//  DataField.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

/// Representation of an document entry
/// - Since: 1.0.0
public struct DataField {
    
    /// Description (to be shown to the user)
    /// - Since: 1.0.0
    public let description: String
    /// Original value as extracted from the barcode
    /// - Since: 1.0.0
    public let originalValue: String
    /// Parsed value
    /// - Since: 1.0.0
    public let parsedValue: String
    
    /// Initializer
    /// - Parameters:
    ///   - description: Description (to be shown to the user)
    ///   - originalValue: Original value as extracted from the barcode
    ///   - parsedValue: Parsed value
    /// - Since: 1.2.0
    public init(description: String, originalValue: String, parsedValue: String) {
        self.description = description
        self.originalValue = originalValue
        self.parsedValue = parsedValue
    }
}
