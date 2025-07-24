//
//  NetworkServiceProtocol.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchDataFromServer() async throws -> [StockModel]
}

struct NetworkService: NetworkServiceProtocol {

    // MARK: - Network Client
    let networkClient: NetworkClient

    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Fetch methods
    func fetchDataFromServer() async throws -> [StockModel] {
        let response = try await networkClient.fetchData(.dummy, type: [JsonResponse].self)
        let stocks = responseMapping(response)
        return stocks
    }
}

// MARK: - Supporting methods
private extension NetworkService {
    func responseMapping(_ response: [JsonResponse]) -> [StockModel] {
        return response.map { $0.toStockModel() }
    }
}
