//
//  AppCoordinator.swift
//  MVVMRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import UIKit

// MARK: - Coordinator
protocol Coordinator: class {

    var router: Router? { get }

    func present(viewController: UIViewController, animated: Bool, isModal: Bool)
    func dismiss(animated: Bool)
}

extension Coordinator {

    func present(viewController: UIViewController, animated: Bool, isModal: Bool = false) {
        router?.show(viewController, animated: animated, isModal: isModal)
    }

    func dismiss(animated: Bool) {
        router?.hide(animated: animated)
    }
}

// MARK: - AppCoordinator
final class AppCoordinator: Coordinator {

    weak var router: Router?

    init(router: Router) {
        self.router = router
    }

    func start() {
        let trackListViewController = TrackListViewController.instantiate(viewModel: TrackListViewModel())
        let naviCon = UINavigationController(rootViewController: trackListViewController)
        trackListViewController.coordinator = TrackListCoordinator(router: naviCon)
        present(viewController: naviCon, animated: true)
    }
}
