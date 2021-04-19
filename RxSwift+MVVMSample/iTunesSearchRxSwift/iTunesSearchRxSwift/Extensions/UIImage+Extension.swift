//
//  UIImage+Extension.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/19.
//

import UIKit

extension UIImageView {

    func setImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("[UIImageView] setImage URL 오류")
            return
        }

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
    }
}
