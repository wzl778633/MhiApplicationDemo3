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
    

    
    func testSignOut(){
        let app = XCUIApplication()
        
        testValidLogin()
        
        app.navigationBars["CustomLoginDemo.HomeView"].buttons["Sign Out"].tap()
        XCTAssert(app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.exists)
        

    }
    func testAddMeeting() {
        
        let app = XCUIApplication()
        
        testValidLogin()
        sleep(1)
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Meeting"].tap()

        app.navigationBars["CustomLoginDemo.ContactVC"].buttons["plus"].tap()
        let meetingNameTextField = app.textFields["Meeting Name"]
        meetingNameTextField.tap()
        meetingNameTextField.typeText("test")
        let meetingDateTextField = app.textFields["Meeting Date"]
        meetingDateTextField.tap()
        meetingDateTextField.tap()
        
        let app2 = app
        app2.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["Today"]/*[[".pickers.pickerWheels[\"Today\"]",".pickerWheels[\"Today\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.buttons["Select Invitees"].tap()
        
        let tablesQuery = app2.tables
        tablesQuery.staticTexts["Dongqi Yin"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Songtao Wang"]/*[[".cells.staticTexts[\"Songtao Wang\"]",".staticTexts[\"Songtao Wang\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        

        app.navigationBars["CustomLoginDemo.InviteVC"].buttons["Done"].tap()
        app.buttons["Submit"].tap()
        
        let elementsQuery = app.alerts["Success!"].scrollViews.otherElements
        elementsQuery.staticTexts["Success!"].tap()
        elementsQuery.buttons["OK"].tap()

                
        
    }
    
    func testAddMeetingNoName() {
        
        let app = XCUIApplication()
        
        testValidLogin()
        sleep(1)
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Meeting"].tap()

        app.navigationBars["CustomLoginDemo.ContactVC"].buttons["plus"].tap()
        let meetingDateTextField = app.textFields["Meeting Date"]
        meetingDateTextField.tap()
        meetingDateTextField.tap()
        
        let app2 = app
        app2.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["Today"]/*[[".pickers.pickerWheels[\"Today\"]",".pickerWheels[\"Today\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.buttons["Select Invitees"].tap()
        
        let tablesQuery = app2.tables
        tablesQuery.staticTexts["Dongqi Yin"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Songtao Wang"]/*[[".cells.staticTexts[\"Songtao Wang\"]",".staticTexts[\"Songtao Wang\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        

        app.navigationBars["CustomLoginDemo.InviteVC"].buttons["Done"].tap()
        app.buttons["Submit"].tap()
    
        
        let pleaseFillInAllFieldsStaticText = app.staticTexts["Please fill in all fields. "]
        XCTAssert(pleaseFillInAllFieldsStaticText.exists)
        pleaseFillInAllFieldsStaticText.tap()
                
        
    }
    
    func testAddMeetingNoInvitee() {
        
        let app = XCUIApplication()
        
        testValidLogin()
        sleep(1)
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Meeting"].tap()

        app.navigationBars["CustomLoginDemo.ContactVC"].buttons["plus"].tap()
        let meetingNameTextField = app.textFields["Meeting Name"]
        meetingNameTextField.tap()
        meetingNameTextField.typeText("test")
        let meetingDateTextField = app.textFields["Meeting Date"]
        meetingDateTextField.tap()
        meetingDateTextField.tap()
        
        let app2 = app
        app2.datePickers/*@START_MENU_TOKEN@*/.pickerWheels["Today"]/*[[".pickers.pickerWheels[\"Today\"]",".pickerWheels[\"Today\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        

        app.buttons["Submit"].tap()
    
        
        let pleaseFillInAllFieldsStaticText = app.staticTexts["Error! Must at least select one invitee"]
        XCTAssert(pleaseFillInAllFieldsStaticText.exists)
        pleaseFillInAllFieldsStaticText.tap()

    }
    
    func testAddChatRoom() {
        
        let app = XCUIApplication()
        
        testValidLogin()
        sleep(1)
        app.tabBars.buttons["Chatting"].tap()
        app.navigationBars["CustomLoginDemo.chatMenuVC"].buttons["plus"].tap()
        let meetingNameTextField = app.textFields["Room Name (Optional)"]
        meetingNameTextField.tap()
        meetingNameTextField.typeText("test")

        app.buttons["Select Invitees"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Dongqi Yin"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Songtao Wang"]/*[[".cells.staticTexts[\"Songtao Wang\"]",".staticTexts[\"Songtao Wang\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        app.navigationBars["CustomLoginDemo.InviteVC"].buttons["Done"].tap()

        app.buttons["Submit"].tap()
    
        


    }
    
    func testAddChatRoomNoName() {
        
        let app = XCUIApplication()
        
        testValidLogin()
        sleep(1)
        app.tabBars.buttons["Chatting"].tap()

        app.navigationBars["CustomLoginDemo.chatMenuVC"].buttons["plus"].tap()

        app.buttons["Select Invitees"].tap()
        

        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Dongqi Yin"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Songtao Wang"]/*[[".cells.staticTexts[\"Songtao Wang\"]",".staticTexts[\"Songtao Wang\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["CustomLoginDemo.InviteVC"].buttons["Done"].tap()


        app.buttons["Submit"].tap()
    
        


    }
    func testAddChatRoomNoInvitee() {
        
        let app = XCUIApplication()
        
        testValidLogin()
        sleep(1)
        XCTAssert(app.tabBars.buttons["Chatting"].exists)
        app.tabBars.buttons["Chatting"].tap()

        app.navigationBars["CustomLoginDemo.chatMenuVC"].buttons["plus"].tap()

        


        app.buttons["Submit"].tap()
    
        
        let pleaseFillInAllFieldsStaticText = app.staticTexts["Error! Must at least select one invitee"]
        XCTAssert(pleaseFillInAllFieldsStaticText.exists)
        pleaseFillInAllFieldsStaticText.tap()

    }
    
}
