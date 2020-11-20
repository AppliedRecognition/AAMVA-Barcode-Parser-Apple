//
//  Intellicheck_Barcode_ParserTests.swift
//  AAMVA Barcode ParserTests
//
//  Created by Jakub Dolejs on 17/11/2020.
//  Copyright © 2020 Applied Recognition Inc. All rights reserved.
//

import XCTest
import Foundation
@testable import AAMVABarcodeParser

class Intellicheck_Barcode_ParserTests: BaseTest {
    
    var parser: IntellicheckBarcodeParser!
    
    override func setUpWithError() throws {
        self.parser = IntellicheckBarcodeParser(apiKey: "0736fab47918a9c48144dc4cd4186e35a16a5d25166bbe37f4d9005ecfee074a")
    }
    
    func testBarcode1() throws {
        let docData = try self.documentDataFromResource("1")
        XCTAssertEqual(docData.firstName?.uppercased(), "ROBERTO")
        XCTAssertEqual(docData.lastName?.uppercased(), "BRONSTON")
    }
    
    func testBarcode2() throws {
        let docData = try self.documentDataFromResource("2")
        XCTAssertEqual(docData.resultCode, .documentUnknown)
    }
    
    func testBarcode3() throws {
        let docData = try self.documentDataFromResource("3")
        XCTAssertEqual(docData.firstName?.uppercased(), "STAN")
        XCTAssertEqual(docData.lastName?.uppercased(), "OGRADY")
    }
    
    func testBarcode4() throws {
        let docData = try self.documentDataFromResource("4")
        XCTAssertEqual(docData.resultCode, .documentUnknown)
    }
    
    private func documentDataFromResource(_ resource: String) throws -> IntellicheckDocumentData {
        let data = try self.dataFromResource(resource)
        return try self.parser.parseData(data) as! IntellicheckDocumentData
    }
}
