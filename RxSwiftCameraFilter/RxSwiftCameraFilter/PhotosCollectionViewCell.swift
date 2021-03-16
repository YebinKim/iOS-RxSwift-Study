//
//  PhotosCollectionViewCell.swift
//  RxSwiftCameraFilter
//
//  Created by Yebin Kim on 2021/03/16.
//

import UIKit

final class PhotosCollectionViewCell: UICollectionViewCell {

    static var identifier: String {
        return String(describing: self)
    }

    @IBOutlet weak var photoImageView: UIImageView!
}
