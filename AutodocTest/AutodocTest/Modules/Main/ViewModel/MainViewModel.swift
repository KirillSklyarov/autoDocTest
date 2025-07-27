//
//  MainViewModel.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import Foundation
import Combine

protocol MainViewModelling: AnyObject {
    var newsDataPublisher: Published<[News]?>.Publisher { get }
    var isLoadingNextPagePublisher: Published<Bool>.Publisher { get }

    func initialize()
    func loadNextPage()
//    func showShareAlert(with data: News)
}

final class MainViewModel: MainViewModelling {

    // MARK: - Properties
    @Published private var data: [News]?
    var newsDataPublisher: Published<[News]?>.Publisher { $data }

    @Published var isLoadingNextPage = false
    var isLoadingNextPagePublisher: Published<Bool>.Publisher { $isLoadingNextPage }

    private var pageNumber = 1
    private let newsPerPage = 5

    weak var view: MainDisplaying?

    private var networkService: NetworkServiceProtocol
    private var imageLoader: ImageLoaderProtocol

    var onAllImagesLoaded: (() -> Void)?

    // MARK: - Init
    init(networkService: NetworkServiceProtocol, imageLoader: ImageLoaderProtocol) {
        self.networkService = networkService
        self.imageLoader = imageLoader
    }

    func initialize() {
        view?.setupInitialState()
        loadData()
    }

    func loadNextPage() {
        guard isLoadingNextPage == false else { print("HERE"); return }
        isLoadingNextPage = true
        pageNumber += 1
        Task {
            await fetchData()
            isLoadingNextPage = false
        }
    }
}

// MARK: - Supporting methods
private extension MainViewModel {
    func loadData() {
        view?.showLoading(true)
        Task {
            await fetchData()
        }
    }

    func fetchData() async {
        do {
            try await loadFirstVisiblePhotosToCache()
        } catch let error as NetworkError {
            print(error.userMessage)
        } catch {
            print("Неизвестная ошибка \(error.localizedDescription)")
        }
    }

    func loadFirstVisiblePhotosToCache() async throws {
        let fetchedData = try await networkService.fetchDataFromServer(pageNumber: pageNumber, newsPerPage: newsPerPage)
        await loadImagesToCache(with: fetchedData)
        if data == nil || data!.isEmpty {
            data = fetchedData
        } else {
            data?.append(contentsOf: fetchedData)
        }
    }

    func loadImagesToCache(with data: [News]) async {
        await withTaskGroup(of: Void.self) { group in
            data.forEach { news in
                group.addTask {
                    try? await self.imageLoader.loadImageToCache(from: news.titleImageUrl)
                }
            }
        }
    }
}

//func loadRestOfPhotosToCache() {
//    print(#function, "!!!!!!!!")
////        guard let data else { return }
//    view?.setScrollEnable(false)
//    let restCells = Array(fetchedData.dropFirst(mainViewVisibleCellsCount))
//
//    Task.detached { [weak self] in
//        guard let self else { print("Self is nil"); return }
//        await preLoadImages(with: restCells)
////            DispatchQueue.main.async {
//            self.data?.append(contentsOf: restCells)
////            }
//    }
//
//    view?.setScrollEnable(true)
//}
//
