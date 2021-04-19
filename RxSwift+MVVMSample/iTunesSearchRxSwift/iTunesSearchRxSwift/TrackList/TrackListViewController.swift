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

    // MARK: - Initializer
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

        bindToViewModel()

        viewModel.searchTrackList(searchItem: "Shawn")

        tableView.rx.itemSelected
            .subscribe {
                let viewController = TrackDetailViewController.instantiate(viewModel: TrackDetailViewModel())
                self.present(viewController, animated: true)
                print($0)
            }
            .disposed(by: disposeBag)
    }

    // MARK: Initializer
    private func registCell() {
        let trackCellNib = UINib(nibName: TrackCell.identifier, bundle: nil)
        tableView.register(trackCellNib, forCellReuseIdentifier: TrackCell.identifier)
    }

    private func initializeTableView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInsetAdjustmentBehavior = .never

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func bindToViewModel() {
        viewModel.title
            .asDriver()
            .drive(self.navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.trackList
            .asDriver()
            .drive(
                tableView.rx.items(cellIdentifier: TrackCell.identifier, cellType: TrackCell.self
                )) { index, viewModel, cell in
                cell.songNameLabel.text = viewModel.songName
                cell.artistNameLabel.text = viewModel.artistName
                cell.thumbnailImageView.setImage(urlString: viewModel.thumbnailUrl)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension TrackListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TrackCell.cellForHeight
    }
}
