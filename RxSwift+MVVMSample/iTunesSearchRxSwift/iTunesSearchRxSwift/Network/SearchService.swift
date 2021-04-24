//
//  SearchService.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import Foundation
import RxSwift

// MARK: - SearchServiceProtocol
protocol SearchServiceProtocol {
    func getSearchResults(searchItem: String) -> Observable<[Track]>
}

// MARK: - SearchService
class SearchService: SearchServiceProtocol {

    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?

    func getSearchResults(searchItem item: String) -> Observable<[Track]> {

        self.dataTask?.cancel()

        let url = SearchAPIConstant.search(item).url
        var request = URLRequest(url: url)
        request.httpMethod = SearchAPIConstant.search(item).method

        return Observable.create { observer -> Disposable in

            self.dataTask = self.defaultSession.dataTask(with: request) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }

                if let data = data {
                    do {
                        let tracks = try JSONDecoder().decode(Tracks.self, from: data)
                        observer.onNext(tracks.results)
                    } catch(let error) {
                        observer.onError(error)
                    }
                }
            }
            self.dataTask?.resume()

            return Disposables.create()
        }
    }
}
