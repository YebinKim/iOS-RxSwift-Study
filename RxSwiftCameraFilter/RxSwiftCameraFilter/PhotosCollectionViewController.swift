//
//  PhotosCollectionViewController.swift
//  RxSwiftCameraFilter
//
//  Created by Yebin Kim on 2021/03/16.
//

import UIKit
import Photos

final class PhotosCollectionViewController: UICollectionViewController {

    private var images = [PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()

        populatePhotos()
    }

    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { object, count, stop in
                    self?.images.append(object)
                }
                self?.images.reverse()
            }
        }
    }
}
