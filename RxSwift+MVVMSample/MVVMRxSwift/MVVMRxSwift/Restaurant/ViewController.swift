//
//  ViewController.swift
//  MVVMRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private var viewModel: RestaurantsListViewModel!

    @IBOutlet weak var tableView: UITableView!

    static func instantiate(viewModel: RestaurantsListViewModel) -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! ViewController
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
                cell.textLabel?.text = viewModel.displayTest
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

