//
//  View-CustomModifiers.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/12/2022.
//

import SwiftUI
import Photos

struct AddButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .labelStyle(.iconOnly)
            .padding(8)
            .foregroundColor(.white)
            .background(Color.green)
            .clipped()
            .clipShape(Circle())
    }
}

struct photoGridItemModifier: ViewModifier {
    var aspectRatio: Double
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped(antialiased: true)
            .aspectRatio(aspectRatio, contentMode: .fit)
            .cornerRadius(cornerRadius)
    }
}

extension View {
    func addButtonStyle() -> some View {
        modifier(AddButton())
    }
    
    func photoGridItemStyle(aspectRatio: Double, cornerRadius: CGFloat) -> some View {
        modifier(photoGridItemModifier(aspectRatio: aspectRatio, cornerRadius: cornerRadius))
    }
    
    func metricsLabel(count: Int, systemImage: String) -> some View {
        Label(count.formatted(), systemImage: systemImage)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .font(.caption)
            .background(Color.white)
            .cornerRadius(8)
            .foregroundColor(.gray)
    }
    
    
}
