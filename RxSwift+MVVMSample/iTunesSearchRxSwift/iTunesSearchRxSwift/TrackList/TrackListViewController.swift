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

    var coordinator: TrackListCoordinator?

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

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

        applyStyle()
        
        didSelectCell()
        bindToViewModel()
    }

    // MARK: Initializer
    private func registCell() {
        let trackCellNib = UINib(nibName: TrackCell.identifier, bundle: nil)
        tableView.register(trackCellNib, forCellReuseIdentifier: TrackCell.identifier)
    }

    private func initializeTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        preventLargeTitleCollapsing()

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func preventLargeTitleCollapsing() {
        let dummyView = UIView()
        view.addSubview(dummyView)
        view.sendSubviewToBack(dummyView)
    }

    private func applyStyle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.whiteSolid]

        searchBar.barTintColor = Colors.darkGraySolid
        searchBar.searchTextField.setBackgroundGradient()
        searchBar.searchTextField.textColor = Colors.whiteSolid

        self.view.setBackgroundGradient()
    }

    private func didSelectCell() {
        tableView.rx.modelSelected(Track.self)
            .subscribe(onNext: {
                self.coordinator?.presentTrackDetailVC(selectedTrack: $0)
            })
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

        searchBar.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                self.viewModel.searchTrackList(searchItem: text)
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension TrackListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TrackCell.cellForHeight
    }
}

// MARK: - Coordinator
class TrackListCoordinator: Coordinator {

    weak var router: Router?

    init(router: Router) {
        self.router = router
    }

    func presentTrackDetailVC(selectedTrack track: Track) {
        let trackListVC = TrackDetailViewController.instantiate(viewModel: TrackDetailViewModel(track: track))
        self.present(viewController: trackListVC, animated: true, isModal: true)
    }
}
