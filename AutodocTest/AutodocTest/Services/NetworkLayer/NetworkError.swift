//
//  NetworkError.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import Foundation

// Обработка ошибок
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case httpError(Int)
    case noData
    case decodingError(Error)
    case unknown(Error)
}

// Методы
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// Точки доступа
enum BaseURL: String {
    case dummy = "https://mustdev.ru/api/stocks.json"
}

enum EndPoint {
    case dummy

    var url: URL? {
        switch self {
        case .dummy: return URL(string: BaseURL.dummy.rawValue)
        }
    }
}
