//
//  JsonResponse.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import Foundation

struct JsonResponse: Codable {
    let news: [NewsJsonResponse]
    let totalCount: Int

    func toNewsList() -> [News] {
        news.map { $0.toNews() }
    }
}

struct NewsJsonResponse: Codable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String

    func toNews() -> News {
        return News(
            id: id,
            title: title,
            description: description,
            publishedDate: AppHelper.DateUtils.format(publishedDate),
            url: url,
            fullUrl: fullUrl,
            titleImageUrl: titleImageUrl,
            categoryType: categoryType)
    }
}
