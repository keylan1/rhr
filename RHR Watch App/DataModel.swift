//
//  DataModel.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 14.10.24.
//

import Foundation

struct ToDoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
       }
}

class DataModel: ObservableObject {
    @Published var items: [ToDoItem] = []
    private let itemsKey = "todoItems"
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
            self.defaults = defaults
            loadItems()
        }
    
    func addItem(_ title: String) {
        guard !title.isEmpty else {return}
        let newItem = ToDoItem(title: title)
        items.append(newItem)
        print("Added item: \(newItem)")
        saveItems()
    }
    
    func toggleCompletion(for item: ToDoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
            saveItems()
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
            items.remove(atOffsets: offsets)
            saveItems()
        }
    
    func saveItems(completion: (() -> Void)? = nil) {
        do {
            let data = try JSONEncoder().encode(items)
            defaults.set(data, forKey: itemsKey)
            defaults.synchronize()
            print("Saved items: \(items)")
        } catch {
            print("Failed to save items: \(error)")
        }
    }
    
    private func loadItems() {
        guard let data = defaults.data(forKey: itemsKey) else {
               print("No data found in UserDefaults for key: \(itemsKey)")
               return
           }
           do {
               items = try JSONDecoder().decode([ToDoItem].self, from: data)
               print("Loaded items: \(items)")
           } catch {
               print("Failed to load items: \(error)")
           }
        }
}

