//
//  SearchView.swift
//  Trip Journal
//
//  Created by Jill Allan on 12/11/2022.
//

import SwiftUI

struct SearchView: View {
    @State private var text = ""

    var body: some View {
        NavigationView {
            SearchResults(searchText: text)
                .searchable(text: $text)
        }
    }
}

private struct SearchResults: View {
    let searchText: String

    let items = ["a", "b", "c"]
    var filteredItems: [String] { items.filter { $0 == searchText.lowercased() } }

    @State private var isPresented = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dismissSearch) private var dismissSearch

    var body: some View {
        if let item = filteredItems.first {
            Button("Details about \(item)") {
            
                isPresented = true
            }
            .sheet(isPresented: $isPresented) {
                NavigationView {
//                    DetailView2(item: item)
                    Text("Information about \(item).")
                        .toolbar {
                            Button("Add") {
                                // Store the item here...

                                dismiss()
                                dismissSearch()
                            }
                        }
                        .onDisappear {
                            dismissSearch()
                        }
                }
            }
        }
    }
}
