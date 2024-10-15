//
//  RHR_Watch_AppTests.swift
//  RHR Watch AppTests
//
//  Created by Sarah Keller on 14.10.24.
//

import Testing
import Foundation
@testable import RHR_Watch_App

struct RHR_Watch_AppTests {

    func resetUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print("UserDefaults reset for domain: \(domain)")
    }

    @Test func setUp() async throws {
        resetUserDefaults()
    }

    @Test func testAddItem() async throws {
        resetUserDefaults()
        let model = DataModel()
        model.addItem("Test Item")
        #expect(model.items.count == 1)
        #expect(model.items[0].title == "Test Item")
        #expect(model.items[0].isCompleted == false)
    }
    
    @Test
    func testToggleCompletion() async throws {
        resetUserDefaults()
        let model = DataModel()
        model.addItem("Test Item")
        let item = model.items[0]
        model.toggleCompletion(for: item)
        #expect(model.items[0].isCompleted == true)
        model.toggleCompletion(for: item)
        #expect(model.items[0].isCompleted == false)
    }
    
    @Test
    func testPersistence() async throws {
        // Clear any existing data
        resetUserDefaults()
        print("UserDefaults reset")

        // Create a model and add an item
        let model = DataModel()
        model.addItem("Test Item")
        print("Added item: Test Item")

        // Force save to UserDefaults
        UserDefaults.standard.synchronize()
        print("UserDefaults synchronized")

        // Print all UserDefaults data for debugging
            print("All UserDefaults data:")
            for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
                print("\(key): \(value)")
            }
        
        // Create a new model to simulate app restart
        let newModel = DataModel()
        print("New model created, items: \(newModel.items)")

        // Check if the item persisted
        #expect(newModel.items.count == 1, "Expected 1 item, but found \(newModel.items.count)")
        if newModel.items.count > 0 {
            #expect(newModel.items[0].title == "Test Item", "Expected 'Test Item', but found '\(newModel.items[0].title)'")
        }
    }

    @Test
    func testDeleteItem() async throws {
        resetUserDefaults()
        let model = DataModel()
        model.addItem("Item to Delete")
        #expect(model.items.count == 1)
        
        model.deleteItem(at: IndexSet(integer: 0))
        #expect(model.items.count == 0)
        
        // Create a new model to test persistence
        let newModel = DataModel()
        #expect(newModel.items.count == 0, "Item should remain deleted after reloading")
    }

    
    
    @Test
    func testMultipleItems() async throws {
        resetUserDefaults()
        let model = DataModel()
        model.addItem("Item 1")
        model.addItem("Item 2")
        model.addItem("Item 3")
        
        #expect(model.items.count == 3)
        #expect(model.items[0].title == "Item 1")
        #expect(model.items[1].title == "Item 2")
        #expect(model.items[2].title == "Item 3")
    }
    
    @Test
    func testEmptyTitleNotAdded() async throws {
        resetUserDefaults()
        let model = DataModel()
        model.addItem("")
        #expect(model.items.count == 0)
    }
    
    @Test
    func testToggleNonexistentItem() async throws {
        resetUserDefaults()
        let model = DataModel()
        let nonexistentItem = ToDoItem(title: "Nonexistent")
        model.toggleCompletion(for: nonexistentItem)
        // This should not crash and should not change the model
        #expect(model.items.count == 0)
    }
}
