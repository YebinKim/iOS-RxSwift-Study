//
//  TrackListViewController.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import UIKit
import RxSwift
import RxCocoa

final class TrackListViewController: UIViewController {

    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    private var viewModel: TrackListViewModel!

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!

    static func instantiate(viewModel: TrackListViewModel) -> TrackListViewController {
        let storyboard = UIStoryboard(name: "TrackListView", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! TrackListViewController
        viewController.viewModel = viewModel
        return viewController
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        registCell()
        initializeTableView()

        viewModel.getSearchViewModel(searchItem: "shawn")
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: TrackCell.identifier, cellType: TrackCell.self)) { index, viewModel, cell in
                cell.songNameLabel.text = viewModel.songName
                cell.artistNameLabel.text = viewModel.artistName
//                cell.thumbnailImageView.image = viewModel.smallThumbnailUrl
            }
            .disposed(by: disposeBag)
    }

    // MARK: Initializer
    private func registCell() {
        let trackCellNib = UINib(nibName: TrackCell.identifier, bundle: nil)
        tableView.register(trackCellNib, forCellReuseIdentifier: TrackCell.identifier)
    }

    private func initializeTableView() {
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInsetAdjustmentBehavior = .never

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension TrackListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TrackCell.cellForHeight
    }
}
