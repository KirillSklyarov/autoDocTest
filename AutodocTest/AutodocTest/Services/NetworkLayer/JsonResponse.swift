//
//  JsonResponse.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import Foundation

struct JsonResponse: Codable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String

    func toNews() -> News {
        return News(id: id, title: title, description: description, publishedDate: publishedDate, url: url, fullUrl: fullUrl, titleImageUrl: titleImageUrl, categoryType: categoryType)

    }
}
