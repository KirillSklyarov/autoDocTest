//
//  NewsModel.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import Foundation

struct News: Hashable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String
}
