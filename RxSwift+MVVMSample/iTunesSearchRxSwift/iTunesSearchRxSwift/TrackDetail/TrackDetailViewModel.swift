//
//  TrackDetailViewModel.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/20.
//

import Foundation
import RxSwift
import RxRelay
import AVFoundation

final class TrackDetailViewModel {

    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let _track: Track

    lazy var selectedTrack = BehaviorRelay<Track>(value: _track)
    let player = BehaviorRelay<AVPlayer>(value: AVPlayer())

    init(track: Track) {
        self._track = track

        if let previewUrl = URL(string: track.previewUrl) {
            let playerItem = AVPlayerItem(url: previewUrl)
            player.accept(AVPlayer(playerItem: playerItem))
        }
    }
}
