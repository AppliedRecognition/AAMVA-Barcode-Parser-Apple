//
//  DocumentData.swift
//  AAMVA Barcode Paser
//
//  Created by Jakub Dolejs on 19/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

/// Parsed document data
/// - Since: 1.0.0
@objc open class DocumentData: NSObject {
    
    /// `true` if the document contains no values
    /// - Since: 1.0.0
    @objc public var isEmpty: Bool {
        return self.fields.isEmpty
    }
    
    /// First name of the document holder
    /// - Since: 1.0.0
    @objc open var firstName: String? {
        nil
    }
    /// Last name of the document holder
    /// - Since: 1.0.0
    @objc open var lastName: String? {
        nil
    }
    /// Address of the document holder
    /// - Since: 1.0.0
    @objc open var address: String? {
        nil
    }
    /// Document holder's date of birth
    /// - Since: 1.0.0
    @objc open var dateOfBirth: String? {
        nil
    }
    /// Document date of expiry
    /// - Since: 1.0.0
    @objc open var dateOfExpiry: String? {
        nil
    }
    /// Document date of issue
    /// - Since: 1.0.0
    @objc open var dateOfIssue: String? {
        nil
    }
    /// Document number
    /// - Since: 1.0.0
    @objc open var documentNumber: String? {
        nil
    }
    /// Document holder's sex
    /// - Since: 1.0.0
    @objc open var sex: String? {
        nil
    }
    /// Raw barcode data from which the document data was parsed
    /// - Since: 1.0.0
    @objc public var rawData: Data?
    /// Subscript access to parsed entry values
    /// - Since: 1.0.0
    @objc public subscript(id: String) -> String? {
        return fields[id]?.parsedValue
    }
    
    /// Map (dictionary) of entry descriptions and their parsed values
    /// - Since: 1.0.0
    @objc public var entryMap: [String:String] {
        var dict: [String:String] = [:]
        var iterator = self.fields.values.makeIterator()
        while let field = iterator.next() {
            dict[field.description] = field.parsedValue
        }
        return dict
    }
    
    /// Array of all parsed entries
    ///
    /// The array contains tuples with entry keys and values.
    /// - Since: 1.0.0 
    public var entries: [(key:String,value:String)] {
        return self.fields.map({ (key:$0.value.description, value:$0.value.parsedValue) })
    }
    
    var fields: [String:DataField] = [:]
    
    func appendFields(from other: DocumentData) {
        for (id, field) in other.fields {
            if !self.fields.keys.contains(id) {
                self.fields[id] = field
            }
        }
    }
    
    /// Set value for entry
    /// - Parameters:
    ///   - value: Value
    ///   - id: Entry identifier
    /// - Since: 1.1.0
    public func setValue(_ value: DataField, forEntryID id: String) {
        self.fields[id] = value
    }
}
