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

    static func instantiate() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! ViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let service = RestaurantService()
        service.fetchRestaurants()
            .subscribe { restaurants in
                print(restaurants)
            } onError: { error in
                print("error --> \(error)")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)
    }
}

