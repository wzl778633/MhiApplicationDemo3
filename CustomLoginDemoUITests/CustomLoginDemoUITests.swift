//
//  CustomLoginDemoUITests.swift
//  CustomLoginDemoUITests
//
//  Created by Tom Wang on 3/3/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import XCTest
import FirebaseCore
@testable import CustomLoginDemo
class CustomLoginDemoUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidLogin() {
        let validPassword = "Abc!123456"
        let validUserName = "wang.9363@osu.edu"
        let app = XCUIApplication()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).buttons["Login"].tap()
        
        let userNameField = app.textFields["Email"]
        userNameField.tap()
        userNameField.typeText(validUserName)
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(validPassword)
        app.buttons["Login"].tap()
        app.buttons["Contacts"].tap()
        app.navigationBars["CustomLoginDemo.AboutVC"].buttons["Main Menu"].tap()
     
    }

    
}
