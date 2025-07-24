//
//  DependencyContainer.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//


import Foundation

final class DependencyContainer {
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let session: URLSession
    let networkClient: NetworkClient
    let networkService: NetworkService

    init() {
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        session = URLSession(configuration: .default)
        networkClient = NetworkClient(decoder: decoder, encoder: encoder, session: session)
        networkService = NetworkService(networkClient: networkClient)
    }
}
