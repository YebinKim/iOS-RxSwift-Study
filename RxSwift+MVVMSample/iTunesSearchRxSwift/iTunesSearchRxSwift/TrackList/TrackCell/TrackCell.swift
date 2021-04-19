//
//  TrackCell.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/18.
//

import UIKit

final class TrackCell: UITableViewCell {

    // MARK: Static Properties
    static var identifier: String {
        String(describing: self)
    }
    static var cellForHeight: CGFloat {
        80
    }

    // MARK: IBOutlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!

    // MARK: - Initializer
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        self.thumbnailImageView.image = nil
        self.songNameLabel.text = nil
        self.artistNameLabel.text = nil
    }
}
