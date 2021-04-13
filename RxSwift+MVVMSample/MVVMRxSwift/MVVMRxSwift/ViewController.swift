//
//  ViewController.swift
//  MVVMRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private var viewModel: RestaurantsListViewModel!

    static func instantiate(viewModel: RestaurantsListViewModel) -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! ViewController
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchRestaurantViewModel()
    }
}

