//
//  FilterViewController.swift
//  RxSwiftCameraFilter
//
//  Created by Yebin Kim on 2021/03/16.
//

import UIKit
import RxSwift

class FilterViewController: UIViewController {

    @IBOutlet weak var applyFilterButton: UIButton!
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

            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
            
        }.disposed(by: disposeBag)
    }

    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }

    @IBAction func applyFilterButtonPressed() {
        guard let sourceImage = self.photoImageView.image else { return }

        FilterService().applyFilter(to: sourceImage)
            .subscribe { [weak self] filteredImage in

                DispatchQueue.main.async {
                    self?.updateUI(with: filteredImage)
                }

            }.disposed(by: disposeBag)
    }
}

