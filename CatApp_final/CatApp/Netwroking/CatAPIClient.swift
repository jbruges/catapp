//
//  CatAPIClient.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import Foundation
import Combine

final class CatAPIClient {
    private let baseURL = URL(string: "https://api.thecatapi.com/v1")!
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func fetchBreeds() -> AnyPublisher<[Breed], Error> {
        var request = URLRequest(url: baseURL.appendingPathComponent("breeds"))
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Breed].self, decoder: JSONDecoder())
            .flatMap { breeds in
                Publishers.MergeMany(
                    breeds.map { breed -> AnyPublisher<Breed, Never> in
                        if breed.image?.url != nil {
                            return Just(breed).eraseToAnyPublisher()
                        } else {
                            return self.fetchBreedImage(for: breed.id)
                                .replaceError(with: nil)
                                .map { url in
                                    var b = breed
                                    if let url = url {
                                        b = Breed(id: breed.id,
                                                  name: breed.name,
                                                  origin: breed.origin,
                                                  temperament: breed.temperament,
                                                  description: breed.description,
                                                  life_span: breed.life_span,
                                                  image: Breed.ImageInfo(url: url))
                                    }
                                    return b
                                }
                                .eraseToAnyPublisher()
                        }
                    }
                )
                .collect()
                .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func fetchBreedImage(for breedID: String) -> AnyPublisher<String?, Error> {
        var components = URLComponents(url: baseURL.appendingPathComponent("images/search"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "breed_id", value: breedID),
            URLQueryItem(name: "limit", value: "1")
        ]
        
        var request = URLRequest(url: components.url!)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> String? in
                guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                let result = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
                return result?.first?["url"] as? String
            }
            .eraseToAnyPublisher()
    }
}

