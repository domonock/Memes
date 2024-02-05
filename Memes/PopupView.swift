//
//  PopupView.swift
//  Memes
//
//  Created by Volodymyr Babych on 05.02.2024.
//

import SwiftUI

struct PopupView: View {
    var body: some View {
        Text("Image link copied")
            .font(.caption)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
    }
}

