//
//  CustomLoginDemoTests.swift
//  CustomLoginDemoTests
//
//  Created by Tom Wang on 3/3/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import XCTest
import FirebaseCore
import Firebase
@testable import CustomLoginDemo

class CustomLoginDemoTests: XCTestCase {
    var systemUnderTest: AboutVC!
    override func setUp() {
        super.setUp()
        systemUnderTest = AboutVC()
    }

    override func tearDown() {
        systemUnderTest = nil
        super.tearDown()
    }

    func testInvalidPassword() {
        XCTAssertFalse(Utilities.isPasswordValid("abcd"))
        XCTAssertFalse(Utilities.isPasswordValid("Abc123456"))
        XCTAssertFalse(Utilities.isPasswordValid("abc123456"))
        XCTAssertFalse(Utilities.isPasswordValid("A-2"))
        XCTAssertFalse(Utilities.isPasswordValid("nfdif"))
        
        
    }
    
    func testValidPassword()
    {
        XCTAssert(Utilities.isPasswordValid("Abc!123456"))
        XCTAssert(Utilities.isPasswordValid("Ydq-980304"))
        XCTAssert(Utilities.isPasswordValid("ydq-980304"))
        XCTAssert(Utilities.isPasswordValid("Gc_13869601298"))
    }
    
    func testGoodURL()
    {
        XCTAssert(Utilities.isGoodUrl(urlString: "www.google.com"))
        XCTAssert(Utilities.isGoodUrl(urlString: "www.google.com"))
        XCTAssert(Utilities.isGoodUrl(urlString: "https://www.google.com"))
        
    }
    
    func testBadURL(){
        XCTAssertFalse(Utilities.isGoodUrl(urlString: "www.google"))
        XCTAssertFalse(Utilities.isGoodUrl(urlString: "gdjaskp"))
    }
}
