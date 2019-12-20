//
//  AAMVA_Barcode_PaserTests.swift
//  AAMVA Barcode PaserTests
//
//  Created by Jakub Dolejs on 19/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import XCTest
@testable import AAMVABarcodeParser

class AAMVA_Barcode_ParserTests: XCTestCase {
    
    let parser = AAMVABarcodeParser()
    
    func testBarcode1() {
        do {
            let docData = try self.documentDataFromResource("1")
            XCTAssertEqual(docData.firstName, "ROBERTO N")
            XCTAssertEqual(docData.lastName, "BRONSTON")
            outputEntriesInDocumentData(docData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testBarcode2() {
        do {
            let docData = try self.documentDataFromResource("2")
            XCTAssertEqual(docData.firstName, "MICHAEL")
            XCTAssertEqual(docData.lastName, "SAMPLE")
            outputEntriesInDocumentData(docData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testBarcode3() {
        do {
            let docData = try self.documentDataFromResource("3")
            XCTAssertEqual(docData.firstName, "STAN CONSTANTINE")
            XCTAssertEqual(docData.lastName, "OGRADY")
            outputEntriesInDocumentData(docData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testBarcode4() {
        do {
            let docData = try self.documentDataFromResource("4")
            XCTAssertEqual(docData.firstName, "ABDULAH,M")
            XCTAssertEqual(docData.lastName, "ABBOTT")
            outputEntriesInDocumentData(docData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    private func outputEntriesInDocumentData(_ documentData: DocumentData) {
        NSLog(documentData.entries.map({ $0.0+" = "+$0.1 }).joined(separator: "\n"))
    }
    
    private func dataFromResource(_ resource: String) throws -> Data {
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

    private func documentDataFromResource(_ resource: String) throws -> DocumentData {
        let data = try self.dataFromResource(resource)
        let parser = AAMVABarcodeParser()
        return try parser.parseData(data)
    }
    
    private let errorDomain = "com.appliedrec.AAMVABarcodeParser"
}
