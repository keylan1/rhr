//
//  AppCoordinator_UI.swift
//  RHR Watch AppUITests
//
//  Created by Sarah Keller on 11.11.24.
//

import XCTest

final class AppCoordinator_UI: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testSplashScreenAppearsInitially() {
        let app = XCUIApplication()
        app.launch()
            
        // Verify that the splash screen is displayed
        let splashScreen = app.staticTexts["dRHR"]
        let loadingIndicator = app.activityIndicators["LoadingIndicator"]
        
        XCTAssertTrue(splashScreen.exists)
        //XCTAssertTrue(app.images["heart"].exists)
        XCTAssertTrue(loadingIndicator.exists)
    }

    //May not pass in GitHub without using the mock.
    
    func testTransitionToMainInterface() throws {
        let app = XCUIApplication()
        app.launch()
        
        print(app.debugDescription)
        
        let splashScreen = app.staticTexts["dRHR"]
        let appInterface = app.staticTexts["Welcome!"]
        //let dailyRHR = app.staticTexts["Daily RHR:"]
        // Wait for splash screen to disappear
        XCTAssert(splashScreen.waitForNonExistence(timeout: 4))
        
        // Verify that the main interface is now displayed
        XCTAssertTrue(appInterface.exists)
        XCTAssertTrue(app.staticTexts["DailyRHRLabel"].waitForExistence(timeout: 3), "'Daily RHR:' label should be displayed.")
            
        XCTAssertTrue(app.staticTexts["StatusLabel"].waitForExistence(timeout: 3), "'Status:' label should be displayed.")
        //XCTAssertTrue(app.staticTexts["CounterLabel"].waitForExistence(timeout: 3), "'Counter:' label should be displayed.")
    }
    
    func testValuesSeen() throws {
        let app = XCUIApplication()
        app.launch()
        
        print(app.debugDescription)

        let appInterface = app.staticTexts["Welcome!"]
        let dailyLabel = app.staticTexts["DailyRHRLabel"]
        let splashScreen = app.staticTexts["dRHR"]
        let statusLabel = app.staticTexts["StatusLabel"]
        // Wait for splash screen to disappear
        XCTAssert(splashScreen.waitForNonExistence(timeout: 4))
        // Verify that the main interface is now displayed
        XCTAssertTrue(appInterface.exists)
        XCTAssertTrue(dailyLabel.waitForExistence(timeout: 3), "'Daily RHR:' label should be displayed.")
        XCTAssertEqual(dailyLabel.label, "Daily RHR: 65")
            
        XCTAssertTrue(statusLabel.waitForExistence(timeout: 3), "'Status:' label should be displayed.")
        XCTAssertEqual(statusLabel.label, "Status: Elevated" )

    }
}
