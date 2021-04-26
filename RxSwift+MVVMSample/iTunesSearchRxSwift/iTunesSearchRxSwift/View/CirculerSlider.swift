//
//  CirculerSlider.swift
//  iTunesSearchRxSwift
//
//  Created by Yebim Kim on 2021/04/27.
//

import UIKit
import RxSwift
import RxCocoa

class CirculerSlider: UIControl {

    // MARK: Private Properties
    private let renderer = CirculerSliderRenderer()

    // MARK: UI
    private var volumeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.whiteSolid
        label.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Public Properties
    var minimumValue: Float = 0
    var maximumValue: Float = 1

    var value: Float = 0.3 {
        didSet {
            let volumeLabelText = String("\(Int(value * 100))%")
            self.volumeLabel.text = volumeLabelText
            sendActions(for: .valueChanged)
        }
    }

    var lineWidth: CGFloat {
        get { return renderer.lineWidth }
        set { renderer.lineWidth = newValue }
    }

    var startAngle: CGFloat {
        get { return renderer.startAngle }
        set { renderer.startAngle = newValue }
    }

    var endAngle: CGFloat {
        get { return renderer.endAngle }
        set { renderer.endAngle = newValue }
    }

    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Interface
    func setValue(_ newValue: Float) {
        value = min(maximumValue, max(minimumValue, newValue))

        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = CGFloat(value - minimumValue) / CGFloat(valueRange) * angleRange + startAngle
        renderer.setPointerAngle(angleValue)
        renderer.updateTrackLayerPath()
    }

    // MARK: Private Methods
    private func commonInit() {
        setValue(value)

        renderer.updateBounds(bounds)
        renderer.color = tintColor
        renderer.setPointerAngle(renderer.startAngle)
        renderer.setTrackLayer(layer)

        let gestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(CirculerSlider.handleGesture(_:)))
        addGestureRecognizer(gestureRecognizer)

        setVolumeLabel()
    }

    private func setVolumeLabel() {
        self.addSubview(volumeLabel)

        NSLayoutConstraint.activate([
            volumeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            volumeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    // MARK: Gesture Action
    @objc
    private func handleGesture(_ gesture: RotationGestureRecognizer) {
        let midPointAngle = (2 * CGFloat(Double.pi) + startAngle - endAngle) / 2 + endAngle
        var boundedAngle = gesture.touchAngle
        if boundedAngle > midPointAngle {
            boundedAngle -= 2 * CGFloat(Double.pi)
        } else if boundedAngle < (midPointAngle - 2 * CGFloat(Double.pi)) {
            boundedAngle += 2 * CGFloat(Double.pi)
        }

        boundedAngle = min(endAngle, max(startAngle, boundedAngle))

        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue

        print(angleValue)
        setValue(angleValue)

        sendActions(for: .valueChanged)
    }
}

private class CirculerSliderRenderer {

    // MARK: Private Properties
    private let trackLayer = CAShapeLayer()

    private var pointerAngle: CGFloat = CGFloat(Double.pi)

    // MARK: Public Properties
    var color: UIColor = Colors.blueSolid {
        didSet {
            trackLayer.strokeColor = color.cgColor
            updateTrackLayerPath()
        }
    }

    var lineWidth: CGFloat = 15 {
        didSet {
            trackLayer.lineWidth = lineWidth
            updateTrackLayerPath()
        }
    }

    var startAngle: CGFloat = CGFloat(-Double.pi) * (1 / 2) {
        didSet {
            updateTrackLayerPath()
        }
    }

    var endAngle: CGFloat = CGFloat(Double.pi) * (3 / 2) {
        didSet {
            updateTrackLayerPath()
        }
    }

    // MARK: Initializer
    init() {
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = color.cgColor
        trackLayer.lineWidth = lineWidth
    }

    // MARK: - Interface
    func setTrackLayer(_ layer: CALayer) {
        layer.addSublayer(trackLayer)
    }

    func setPointerAngle(_ newPointerAngle: CGFloat) {
        pointerAngle = newPointerAngle
    }

    func updateBounds(_ bounds: CGRect) {
        trackLayer.bounds = bounds
        trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        updateTrackLayerPath()
    }

    func updateTrackLayerPath() {
        let bounds = trackLayer.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let offset = lineWidth / 2
        let radius = min(bounds.width, bounds.height) / 2 - offset

        let ring = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: pointerAngle, clockwise: true)
        trackLayer.path = ring.cgPath
    }
}

private class RotationGestureRecognizer: UIPanGestureRecognizer {

    private(set) var touchAngle: CGFloat = 0

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        updateAngle(with: touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        updateAngle(with: touches)
    }

    private func updateAngle(with touches: Set<UITouch>) {
        guard let touch = touches.first,
            let view = view else { return }

        let touchPoint = touch.location(in: view)
        touchAngle = angle(for: touchPoint, in: view)
    }

    private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
        let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
        return atan2(centerOffset.y, centerOffset.x)
    }

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)

        maximumNumberOfTouches = 1
        minimumNumberOfTouches = 1
    }
}

// MARK: CirculerSlider -> For use in RxSwift
// rx로 사용할 수 있으려면 value 확장이 필요함
extension Reactive where Base: CirculerSlider {

    var value: ControlProperty<Float> {
        return base.rx.controlProperty(
            editingEvents: UIControl.Event.valueChanged,
            getter: { control in
                return control.value
            },
            setter: { control, newValue in
                control.value = newValue
            }
        )
    }
}
