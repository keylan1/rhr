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
    convenience init(forTesting: Bool) {
        let defaults = forTesting ? UserDefaults(suiteName: "TestSuite")! : .standard
        self.init(defaults: defaults)
        }
}

struct RHR_Watch_AppTests {
    let testSuite = UserDefaults(suiteName: "TestSuite")!

    func resetTestDefaults() {
        testSuite.removePersistentDomain(forName: "TestSuite")
        testSuite.synchronize()
        Thread.sleep(forTimeInterval: 1.0)
        print("Test UserDefaults reset")
    }

    func resetList() {
        let model = DataModel(forTesting: true)
        model.items = []
        model.saveItems()
        testSuite.synchronize()
    }

    func tearDown() {
        let domain = "TestSuite"
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        Thread.sleep(forTimeInterval: 1.0)  // Wait to ensure UserDefaults are cleared
    }


    @Test func testAddItem() async throws {
        resetTestDefaults()
        resetList()
        let newModel = DataModel(forTesting: true)
        newModel.addItem("Test Item")
        #expect(newModel.items.count == 1)
        #expect(newModel.items[0].title == "Test Item")
        #expect(newModel.items[0].isCompleted == false)
        tearDown()
    }
    
    
    
    
    @Test
    func testToggleCompletion() async throws {
        resetTestDefaults()
        resetList()
        let newModel = DataModel(forTesting: true)
        newModel.addItem("Test Item")
        let item = newModel.items[0]
        newModel.toggleCompletion(for: item)
        #expect(newModel.items[0].isCompleted == true)
        newModel.toggleCompletion(for: item)
        #expect(newModel.items[0].isCompleted == false)
        tearDown()
    }
    
    

    
    
    @Test
    func testMultipleItems() async throws {
        resetTestDefaults()
        resetList()
        let model = DataModel(forTesting: true)
        model.addItem("Item 1")
        model.addItem("Item 2")
        model.addItem("Item 3")
        
        #expect(model.items.count == 3)
        #expect(model.items[0].title == "Item 1")
        #expect(model.items[1].title == "Item 2")
        #expect(model.items[2].title == "Item 3")
        tearDown()
    }
    
    @Test
    func testEmptyTitleNotAdded() async throws {
        resetTestDefaults()
        resetList()
        let model = DataModel(forTesting: true)
        model.addItem("")
        #expect(model.items.count == 0)
        tearDown()
    }

    
    @Test
    func testDeleteItem() async throws {
        resetTestDefaults()
        resetList()
        let model = DataModel(forTesting: true)
        model.addItem("Test Item")
        #expect(model.items.count == 1)
        
        model.deleteItem(at: IndexSet(integer: 0))
        model.saveItems()
        try await Task.sleep(nanoseconds: 100_000_000)
        testSuite.synchronize()  // Force UserDefaults synchronization
            
        #expect(model.items.count == 0)
        
        // Create a new model to test persistence
        let newModel = DataModel(forTesting: true)
        #expect(newModel.items.count == 0, "Item should remain deleted after reloading")
        tearDown()
    }
    
    @Test
    func testPersistence() async throws {
        // Clear any existing data
        resetTestDefaults()
        resetList()
        
        print("UserDefaults reset")

        // Create a model and add an item
        let newModel = DataModel(forTesting: true)
        newModel.addItem("Test Item")
        print("Added item: Test Item")

        // Force save to UserDefaults
        newModel.saveItems()
        try await Task.sleep(nanoseconds: 2_000_000_000)
        testSuite.synchronize()
        //Thread.sleep(forTimeInterval: 1.0)
        

        // Print all UserDefaults data for debugging
        //    print("All UserDefaults data:")
        //for (key, value) in testSuite.dictionaryRepresentation() {
         //       print("\(key): \(value)")
         //   }
        
        // Create a new model to simulate app restart
        let model = DataModel(forTesting: true)
        print("New model created, items: \(model.items)")
        
        // Check if the item persisted
        #expect(model.items.count == 1, "Expected 1 item, but found \(model.items.count)")
        if model.items.count > 0 {
            #expect(model.items[0].title == "Test Item", "Expected 'Test Item', but found '\(model.items[0].title)'")
        }
        tearDown()
    }

}
