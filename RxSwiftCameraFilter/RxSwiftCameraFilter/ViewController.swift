//
//  ViewController.swift
//  RxSwiftCameraFilter
//
//  Created by Yebin Kim on 2021/03/16.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
            fatalError("segue destination을 찾을 수 없음")
        }

        photosCVC.selectedPhoto.subscribe { [weak self] photo in

            self?.photoImageView.image = photo
            
        }.disposed(by: disposeBag)

    }

}

