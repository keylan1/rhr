//
//  RHR_Watch_AppUITests.swift
//  RHR Watch AppUITests
//
//  Created by Sarah Keller on 14.10.24.
//

import XCTest


class RHR_Watch_AppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

    func clearAll() {
        let taskItems = app.staticTexts.matching(identifier: "Task")
        
        while taskItems.firstMatch.exists {
            let item = taskItems.firstMatch
            
            let frame = item.frame
            
            // Perform the swipe left gesture
            item.swipeLeft()
            
            // Calculate the position of the delete area (right edge of the screen)
            let deleteX = app.frame.maxX - 10 // 10 points from the right edge
            let deleteY = frame.midY
            
            // Tap the delete button
            let deleteCoordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
                .withOffset(CGVector(dx: deleteX, dy: deleteY))
            deleteCoordinate.tap()
            
            // Wait a moment for the deletion to complete
            sleep(1)
        }
    }
    
    func testAddNewItem() throws {
        clearAll()
        
        // Tap the plus button on the main screen
        let plusButton = app.buttons["plus"]
        XCTAssertTrue(plusButton.waitForExistence(timeout: 5), "Plus button does not exist")
        plusButton.tap()
        print("Plus button tapped")
        
        // Wait for the text field to appear in AddItemView
        let textField = app.textFields["New item"]
        XCTAssertTrue(textField.waitForExistence(timeout: 5), "Text field did not appear")
        print("Text field appeared")
        
        // Tap the text field to open the keyboard screen
        textField.tap()
        print("Text field tapped, should open keyboard screen")
        
        // Wait for the keyboard to appear
        let keyboard = app.keyboards.firstMatch
        XCTAssertTrue(keyboard.waitForExistence(timeout: 10), "Keyboard did not appear")
        print("Keyboard appeared")
        
        let newItemTitle = "Task"
        for char in newItemTitle {
            
            if char == " " {
                keyboard.keys["Leerzeichen"].tap() // "Leerzeichen" is "space" in German
            } else {
                keyboard.keys[String(char)].tap()
            }
            Thread.sleep(forTimeInterval: 0.5) // Wait a bit between key taps
        }
        print("Attempted to type: \(newItemTitle)")
        // Tap the "Done"/"Fertig" button on the keyboard
        let doneButton = app.buttons["Fertig"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 5))
        doneButton.tap()
        // "Fertig" is "Done" in German
        print("Done/Fertig button tapped")
        
        // Wait for AddItemView to reappear
        XCTAssertTrue(textField.waitForExistence(timeout: 5), "Did not return to AddItemView")
        print("Returned to AddItemView")
        
        // Tap the Add button in AddItemView
        let addButton = app.buttons["Add Task"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add button does not exist")
        addButton.tap()
        print("Add button tapped")
        
        // Verify that we're back on the main view
        XCTAssertTrue(plusButton.waitForExistence(timeout: 5), "Did not return to main view")
        
        // Verify the new item appears in the list
        let newItemText = app.staticTexts[newItemTitle]
        XCTAssertTrue(newItemText.waitForExistence(timeout: 5), "New item '\(newItemTitle)' not found in the list")
        print("New item '\(newItemTitle)' found in the list")
    }
        
   func testToggleItemCompletion() throws {
            // First, add an item
            clearAll()
            try testAddNewItem()
            
            // Now, tap the item to toggle its completion
            let item = app.staticTexts["Task"]
            XCTAssertTrue(item.exists, "Added item does not exist")
            item.tap()
            
            // Verify the item is marked as completed
            let checkmark = app.images["checkmark"]
            XCTAssertTrue(checkmark.waitForExistence(timeout: 2), "Checkmark appears after toggling completion")
            
            // Tap again to un-complete
            let itemLeftSide = item.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.5))
            itemLeftSide.tap()
            XCTAssertTrue(checkmark.waitForNonExistence(timeout: 2), "Checkmark no longer appears after toggling completion off")
        }
        
    func testSwipeToDelete() throws {
            // First, add an item
            clearAll()
            try testAddNewItem()
            
            // Find the added item
            let addedItem = app.staticTexts["Task"]
            XCTAssertTrue(addedItem.exists, "Added item does not exist")
            
            let frame = addedItem.frame
            
            // Perform the swipe left gesture
            addedItem.swipeLeft()
            
            // Calculate the position of the delete area (right edge of the screen)
            let deleteX = app.frame.maxX - 10 // 10 points from the right edge
            let deleteY = frame.midY
            
            // Tap the delete button
            let deleteCoordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
                .withOffset(CGVector(dx: deleteX, dy: deleteY))
            deleteCoordinate.tap()
            
            //sleep(1)
            
            // Verify the item has been deleted
            XCTAssertFalse(addedItem.exists, "Item should have been deleted")
        }
    }
