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

    func tabletest() {
        
    }

    
}
