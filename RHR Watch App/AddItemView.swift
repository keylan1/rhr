//
//  AddItemView.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 14.10.24.
//

import SwiftUI

struct AddItemView: View {
    @Binding var newItemTitle: String
    let addItem: () -> Void
    
    var body: some View {
        VStack {
            TextField("New item", text: $newItemTitle)
            Button("Add Task", action: addItem)
        }
        .padding()
    }
}


#Preview {

    AddItemView(newItemTitle: .constant("New task"), addItem:  {
        print("Add item")
    })
}
