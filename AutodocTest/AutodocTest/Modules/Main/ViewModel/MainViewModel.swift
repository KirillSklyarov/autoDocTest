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
}

final class MainViewModel: MainViewModelling {

    @Published private var data: [News]?
    var newsDataPublisher: Published<[News]?>.Publisher { $data }

    @Published var isLoadingNextPage = false {
        didSet {
//            print("🟠 isLoadingNextPage set to: \(isLoadingNextPage)")
                    Thread.callStackSymbols.forEach { print($0) }
            print("isLoadingNextPage: \(isLoadingNextPage)")
        }
    }
    var isLoadingNextPagePublisher: Published<Bool>.Publisher { $isLoadingNextPage }

    private var pageNumber = 1
    private var loadedImagesCount = 0
    private var mainViewVisibleCellsCount = 3

    weak var view: MainDisplaying?

    private var networkService: NetworkServiceProtocol
    private var imageLoader: ImageLoaderProtocol

    var onAllImagesLoaded: (() -> Void)?

    init(networkService: NetworkServiceProtocol, imageLoader: ImageLoaderProtocol) {
        self.networkService = networkService
        self.imageLoader = imageLoader
    }

    func initialize() {
        view?.setupInitialState()
        loadData()
    }

    func loadNextPage() {
        view?.setScrollEnable(false)
        guard isLoadingNextPage == false else { print("HERE"); return }
        isLoadingNextPage = true
        pageNumber += 1
//        loadData()
        Task {
            await fetchData()
            view?.setScrollEnable(true)
            isLoadingNextPage = false
        }
    }
}

private extension MainViewModel {
    func loadData() {
//        isLoadingNextPage = true
        view?.showLoading(true)
        Task {
            await fetchData()
//            isLoadingNextPage = false
        }
    }

    func fetchData() async {
        do {
            try await loadFirstVisiblePhotosToCache()
            loadRestOfPhotosToCache()
        } catch let error as NetworkError {
            print(error.userMessage)
        } catch {
            print("Неизвестная ошибка \(error.localizedDescription)")
        }
    }

    func loadFirstVisiblePhotosToCache() async throws {
        let fetchedData = try await networkService.fetchDataFromServer(pageNumber: pageNumber)
        let firstVisibleCells = Array(fetchedData.prefix(mainViewVisibleCellsCount))
        await preLoadImages(with: firstVisibleCells)
        if data == nil || data!.isEmpty {
            data = fetchedData
        } else {
            data?.append(contentsOf: fetchedData)
        }
    }

    func loadRestOfPhotosToCache() {
        guard let data else { return }
        view?.setScrollEnable(false)
        let restCells = Array(data.dropFirst(mainViewVisibleCellsCount))
        Task.detached { [weak self] in
            await self?.preLoadImages(with: restCells)
        }
        view?.setScrollEnable(true)
    }

    func preLoadImages(with data: [News]) async {
        await withTaskGroup(of: Void.self) { group in
            data.forEach { news in
                group.addTask {
                    try? await self.imageLoader.loadImageToCache(from: news.titleImageUrl)
                }
            }
        }
    }
}


//    func isAllImagesLoaded() {
//        guard let data else { print("No data"); return }
//        isLoading = true
//        view?.showLoading(true)
//        loadedImagesCount += 1
//
//        if loadedImagesCount == data.count {
//            print("All images loaded")
//            isLoading = false
//            view?.showLoading(false)
//
//            view?.setScrollEnable(true)
//        }
//    }
