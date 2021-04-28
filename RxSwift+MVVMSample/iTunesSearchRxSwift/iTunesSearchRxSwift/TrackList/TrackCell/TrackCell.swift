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
        applyStyle()
    }

    override func prepareForReuse() {
        self.thumbnailImageView.image = nil
        self.songNameLabel.text = nil
        self.artistNameLabel.text = nil
    }

    private func applyStyle() {
        self.contentView.setGradient(
            colors: Colors.cellBackGradient,
            locations: nil
        )

        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.width / 2.0
        songNameLabel.textColor = Colors.whiteSolid
        artistNameLabel.textColor = Colors.graySolid
    }
}
