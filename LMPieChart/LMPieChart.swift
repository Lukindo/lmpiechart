//
//  LMPieChart.swift
//  LMPieChart
//
//  Created by Lukas Macko on 08/04/15.
//  Copyright (c) 2015 Lukas Macko. All rights reserved.
//

import UIKit

@objc protocol LMPieChartDataSource: class{
    
    func numberOfItemsInPieChart(chart: LMPieChart) -> Int
    
    func chart(chart: LMPieChart, valueForItemAtIndex index: Int) -> Double
    
    optional func chart(chart: LMPieChart, colorForItemAtIndex: Int) -> UIColor
    
}

class LMPieChart: UIView {
    
    weak var dataSource:LMPieChartDataSource?
    
    let defaultColors = [UIColor.blueColor(),UIColor.redColor(),UIColor.orangeColor(),UIColor.greenColor()]
    
    var chartCenter:CGPoint{
        return convertPoint(center, fromView:superview)
    }
    
    var chartRadius:CGFloat{
        return min(bounds.size.width,bounds.size.height)/2*0.9
    }
    
    override func drawRect(rect: CGRect) {
        
        let itemCount = dataSource?.numberOfItemsInPieChart(self) ?? 0
        
        let values = (0..<itemCount).map({self.dataSource?.chart(self, valueForItemAtIndex: $0)})
        
        let itemSum = values.reduce(0){ $0 + ($1 ?? 0) }
        
        if itemCount != 0 && itemSum != 0{
            println("Kreslim")
            
            var angle = CGFloat(0)
            for i in 0..<itemCount{
                if let val = values[i]{
                        println("\(i): \(val) \(val/itemSum)")
                    
                        let itemArc = UIBezierPath(arcCenter: chartCenter, radius: chartRadius, startAngle: angle, endAngle: angle+CGFloat(2*M_PI*(val/itemSum)), clockwise: true)
                        itemArc.lineWidth = CGFloat(3.0)
                    
                        let colorForArc = dataSource?.chart?(self, colorForItemAtIndex: i) ?? defaultColors[i % defaultColors.count]
                        colorForArc.set()
                    
                        itemArc.stroke()
                    
                        angle += CGFloat(2*M_PI*(val/itemSum))
                }
            }
        }
        else{
            println("Nekreslim")
        }

    }

}
