//
//  BarViewCoupleCollection.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/9/30.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class BarViewCoupleCollection: UIView {
    let configure: BarViewCoupleCollectionConfigure
    
    var barViewCoupleViews: [BarViewCouple] = []
    
    init(configure: BarViewCoupleCollectionConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertBarViewCoupleView()
        
        updateBarViewCoupleViewStaticConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        self.configure = BarViewCoupleCollectionConfigure.emptyConfigure
        super.init(coder: coder)
        insertBarViewCoupleView()
        
        updateBarViewCoupleViewStaticConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateBarViewCoupleViewDynamicConstraints()
    }
    
    private func insertBarViewCoupleView() {
        for view in self.barViewCoupleViews {
            view.removeFromSuperview()
        }
        self.barViewCoupleViews = []
        for configure in self.configure.models {
            let view = BarViewCouple(configure: configure)
            self.addSubview(view)
            self.barViewCoupleViews.append(view)
        }
    }
    
    private func updateBarViewCoupleViewStaticConstraints() {
        let itemCount = self.barViewCoupleViews.count
        guard itemCount > 0 else {
            return
        }
        
        var frontView: BarViewCouple?
        switch self.configure.direction {
        case .bottomToTop:
            for barView in self.barViewCoupleViews {
                barView.snp.remakeConstraints{
                    make in
                    if let front = frontView {
                        make.leading.equalTo(front.snp.trailing)
                        make.width.equalTo(front.snp.width)
                    } else {
                        make.leading.equalToSuperview()
                        make.width.equalTo(0)
                    }
                    make.bottom.equalToSuperview()
                    make.top.equalToSuperview()
                }
                frontView = barView
            }
        case .leftToRight:
            for barView in self.barViewCoupleViews {
                barView.snp.remakeConstraints{
                    make in
                    if let front = frontView {
                        make.height.equalTo(front.snp.height)
                        make.bottom.equalTo(front.snp.top)
                    } else {
                        make.height.equalTo(0)
                        make.bottom.equalToSuperview()
                    }
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                }
                frontView = barView
            }
        }
    }
    
    private func updateBarViewCoupleViewDynamicConstraints() {
        let itemCount = self.barViewCoupleViews.count
        guard itemCount > 0 else {
            return
        }
        guard let first = self.barViewCoupleViews.first else {
            return
        }
        switch self.configure.direction {
        case .bottomToTop:
            let itemWidth = self.bounds.width / CGFloat(itemCount)
            first.snp.updateConstraints{
                make in
                make.width.equalTo(itemWidth)
            }
        case .leftToRight:
            let itemHeight = self.bounds.height / CGFloat(itemCount)
            first.snp.updateConstraints{
                make in
                make.height.equalTo(itemHeight)
            }
        }
    }
}

extension BarViewCoupleCollection: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.animationStatus == .ready || self.animationStatus == .cancel || self.animationStatus == .finish else {
            return
        }
        for barView in self.barViewCoupleViews {
            barView.startAnimation(animation: animation)
        }
    }
    
    func stopAnimation() {
        guard self.animationStatus == .running || self.animationStatus == .pause else {
            return
        }
        for barView in self.barViewCoupleViews {
            barView.stopAnimation()
        }
    }
    
    func pauseAnimation() {
        guard self.animationStatus == .running else {
            return
        }
        for barView in self.barViewCoupleViews {
            barView.pauseAnimation()
        }
    }
    
    func continueAnimation() {
        guard self.animationStatus == .pause else {
            return
        }
        for barView in self.barViewCoupleViews {
            barView.continueAnimation()
        }
    }
    
    var animationStatus: LiteChartAnimationStatus {
        self.barViewCoupleViews.reduce(LiteChartAnimationStatus.ready, {
            $0.compactAnimatoinStatus(another: $1.animationStatus)
        })
    }
}
