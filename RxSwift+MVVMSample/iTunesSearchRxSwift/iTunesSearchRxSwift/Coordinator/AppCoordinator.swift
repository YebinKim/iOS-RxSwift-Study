//
//  AppCoordinator.swift
//  MVVMRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import UIKit

class AppCoordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewController = TrackListViewController.instantiate(viewModel: TrackListViewModel())
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
