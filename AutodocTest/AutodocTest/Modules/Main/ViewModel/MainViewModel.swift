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
}

final class MainViewModel: MainViewModelling {

    @Published private var data: [News]?
    var newsDataPublisher: Published<[News]?>.Publisher { $data }

    weak var view: MainDisplaying?

    private var networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func initialize() {
        view?.setupInitialState()
        loadData()
    }
}

private extension MainViewModel {
    func loadData() {
        view?.showLoading()
        Task { await fetchData() }
    }

    func fetchData() async {
        do {
            self.data = try await networkService.fetchDataFromServer()
        } catch let error as NetworkError {
            print(error.userMessage)
        } catch {
            print("Неизвестная ошибка \(error.localizedDescription)")
        }
    }
}
