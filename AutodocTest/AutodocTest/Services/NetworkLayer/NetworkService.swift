//
//  NetworkServiceProtocol.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchDataFromServer() async throws -> [News]
}

struct NetworkService: NetworkServiceProtocol {

    // MARK: - Network Client
    let networkClient: NetworkClient

    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Fetch methods
    func fetchDataFromServer() async throws -> [News] {
        let response = try await networkClient.fetchData(.news, type: JsonResponse.self)
        let news = responseMapping(response)
        return news
    }
}

// MARK: - Supporting methods
private extension NetworkService {
    func responseMapping(_ response: JsonResponse) -> [News] {
        return response.toNewsList()
    }
}
