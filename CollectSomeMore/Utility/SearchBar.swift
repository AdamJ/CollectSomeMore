//
//  SearchBar.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 6/9/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    var placeholder: String = "Search..."
    @FocusState var isFocused: Bool

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Colors.onSurfaceVariant)
                    .padding(.leading, 8)
                
                TextField(placeholder, text: $searchText)
                    .focused($isFocused)
                    .padding(.vertical, 8)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "clear.fill")
                            .foregroundColor(Colors.onSurfaceVariant)
                            .padding(.trailing, 8)
                    }
                }
            }
            .background(.secondaryContainer)
            .cornerRadius(8)
            .padding(.horizontal)
        }
        .background(.secondaryContainer)
    }
}
