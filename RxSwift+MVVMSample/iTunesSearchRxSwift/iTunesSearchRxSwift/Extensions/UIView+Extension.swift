//
//  UIView+Extension.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/26.
//

import UIKit

extension UIView {

    func setGradient(colors: [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = []
        for color in colors {
            gradient.colors?.append(color.cgColor)
        }

        gradient.locations = [0.0, 0.25, 0.7]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }

    func setBackgroundGradient() {
        setGradient(colors: Colors.backGradient)
    }
}
