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
@objc public class DocumentData: NSObject {
    
    /// `true` if the document contains no values
    /// - Since: 1.0.0
    @objc public var isEmpty: Bool {
        return self.fields.isEmpty
    }
    
    /// First name of the document holder
    /// - Since: 1.0.0
    @objc public var firstName: String?
    /// Last name of the document holder
    /// - Since: 1.0.0
    @objc public var lastName: String?
    /// Address of the document holder
    /// - Since: 1.0.0
    @objc public var address: String?
    /// Document holder's date of birth
    /// - Since: 1.0.0
    @objc public var dateOfBirth: String?
    /// Document date of expiry
    /// - Since: 1.0.0
    @objc public var dateOfExpiry: String?
    /// Document date of issue
    /// - Since: 1.0.0
    @objc public var dateOfIssue: String?
    /// Document number
    /// - Since: 1.0.0
    @objc public var documentNumber: String?
    /// Document holder's sex
    /// - Since: 1.0.0
    @objc public var sex: String?
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
        self.updateCommonFields()
    }
    
    func setValue(_ value: DataField, forField id: String) {
        self.fields[id] = value
        self.updateCommonFields()
    }
    
    func updateCommonFields() {        
    }
}
