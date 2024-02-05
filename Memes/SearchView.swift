//
//  SearchView.swift
//  Memes
//
//  Created by Volodymyr Babych on 13.12.2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var showCopyPopup = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Search") {
                        hideKeyboard()
                        viewModel.clear()
                        viewModel.loadMoreResults(searchTerm: searchText)
                        
                    }
                    .padding()
                }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.searchItems, id: \.data.url) { child in
                            VStack {
                                let urlString = child.data.url ?? ""
                                let url = URL(string: urlString)
                                ZStack {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(8)
                                    
                                    Button(action: {
                                        if let highResolutionURL = child.data.url {
                                            copyImageToClipboard(url: highResolutionURL)
                                        }
                                    }) {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 150, height: 150)
                                    }
                                }
                            }
                        }
                        if !viewModel.searchItems.isEmpty {
                            if viewModel.afterID != nil {
                                Text("Loading more...")
                                    .onAppear(perform: {
                                        viewModel.loadMoreResults(searchTerm: searchText)
                                    })
                            }
                        }
                    }
                }
            }
            
            if showCopyPopup {
                PopupView()
                    .frame(width: 120, height: 60)
                    .foregroundColor(.clear)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.showCopyPopup = false
                        }
                    }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5, anchor: .center)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func copyImageToClipboard(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                return
            }
            DispatchQueue.main.async {
                UIPasteboard.general.image = image
                self.showCopyPopup = true
            }
        }.resume()
    }
}

#Preview {
    SearchView()
}
