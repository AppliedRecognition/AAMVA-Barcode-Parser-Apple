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
    
    func testBarcode1() {
        do {
            let docData = try self.documentDataFromBase64EncodedResource("1", subdirectory: "barcode_data")
            XCTAssertEqual(docData.firstName, "ROBERTO N")
            XCTAssertEqual(docData.lastName, "BRONSTON")
            outputEntriesInDocumentData(docData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testBarcode2() {
        do {
            let docData = try self.documentDataFromBase64EncodedResource("2", subdirectory: "barcode_data")
            XCTAssertEqual(docData.firstName, "MICHAEL")
            XCTAssertEqual(docData.lastName, "SAMPLE")
            outputEntriesInDocumentData(docData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testBarcode3() {
        do {
            let docData = try self.documentDataFromBase64EncodedResource("3", subdirectory: "barcode_data")
            XCTAssertEqual(docData.firstName, "STAN CONSTANTINE")
            XCTAssertEqual(docData.lastName, "OGRADY")
            outputEntriesInDocumentData(docData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testBarcode4() {
        do {
            let docData = try self.documentDataFromBase64EncodedResource("4", subdirectory: "barcode_data")
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
    
    private func dataFromResource(_ resource: String, subdirectory: String) throws -> Data {
        guard let url = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "txt", subdirectory: subdirectory) else {
            throw NSError(domain: self.errorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey:"Test file not found"])
        }
        return try Data(contentsOf: url)
    }

    private func documentDataFromBase64EncodedResource(_ resource: String, subdirectory: String) throws -> DocumentData {
        let data = try self.dataFromResource(resource, subdirectory: subdirectory)
        let parser = AAMVABarcodeParser()
        return try parser.parseData(data)
    }
    
    private let errorDomain = "com.appliedrec.AAMVABarcodeParser"
}
