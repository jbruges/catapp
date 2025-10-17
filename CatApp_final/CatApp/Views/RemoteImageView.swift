//
//  RemoteImageView.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import SwiftUI

struct RemoteImageView: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Color = Color.gray.opacity(0.3)

    init(url: String?) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
                    .overlay(ProgressView().scaleEffect(0.8))
            }
        }
        .onAppear { loader.load() }
    }
}

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: String?
    private var task: URLSessionDataTask?

    init(url: String?) {
        self.url = url
    }

    func load() {
        guard let urlStr = url, let u = URL(string: urlStr) else { return }
        task = URLSession.shared.dataTask(with: u) { data, _, _ in
            if let data = data, let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        }
        task?.resume()
    }

    deinit {
        task?.cancel()
    }
}


