import UIKit

class GradientView: UIView {
    
    override func draw(_ rect: CGRect) {
        // Create gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor] // Customize with your desired colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // Add gradient layer to the view's layer hierarchy
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
