//
//  DetailView.swift
//  Trip Journal
//
//  Created by Jill Allan on 12/11/2022.
//

import SwiftUI

struct DetailView2: View {
    let item: String

    @Environment(\.dismiss) var dismiss
    @Environment(\.dismissSearch) var dismissSearch

    var body: some View {
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
