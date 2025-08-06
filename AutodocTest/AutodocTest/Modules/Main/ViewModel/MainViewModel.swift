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
    case error(Error)

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
            guard let data else  { return }
            state = .success(data: data)
        } catch let error as NetworkError {
            print(error.userMessage)
        } catch {
            print("Неизвестная ошибка \(error.localizedDescription)")
        }
    }

    func loadNextPage() {
        guard !state.isPaginating else { return }
        state = .paginating
        pageNumber += 1
        Task { await fetchData() }
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
