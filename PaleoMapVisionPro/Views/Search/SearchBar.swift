//
//  SearchBar.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 19/11/2023.
//

import SwiftUI
import UIKit

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    var placeholder: String
    var onSearchButtonClicked: (() -> Void)

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var isFocused: Bool
        var onSearchButtonClicked: (() -> Void)

        init(text: Binding<String>, isFocused: Binding<Bool>, onSearchButtonClicked: @escaping (() -> Void)) {
            _text = text
            _isFocused = isFocused
            self.onSearchButtonClicked = onSearchButtonClicked
        }

        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            isFocused = true
        }

        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            isFocused = false
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder() // Dismiss the keyboard
            onSearchButtonClicked()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, isFocused: $isFocused, onSearchButtonClicked: onSearchButtonClicked)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder // Set the placeholder text
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}




