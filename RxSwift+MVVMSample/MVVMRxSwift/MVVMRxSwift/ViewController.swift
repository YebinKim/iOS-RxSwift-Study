//
//  ViewController.swift
//  MVVMRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import UIKit

class ViewController: UIViewController {

    static func instantiate() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! ViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

