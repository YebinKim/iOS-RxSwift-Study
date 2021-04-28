//
//  TrackDetailViewController.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/20.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

final class TrackDetailViewController: UIViewController {

    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    private var viewModel: TrackDetailViewModel!

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var volumeSlider: CirculerSlider!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var forwardButtonView: UIView!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var playButtonView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backwardButtonView: UIView!
    @IBOutlet weak var backwardButton: UIButton!

    // MARK: - Initializer
    static func instantiate(viewModel: TrackDetailViewModel) -> TrackDetailViewController {
        let storyboard = UIStoryboard(name: "TrackDetailView", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! TrackDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyle()
        bindToViewModel()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.player
            .asDriver()
            .drive {
                $0.pause()
            }
            .disposed(by: disposeBag)
    }

    private func applyStyle() {
        self.view.setBackgroundGradient()

        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.width / 2.0
        thumbnailImageView.contentMode = .scaleAspectFill

        songNameLabel.textColor = Colors.whiteSolid
        
        artistNameLabel.textColor = Colors.graySolid

        playSlider.thumbTintColor = Colors.graySolid
        playSlider.minimumTrackTintColor = Colors.blueSolid

        forwardButtonView.setGradient(
            colors: Colors.backGradient.reversed(),
            locations: [0.0, 0.9, 1.0],
            isRounded: true
        )
        forwardButton.setGradientToButton(
            colors: Colors.backGradient,
            locations: [0.0, 0.4, 1.0],
            isRounded: true
        )
        forwardButton.tintColor = Colors.whiteSolid

        playButtonView.setGradient(
            colors: Colors.backGradient.reversed(),
            locations: [0.0, 0.9, 1.0],
            isRounded: true
        )
        playButton.setGradientToButton(
            colors: Colors.backGradient,
            locations: [0.0, 0.4, 1.0],
            isRounded: true
        )
        playButton.tintColor = Colors.whiteSolid

        backwardButtonView.setGradient(
            colors: Colors.backGradient.reversed(),
            locations: [0.0, 0.9, 1.0],
            isRounded: true
        )
        backwardButton.setGradientToButton(
            colors: Colors.backGradient,
            locations: [0.0, 0.4, 1.0],
            isRounded: true
        )
        backwardButton.tintColor = Colors.whiteSolid
    }

    private func bindToViewModel() {
        viewModel.selectedTrack
            .asDriver()
            .drive {
                self.thumbnailImageView.setImage(urlString: $0.thumbnailUrl)
                self.songNameLabel.text = $0.songName
                self.artistNameLabel.text = $0.artistName
            }
            .disposed(by: disposeBag)

        viewModel.player
            .asDriver()
            .drive { player in
                self.playButton.rx.tap
                    .bind {
                        if player.timeControlStatus == .paused {
                            player.play()
                            self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                        } else {
                            player.pause()
                            self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                        }
                    }
                    .disposed(by: self.disposeBag)

                self.volumeSlider.rx.value
                    .bind(to: player.rx.volume)
                    .disposed(by: self.disposeBag)

                self.playSlider.rx.value
                    .subscribe(onNext: { value in
                        guard let item = player.currentItem else { return }
                        let nowSeconds: Double = Double(value) * item.duration.seconds
                        let seekTime = CMTime(seconds: nowSeconds, preferredTimescale: 100)
                        player.currentItem?.seek(to: seekTime, completionHandler: nil)
                    })
                    .disposed(by: self.disposeBag)

                player.addPeriodicTimeObserver(
                    forInterval: .init(value: 1, timescale: 100),
                    queue: .main) { _ in
                    guard let item = player.currentItem else { return }
                    self.playSlider.value = Float(item.currentTime().seconds / item.duration.seconds)
                }
            }
            .disposed(by: disposeBag)
    }
}
