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

    // MARK: - Initializer
    static func instantiate(viewModel: TrackDetailViewModel) -> TrackDetailViewController {
        let storyboard = UIStoryboard(name: "TrackDetailView", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! TrackDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
