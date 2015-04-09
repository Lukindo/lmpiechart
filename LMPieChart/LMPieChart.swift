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
    
    
    
    @IBOutlet weak var dataSource:LMPieChartDataSource?
    
    let defaultColors = [UIColor.blueColor(),UIColor.redColor(),UIColor.orangeColor(),UIColor.greenColor()]
    
    var chartCenter:CGPoint{
        return convertPoint(center, fromView:superview)
    }
    
    var chartRadius:CGFloat{
        return min(bounds.size.width,bounds.size.height)/2*0.9
    }
    
    var paths = [UIBezierPath]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func setup(){
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tap:"))
    }
    
    func tap(gesture:UITapGestureRecognizer){
        let position = gesture.locationInView(self)
        println("Tap: \(position)")
        
        for i in 0..<paths.count{
            if paths[i].containsPoint(position){
                println("Tapped: \(i)")
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let itemCount = dataSource?.numberOfItemsInPieChart(self) ?? 0
        
        let values = (0..<itemCount).map({self.dataSource?.chart(self, valueForItemAtIndex: $0)})
        
        let itemSum = values.reduce(0){ $0 + ($1 ?? 0) }
        
        if itemCount != 0 && itemSum != 0{
            paths.removeAll(keepCapacity: false)
            var angle = CGFloat(0)
            for i in 0..<itemCount{
                if let val = values[i]{
                        println("\(i): \(val) \(val/itemSum)")
                    
                        var itemArc = UIBezierPath(arcCenter: chartCenter, radius: chartRadius, startAngle: angle, endAngle: angle+CGFloat(2*M_PI*(val/itemSum)), clockwise: true)
                        itemArc.addLineToPoint(chartCenter)
                        itemArc.closePath()
                        paths.append(itemArc)
                    
                        let colorForArc = dataSource?.chart?(self, colorForItemAtIndex: i) ?? defaultColors[i % defaultColors.count]
                        colorForArc.set()
                    
                        itemArc.fill()
                   
                        angle += CGFloat(2*M_PI*(val/itemSum))
                }
            }
        }
    

    }

}
