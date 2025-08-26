
import UIKit

public extension CAGradientLayer {
    static func create(colors: [UIColor] = [UIColor.startGradientColor, UIColor.endGradientColor],
                       startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                       endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
                       locations: [NSNumber] = [0, 1],
                       type: CAGradientLayerType = .axial) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        gradientLayer.type = type

        return gradientLayer
    }
}
