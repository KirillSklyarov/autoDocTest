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

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: News, rhs: News) -> Bool {
        lhs.id == rhs.id
    }

    static let mockData: [News] = [
        News(
            id: 8609,
            title: "Porsche 911 GT3 Cup: рождён для трека",
            description: "Компания Porsche обратила внимание на гоночные треки",
            publishedDate: "2025-07-21T00:00:00",
            url: "avto-novosti/911_gt3_cup",
            fullUrl: "https://www.autodoc.ru/avto-novosti/911_gt3_cup",
            titleImageUrl: "https://file.autodoc.ru/news/avto-novosti/2340836765_1.jpg",
            categoryType: "Автомобильные новости"
        ),
        News(
            id: 8608,
            title: "Buick Electra L7 — гибридный седан",
            description: "Buick показал совершенно новый Electra L7 в Китае",
            publishedDate: "2025-07-19T00:00:00",
            url: "avto-novosti/buick_electra_l7",
            fullUrl: "https://www.autodoc.ru/avto-novosti/buick_electra_l7",
            titleImageUrl: "https://file.autodoc.ru/news/avto-novosti/3307798260_1.jpg",
            categoryType: "Автомобильные новости"
        ),
        News(
            id: 8607,
            title: "Новый Porsche Taycan Black Edition",
            description: "Porsche Taycan со стильным обликом и богатым набором оснащения",
            publishedDate: "2025-07-17T00:00:00",
            url: "avto-novosti/porsche_taycan_black_edition",
            fullUrl: "https://www.autodoc.ru/avto-novosti/porsche_taycan_black_edition",
            titleImageUrl: "https://file.autodoc.ru/news/avto-novosti/3223502792_1.jpg",
            categoryType: "Автомобильные новости"
        ),
        News(
            id: 8605,
            title: "Mercedes-Benz CLA: премьера универсала",
            description: "Mercedes-Benz представил новейший CLA в кузове Shooting Brake",
            publishedDate: "2025-07-16T00:00:00",
            url: "avto-novosti/mercedes_cla_shooting_brake",
            fullUrl: "https://www.autodoc.ru/avto-novosti/mercedes_cla_shooting_brake",
            titleImageUrl: "https://file.autodoc.ru/news/avto-novosti/3131129343_1.jpg",
            categoryType: "Автомобильные новости"
        ),
        News(
            id: 8603,
            title: "Maserati MCPURA: обновлённый MC20",
            description: "Maserati выпустил еще более впечатляющую версию суперкара MC20",
            publishedDate: "2025-07-15T00:00:00",
            url: "avto-novosti/maserati_mcpura",
            fullUrl: "https://www.autodoc.ru/avto-novosti/maserati_mcpura",
            titleImageUrl: "https://file.autodoc.ru/news/avto-novosti/1746540984_1.jpg",
            categoryType: "Автомобильные новости"
        ),
        News(
            id: 8602,
            title: "Открытие пункта выдачи заказов в г. Москва",
            description: "г. Москва, ул. Судостроительная, д.3 (м. Коломенская)",
            publishedDate: "2025-07-14T00:00:00",
            url: "novosti-kompanii/20262",
            fullUrl: "https://www.autodoc.ru/novosti-kompanii/20262",
            titleImageUrl: "https://file.autodoc.ru/news/foto_magazinov/pv_kolomenskay2620.jpg",
            categoryType: "Новости компании"
        )
    ]
}
