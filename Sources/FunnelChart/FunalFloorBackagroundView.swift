//
//  FunalFloorBackagroundView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class FunalFloorBackagroundView: UIView {
    
    private var configure: FunalFloorBackagroundViewConfigure
    
    init(configure: FunalFloorBackagroundViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        self.configure = .emptyConfigure
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.setNeedsDisplay()
    }
    
    override func display(_ layer: CALayer) {
        LiteChartDispatchQueue.asyncDrawQueue.async {
            layer.contentsScale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, layer.contentsScale)
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            let rect = layer.bounds
            context?.clear(rect)
            context?.setAllowsAntialiasing(true)
            context?.setShouldAntialias(true)
            let topLeft = rect.width * (1 - self.configure.topPercent) / 2
            let topStartX = rect.origin.x + topLeft
            let topEndX = rect.origin.x + rect.width - topLeft
            let bottomLeft = rect.width * (1 - self.configure.bottomPercent) / 2
            let bottomStartX = rect.origin.x + bottomLeft
            let bottomEndX = rect.origin.x + rect.width - bottomLeft
            let topLeftPoint = CGPoint(x: topStartX, y: rect.origin.y)
            let topRightPoint = CGPoint(x: topEndX, y: rect.origin.y)
            let bottomLeftPoint = CGPoint(x: bottomStartX, y: rect.origin.y + rect.height)
            let bottomRightPoint = CGPoint(x: bottomEndX, y: rect.origin.y + rect.height)
            context?.addLines(between: [topLeftPoint, topRightPoint, bottomRightPoint, bottomLeftPoint, topLeftPoint])
            context?.setFillColor(self.configure.color.color.cgColor)
            context?.drawPath(using: .fill)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            context?.restoreGState()
            UIGraphicsEndImageContext()
            LiteChartDispatchQueue.asyncDrawDoneQueue.async {
                layer.contents = image?.cgImage
            }
        }
    }
    
}
