//
//  PhotosCollectionViewController.swift
//  RxSwiftCameraFilter
//
//  Created by Yebin Kim on 2021/03/16.
//

import UIKit
import Photos
import RxSwift

final class PhotosCollectionViewController: UICollectionViewController {

    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObserver()
    }

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

                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    private func showConfirmAlert(
        title: String,
        message: String? = nil,
        actionHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: actionHandler)
        alert.addAction(confirmAction)

        self.present(alert, animated: true, completion: nil)
    }
}

extension PhotosCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.images.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as? PhotosCollectionViewCell else {
            fatalError("[cellForItemAt] PhotosCollectionViewCell 을 찾을 수 없음")
        }

        let asset: PHAsset = images[indexPath.row]
        let imageSize = CGSize(width: 100, height: 100)
        let manager = PHImageManager.default()

        manager.requestImage(
            for: asset,
            targetSize: imageSize,
            contentMode: .aspectFit,
            options: nil,
            resultHandler: { image, _ in

                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                }
            })

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedAsset = self.images[indexPath.row]
            let imageSize = CGSize(width: 300, height: 300)

            // requestImage 메서드는 두 번 불린다
            // 1번째 -> 썸네일 이미지 요청
            // 2번째 -> 오리지널 이미지 요청
            PHImageManager.default().requestImage(
                for: selectedAsset,
                targetSize: imageSize,
                contentMode: .aspectFit,
                options: nil,
                resultHandler: { [weak self] image, info in

                    guard let info = info else { return }

                    if let isDegradedImgage = info["PHImageResultIsDegradedKey"] as? Bool,
                       !isDegradedImgage,
                       let image = image {

                        self?.selectedPhotoSubject.onNext(image)
                        self?.dismiss(animated: true, completion: nil)
                    }
                })
        }
}
