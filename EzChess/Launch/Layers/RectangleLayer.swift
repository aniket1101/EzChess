//
//  RectangleLayer.swift
//  EzChess
//
//  Created by Aniket Gupta on 21/10/2021.
//

import UIKit

class RectangleLayer: CAShapeLayer {
  
  override init() {
    super.init()
      fillColor = Colors.clear.cgColor
    lineWidth = 5.0
      path = rectanglePathFull.cgPath
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var rectanglePathFull: UIBezierPath {
      let rectanglePath = UIBezierPath()
      rectanglePath.move(to: CGPoint(x: 0.0, y: 100.0))
      rectanglePath.addLine(to: CGPoint(x: 0.0, y: -lineWidth))
      rectanglePath.addLine(to: CGPoint(x: 100.0, y: -lineWidth))
      rectanglePath.addLine(to: CGPoint(x: 100.0, y: 100.0))
      rectanglePath.addLine(to: CGPoint(x: -lineWidth / 2, y: 100.0))
      rectanglePath.close()
    return rectanglePath
  }
    
    func animateStrokeWithColor(color: UIColor) {
        strokeColor = color.cgColor
        let strokeAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.duration = 0.4
        add(strokeAnimation, forKey: nil)
    }
}

