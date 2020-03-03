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
        XCTAssertFalse(app.staticTexts["The password is invalid or the user does not have a password."].exists)
        XCTAssertFalse(app.staticTexts["There is no user record corresponding to this identifier. The user may have been deleted."].exists)
        XCTAssertFalse(app.staticTexts["The email address is badly formatted."].exists)


        
     
    }
    func testInvalidLogin1() {
        let validPassword = "abc!123456"
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
        XCTAssert(app.staticTexts["The password is invalid or the user does not have a password."].exists)
        XCTAssertFalse(app.staticTexts["There is no user record corresponding to this identifier. The user may have been deleted."].exists)
        XCTAssertFalse(app.staticTexts["The email address is badly formatted."].exists)
                         
    }
    func testInvalidLogin2() {
        let validPassword = "Abc!123456"
        let validUserName = "wang.9363@osu"
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
        XCTAssertFalse(app.staticTexts["The password is invalid or the user does not have a password."].exists)
        XCTAssert(app.staticTexts["There is no user record corresponding to this identifier. The user may have been deleted."].exists)
        XCTAssertFalse(app.staticTexts["The email address is badly formatted."].exists)
                         
    }
    func testInvalidLogin3() {
        let validPassword = "Abc!123456"
        let validUserName = "wang.9363"
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
        XCTAssertFalse(app.staticTexts["The password is invalid or the user does not have a password."].exists)
        XCTAssertFalse(app.staticTexts["There is no user record corresponding to this identifier. The user may have been deleted."].exists)
        XCTAssert(app.staticTexts["The email address is badly formatted."].exists)
                         
    }
    
    func testClickTab(){
        let app = XCUIApplication()
        
        testValidLogin()
        app.buttons["Contacts"].tap()
        let mainMenuButton = app.navigationBars["CustomLoginDemo.AboutVC"].buttons["Main Menu"]
        mainMenuButton.tap()
        app.buttons["Jobs"].tap()
        mainMenuButton.tap()
        app.buttons["Links"].tap()
        mainMenuButton.tap()
        app.buttons["Misc"].tap()
        mainMenuButton.tap()
    }
    
    func testSignOut(){
        let app = XCUIApplication()
        
        testValidLogin()
        
        app.navigationBars["CustomLoginDemo.HomeView"].buttons["Sign Out"].tap()
        XCTAssert(app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.exists)
        

    }
    func testAdd() {
        
        let app = XCUIApplication()
        
        testValidLogin()
        app.buttons["Contacts"].tap()
        XCTAssert(app.navigationBars["CustomLoginDemo.AboutVC"].buttons["plus"].exists)
        let plusButton = app.navigationBars["CustomLoginDemo.AboutVC"].buttons["plus"]
        plusButton.tap()
        XCTAssert(app.textFields["Name"].exists)
        XCTAssert(app.textFields["Description"].exists)
        XCTAssert(app.textFields["Link(check automatically)"].exists)
        XCTAssert(app.buttons["Submit"].exists)
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("testName")
        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        descriptionTextField.typeText("test description")
        

        let linkTextField = app.textFields["Link(check automatically)"]
        linkTextField.tap()
        linkTextField.typeText("www.google.com")
        
        let submitButton = app.buttons["Submit"]
        submitButton.tap()
        let elementsQuery = app.alerts["Success!"].scrollViews.otherElements
        
        let okButton = elementsQuery.buttons["OK"]
        okButton.tap()
        
        let tablesQuery2 = app.tables
        XCTAssert(tablesQuery2.staticTexts["testName"].exists)
        XCTAssert(tablesQuery2.staticTexts["test description"].exists)
        

                
        
    }

    
}
