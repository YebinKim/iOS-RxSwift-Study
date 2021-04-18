//
//  RestaurantsListViewController.swift
//  MVVMRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import UIKit
import RxSwift
import RxCocoa

final class RestaurantsListViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private var viewModel: RestaurantsListViewModel!

    @IBOutlet weak var tableView: UITableView!

    static func instantiate(viewModel: RestaurantsListViewModel) -> RestaurantsListViewController {
        let storyboard = UIStoryboard(name: "RestaurantsListView", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! RestaurantsListViewController
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeTableView()

        viewModel.fetchRestaurantViewModel()
            // UI 관련 작업은 MainScheduler 에서 수행
            .observe(on: MainScheduler.instance)
            // tableView cell에 viewModel 데이터를 바인딩
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { index, viewModel, cell in
                cell.textLabel?.text = viewModel.artistName
            }
            .disposed(by: disposeBag)
    }

    private func initializeTableView() {
        tableView.tableFooterView = UIView()

        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

