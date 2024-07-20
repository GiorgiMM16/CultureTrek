//
//  CustomTabBar.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 7/12/24.
//

import UIKit

class CustomTabBar: UITabBar {

    private var shapeLayer: CALayer?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addShape()
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor(hex: "353A40").cgColor
        shapeLayer.fillColor = UIColor(hex: "353A40").cgColor
        shapeLayer.shadowColor = UIColor(hex: "353A40").cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 4)
        shapeLayer.shadowOpacity = 0.2
        shapeLayer.shadowRadius = 8
        
        if let oldShapeLayer = self.shapeLayer {
            oldShapeLayer.removeFromSuperlayer()
        }
        
        self.layer.insertSublayer(shapeLayer, at: 0)
        self.shapeLayer = shapeLayer
    }
    
    private func createPath() -> CGPath {
        let path = UIBezierPath(
            roundedRect: CGRect(
                x: self.bounds.minX + 10,
                y: self.bounds.minY - 14,
                width: self.bounds.width - 20,
                height: self.bounds.height + 28
            ),
            cornerRadius: (self.bounds.height + 28) / 2
        )
        return path.cgPath
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 60
        return sizeThatFits
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

#Preview{
    CustomTabBarController()
}
