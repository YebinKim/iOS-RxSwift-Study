//
//  TrackDetailViewController.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/20.
//

import UIKit
import RxSwift
import RxCocoa

final class TrackDetailViewController: UIViewController {

    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    private var viewModel: TrackDetailViewModel!

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!

    // MARK: - Initializer
    static func instantiate(viewModel: TrackDetailViewModel) -> TrackDetailViewController {
        let storyboard = UIStoryboard(name: "TrackDetailView", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! TrackDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindToViewModel()
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
    }
}
