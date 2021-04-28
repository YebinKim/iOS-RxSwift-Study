//
//  UIButton+Extension.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/28.
//

import UIKit

extension UIButton {

    func setGradientToButton(
        colors: [UIColor],
        locations: [NSNumber]? = [0.0, 0.25, 0.7],
        isRounded: Bool = false
    ) {
        self.setGradient(colors: colors, locations: locations, isRounded: isRounded)
        if let imageView = imageView {
            self.bringSubviewToFront(imageView)
        }
    }
}
