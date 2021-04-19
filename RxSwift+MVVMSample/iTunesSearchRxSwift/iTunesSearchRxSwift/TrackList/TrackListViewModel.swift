//
//  TrackListViewModel.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import Foundation
import RxSwift
import RxRelay

final class TrackListViewModel {

    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let searchService: SearchServiceProtocol

    let title = BehaviorRelay<String>(value: "iTunes Search")
    let trackList = BehaviorRelay<[Track]>(value: [])

    // MARK: - Initializer
    init(searchService: SearchServiceProtocol = SearchService()) {
        self.searchService = searchService
    }

    func searchTrackList(searchItem: String) {
        searchService.getSearchResults(searchItem: searchItem)
            .bind(to: trackList)
            .disposed(by: disposeBag)
    }
}
