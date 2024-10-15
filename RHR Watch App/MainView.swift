//
//  MainView.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 14.10.24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var model = DataModel()
    @State private var newItemTitle = ""
    @State private var showingAddItemView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.items) { item in
                    HStack {
                        Text(item.title)
                        Spacer()
                        if item.isCompleted {
                            Image(systemName: "checkmark")
                        }
                    }
                    .onTapGesture {
                        model.toggleCompletion(for: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("To-Dos")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { showingAddItemView = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddItemView) {
            AddItemView(newItemTitle: $newItemTitle, addItem: addItem)
        }
    }
    
    private func addItem() {
        if !newItemTitle.isEmpty {
            model.addItem(newItemTitle)
            newItemTitle = ""
            showingAddItemView = false
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
          model.deleteItem(at: offsets)
      }
}


#Preview {
    MainView()
}
