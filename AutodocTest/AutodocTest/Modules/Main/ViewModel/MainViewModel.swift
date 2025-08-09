//
//  MainViewModel.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import Foundation
import Combine

protocol MainViewModelling: AnyObject {
    var statePublisher: Published<MainState>.Publisher { get }
    func sendEvent(_ event: MainEvents)
}

enum MainEvents {
    case viewDidLoad
    case loadNextPage
    case shareButtonTapped(data: News)
    case openURL(url: String)
}

enum MainState {
    case idle
    case loading
    case paginating
    case success(data: [News])
    case error(NetworkError)

    var isPaginating: Bool {
        switch self {
        case .paginating: return true
        default: return false
        }
    }
}

final class MainViewModel: MainViewModelling {

    // MARK: - Properties
    @Published private var state: MainState = .idle
    var statePublisher: Published<MainState>.Publisher { $state }

    private var data: [News]?
    private var pageNumber = 1
    private let newsPerPage = 5
    private var retryCount = 3

    weak var view: MainDisplaying?

    private var networkService: NetworkServiceProtocol
    private var imageLoader: ImageLoaderProtocol
    private let router: Router

    // MARK: - Init
    init(networkService: NetworkServiceProtocol, imageLoader: ImageLoaderProtocol, router: Router) {
        self.networkService = networkService
        self.imageLoader = imageLoader
        self.router = router
    }

    func sendEvent(_ event: MainEvents) {
        guard let view else { return }
        switch event {
        case .shareButtonTapped(data: let data): router.showShareAlert(with: data, from: view)
        case .openURL(url: let url): router.showURL(url: url, from: view)
        case .viewDidLoad: loadData()
        case .loadNextPage: loadNextPage()
        }
    }
}

// MARK: - Supporting methods
private extension MainViewModel {
    func loadData() {
        state = .loading
        Task { await fetchData() }
    }

    func fetchData() async {
        do {
            try await loadFirstVisiblePhotosToCache()
            guard let data else { return }
            state = .success(data: data)
        } catch let error as NetworkError {
            Log.app.errorAlways(error.userMessage)
            state = .error(error)
            await retryFetchData()
        } catch {
            Log.app.errorAlways("Неизвестная ошибка \(error.localizedDescription)")
        }
    }

    func loadNextPage() {
        guard !state.isPaginating else {
            Log.cache.debugOnly("isPaginating now")
            return
        }

        state = .paginating
        pageNumber += 1
        Task { await fetchData() }
    }

    func loadFirstVisiblePhotosToCache() async throws {
        let fetchedData = try await networkService.fetchDataFromServer(pageNumber: pageNumber, newsPerPage: newsPerPage)
        await loadImagesToCache(with: fetchedData)
        updateData(with: fetchedData)
    }

    func loadImagesToCache(with data: [News]) async {
        await withTaskGroup(of: Void.self) { group in
            data.forEach { news in
                group.addTask { [weak self] in
                    try? await self?.imageLoader.downloadImageAndSaveToCache(from: news.titleImageUrl)
                }
            }
        }
    }
}

// MARK: - Supporting methods
private extension MainViewModel {
    func updateData(with fetchedData: [News]) {
        if data == nil || data!.isEmpty {
            data = fetchedData
        } else {
            let dataId = data!.map { $0.id }
            let uniqueData = fetchedData.filter { !dataId.contains($0.id) }
            data?.append(contentsOf: uniqueData)
        }
    }

    func retryFetchData() async {
        retryCount -= 1
        guard retryCount > 0 else {
            Log.app.debugOnly("Retry count is exhausted")
            loadNextPage()
            retryCount = 3
            return
        }
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        Log.app.debugOnly("Retrying fetch data...")
        await fetchData()
    }
}
