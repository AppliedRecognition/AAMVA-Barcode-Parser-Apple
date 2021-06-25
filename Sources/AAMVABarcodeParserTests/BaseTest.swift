//
//  BaseTest.swift
//  AAMVA Barcode ParserTests
//
//  Created by Jakub Dolejs on 18/11/2020.
//  Copyright © 2020 Applied Recognition Inc. All rights reserved.
//

import XCTest

class BaseTest: XCTestCase {

    func dataFromResource(_ resource: String) throws -> Data {
        var resourceURL: URL?
        for bundle in Bundle.allBundles {
            guard let url = bundle.url(forResource: resource, withExtension: "txt") else {
                continue
            }
            resourceURL = url
        }
        guard let url = resourceURL else {
            throw NSError(domain: self.errorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey:"Test file not found"])
        }
        return try Data(contentsOf: url)
    }
    
    let errorDomain = "com.appliedrec.AAMVABarcodeParser"

}
