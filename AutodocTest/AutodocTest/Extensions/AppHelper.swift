//
//  DateUtils.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 26.07.2025.
//

import Foundation

struct AppHelper {

    struct DateUtils {
        static let isoFormatter: DateFormatter = {
            let f = DateFormatter()
            f.locale = Locale(identifier: "en_US_POSIX")
            f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return f
        }()

        static let ruFormatter: DateFormatter = {
            let f = DateFormatter()
            f.locale = Locale(identifier: "ru_RU")
            f.dateFormat = "d MMMM"
            return f
        }()

        static func format(_ iso: String) -> String {
            guard let date = isoFormatter.date(from: iso) else { return "неизвестно" }
            return ruFormatter.string(from: date)
        }
    }
}
