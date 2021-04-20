//
//  Router.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/20.
//

import UIKit

// MARK: - AppCoordinator
// https://brunch.co.kr/@yoonms/31
protocol Router: class {
    func show(_ viewController: UIViewController, animated: Bool, isModal: Bool)
    func hide(animated: Bool)
}

extension UIWindow: Router {

    func show(_ viewController: UIViewController, animated: Bool, isModal: Bool = false) {
        rootViewController = viewController
        makeKeyAndVisible()
    }

    func hide(animated: Bool) {
        rootViewController = nil
    }
}

extension UIViewController: Router {

    func show(_ viewController: UIViewController, animated: Bool, isModal: Bool = false) {
        if !isModal,
           let naviCon = self as? UINavigationController {
            naviCon.pushViewController(viewController, animated: animated)
        } else {
            self.present(viewController, animated: animated)
        }
    }

    func hide(animated: Bool) {
        if let naviCon = self as? UINavigationController {
            naviCon.popViewController(animated: animated)
        } else {
            self.dismiss(animated: animated, completion: nil)
        }
    }
}
