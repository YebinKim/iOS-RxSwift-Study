//
//  TrackDetailViewModel.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/20.
//

import Foundation
import RxSwift
import RxRelay

final class TrackDetailViewModel {

    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let _track: Track

    lazy var selectedTrack = BehaviorRelay<Track>(value: _track)

    init(track: Track) {
        self._track = track
    }
}
