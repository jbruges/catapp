//
//  SearchBar.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        init(text: Binding<String>) { _text = text }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(text: $text) }
    func makeUIView(context: Context) -> UISearchBar {
        let sb = UISearchBar()
        sb.delegate = context.coordinator
        sb.placeholder = placeholder
        return sb
    }
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

