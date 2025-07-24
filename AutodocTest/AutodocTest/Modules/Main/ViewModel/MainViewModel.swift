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

    func initialize()
    func loadNextPage()
    func isAllImagesLoaded()
}

final class MainViewModel: MainViewModelling {

    @Published private var data: [News]?
    var newsDataPublisher: Published<[News]?>.Publisher { $data }

    private var pageNumber = 1
    private var isLoading = false
    private var loadedImagesCount = 0
    private var mainViewVisibleCellsCount = 7

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
        guard isLoading == false else { return }
        view?.setScrollEnable(false)
        pageNumber += 1
        Task {
            await fetchData()
            view?.setScrollEnable(true)
        }
    }

    func isAllImagesLoaded() {
        guard let data else { print("No data"); return }
        isLoading = true
        view?.showLoading(true)
        loadedImagesCount += 1

        if loadedImagesCount == data.count {
            print("All images loaded")
            isLoading = false
            view?.showLoading(false)

            view?.setScrollEnable(true)
        }
    }
}

private extension MainViewModel {
    func loadData() {
        isLoading = true
        view?.showLoading(true)
        Task {
            await fetchData()

            //            isAllImagesLoaded()
            isLoading = false
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
//                print(1)
            data = fetchedData
        } else {
//                print(2)
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

