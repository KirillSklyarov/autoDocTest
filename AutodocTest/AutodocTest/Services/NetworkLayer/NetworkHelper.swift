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
    case httpError(statusCode: Int, data: Data?)
    case noData
    case decodingError(Error)
    case unknown(Error)
    
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Некорректный адрес запроса."
        case .requestFailed(let error):
            return "Ошибка запроса: \(error.localizedDescription)"
        case .invalidResponse:
            return "Некорректный ответ от сервера."
        case .httpError(let code, _):
            return "Ошибка HTTP: код \(code)."
        case .noData:
            return "Нет данных от сервера."
        case .decodingError(let error):
            return "Ошибка декодирования: не удалось распарсить ответ сервера. \(error.localizedDescription)"
        case .unknown(let error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
}

// Методы
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// Точки доступа
enum Domain: String {
    case autodoc = "https://webapi.autodoc.ru"
}

enum EndPoint {
    case news(page: Int, newsPerPage: Int)

    var url: URL? {
        switch self {
        case .news(let page, let newsPerPage): URL(string: "\(Domain.autodoc.rawValue)/api/news/\(page)/\(newsPerPage)")
        }
    }
}
