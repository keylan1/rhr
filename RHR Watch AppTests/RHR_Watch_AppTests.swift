//
//  RHR_Watch_AppTests.swift
//  RHR Watch AppTests
//
//  Created by Sarah Keller on 14.10.24.
//

import Testing
import Foundation
@testable import RHR_Watch_App

extension DataModel {
    convenience init(forTesting: Bool, domain: String = "TestSuite") {
        let defaults = forTesting ? UserDefaults(suiteName: domain)! : .standard
        self.init(defaults: defaults)
        }
}

struct RHR_Watch_AppTests {

    func resetTestDefaults(domain: String = "TestSuite") {
        let defaults = UserDefaults(suiteName: domain)!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        Thread.sleep(forTimeInterval: 1.0)
        print("Test UserDefaults reset")
    }

    func resetList(domain: String = "TestSuite") {
        let model = DataModel(forTesting: true, domain: domain)
        model.items = []
        model.saveItems()
        UserDefaults(suiteName: domain)!.synchronize()
    }

    @Test func testAddItem() throws {
        resetTestDefaults(domain: "TestSuite")
        resetList(domain: "TestSuite")
        let newModel = DataModel(forTesting: true)
        newModel.addItem("Test Item")
        #expect(newModel.items.count == 1)
        #expect(newModel.items[0].title == "Test Item")
        #expect(newModel.items[0].isCompleted == false)
        resetTestDefaults()
        resetList()
    }
    
   
    @Test
    func testToggleCompletion() throws {
        resetTestDefaults(domain: "TestSuite")
        resetList(domain: "TestSuite")
        let newModel = DataModel(forTesting: true)
        newModel.addItem("Test Item")
        let item = newModel.items[0]
        newModel.toggleCompletion(for: item)
        #expect(newModel.items[0].isCompleted == true)
        newModel.toggleCompletion(for: item)
        #expect(newModel.items[0].isCompleted == false)
        resetTestDefaults()
        resetList()
    }
    
 
    @Test
    func testMultipleItems() throws {
        resetTestDefaults(domain: "TestSuite")
        resetList(domain: "TestSuite")
        let model = DataModel(forTesting: true)
        model.addItem("Item 1")
        model.addItem("Item 2")
        model.addItem("Item 3")
        
        #expect(model.items.count == 3)
        #expect(model.items[0].title == "Item 1")
        #expect(model.items[1].title == "Item 2")
        #expect(model.items[2].title == "Item 3")
        resetTestDefaults()
        resetList()
    }
    
    @Test
    func testEmptyTitleNotAdded() throws {
        resetTestDefaults(domain: "TestSuite")
        resetList(domain: "TestSuite")
        let model = DataModel(forTesting: true)
        model.addItem("")
        #expect(model.items.count == 0)
        resetTestDefaults()
        resetList()
    }
    
    @Test
    func testDeleteItem() throws {
        let domain = "TestSuite"
        resetTestDefaults(domain: domain)
        resetList(domain: domain)
        let model = DataModel(forTesting: true)
        model.addItem("Test Item")
        #expect(model.items.count == 1)
        
        model.deleteItem(at: IndexSet(integer: 0))
        model.saveItems()
        UserDefaults(suiteName: domain)!.synchronize()  // Force UserDefaults synchronization
            
        #expect(model.items.count == 0)
        
        // Create a new model to test persistence
        let newModel = DataModel(forTesting: true)
        #expect(newModel.items.count == 0, "Item should remain deleted after reloading")
        resetTestDefaults()
        resetList()
    }
    
    @Test
    func testPersistence() throws {
        // Clear any existing data
        let domain = "TestSuite_persistence"
        resetTestDefaults(domain: domain)
        resetList(domain: domain)
        
        print("UserDefaults reset")

        // Create a model and add an item
        let newModel = DataModel(forTesting: true, domain: domain)
        newModel.addItem("Test Item")
        print("Added item: Test Item")

        // Force save to UserDefaults
        newModel.saveItems()

    
        // Create a new model to simulate app restart
        let model = DataModel(forTesting: true, domain: domain)
        print("New model created, items: \(model.items)")
        
        // Check if the item persisted
        #expect(model.items.count == 1, "Expected 1 item, but found \(model.items.count)")
        if model.items.count > 0 {
            #expect(model.items[0].title == "Test Item", "Expected 'Test Item', but found '\(model.items[0].title)'")
        }
        resetTestDefaults()
        resetList()
    }

}
