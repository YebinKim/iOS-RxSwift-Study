//
//  UIView+Extension.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/26.
//

import UIKit

extension UIView {

    func setGradient(
        colors: [UIColor],
        locations: [NSNumber]? = [0.0, 0.25, 0.7],
        cornerRadius: CGFloat = 0
    ) {
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = cornerRadius
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(gradient, at: 0)
    }

    func setBackgroundGradient() {
        setGradient(colors: Colors.backGradient)
    }
}
