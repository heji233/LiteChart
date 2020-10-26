//
//  LiteChartContentView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/12.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

public class LiteChartContentView: UIView, LiteChartAreaLayoutGuide, LiteChartAnimatable {
    internal var areaLayoutGuide: UILayoutGuide {
        self.safeAreaLayoutGuide
    }
    
    internal var animationStatus: LiteChartAnimationStatus {
        return .ready
    }
    
    internal func startAnimation(animation: LiteChartAnimationInterface) {
        
    }
    
    internal func pauseAnimation() {
        
    }
    
    internal func stopAnimation() {
        
    }
    
    internal func continueAnimation() {
        
    }
}
