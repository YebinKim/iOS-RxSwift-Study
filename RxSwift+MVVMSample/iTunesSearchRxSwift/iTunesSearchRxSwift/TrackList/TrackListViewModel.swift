//
//  TrackListViewModel.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import Foundation
import RxSwift

final class TrackListViewModel {

    let title = "iTunes Search"

    private let searchService: SearchServiceProtocol

    init(searchService: SearchServiceProtocol = SearchService()) {
        self.searchService = searchService
    }

    func getSearchViewModel(searchItem: String) -> Observable<[Track]> {
        searchService.getSearchResults(searchItem: searchItem)
            .map { $0 }
    }
}
