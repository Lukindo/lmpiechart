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

@objc protocol LMPieChartDelegate: class{
    optional func chart(chart: LMPieChart, didSelectItemAtIndex index: Int, withValue value: Double, andPercentage percent:Double)
    optional func chartDidCancelSelection(chart: LMPieChart)

}

class LMPieChart: UIView {
    
    
    
    @IBOutlet weak var dataSource:LMPieChartDataSource?
    
    @IBOutlet weak var delegate:LMPieChartDelegate?
    
    let defaultColors = [UIColor(red: CGFloat(90/255.0), green: CGFloat(200/255.0), blue: CGFloat(250/255.0), alpha: CGFloat(1.0)),
        UIColor(red: CGFloat(255/255.0), green: CGFloat(204/255.0), blue: CGFloat(0), alpha: CGFloat(1.0)),
        UIColor(red: CGFloat(1.0), green: CGFloat(149/255.0), blue: CGFloat(0), alpha: CGFloat(1.0)),
        UIColor(red: CGFloat(1.0), green: CGFloat(45/255.0), blue: CGFloat(85/255.0), alpha: CGFloat(1.0)),
        UIColor(red: CGFloat(0), green: CGFloat(122/255.0), blue: CGFloat(1), alpha: CGFloat(1)),
        UIColor(red: CGFloat(76/255.0), green: CGFloat(217/255.0), blue: CGFloat(100/255.0), alpha: CGFloat(1)),
        UIColor(red: CGFloat(1), green: CGFloat(59/255.0), blue: CGFloat(48/255.0), alpha: CGFloat(1)),
        UIColor(red: CGFloat(142/255.0), green: CGFloat(142/255.0), blue: CGFloat(147/255.0), alpha: CGFloat(1))]
    
    var chartCenter:CGPoint{
        return convertPoint(center, fromView:superview)
    }
    
    var chartRadius:CGFloat{
        return min(bounds.size.width,bounds.size.height)/2*0.9
    }
    
    private var paths = [UIBezierPath]()
    private var values = [Double]()
    private var percentage = [Double]()
    private var itemSum = 0.0
    private var selected:Int?
    
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
        selected = nil
        for i in 0..<paths.count{
            if paths[i].containsPoint(position){
                selected = i
                delegate?.chart?(self, didSelectItemAtIndex: i, withValue: values[i], andPercentage: percentage[i])
                break
            }
        }
        self.setNeedsDisplay()
        if selected == nil{
            delegate?.chartDidCancelSelection?(self)
        }
    }
    
    override func drawRect(_: CGRect) {
        
        let itemCount = dataSource?.numberOfItemsInPieChart(self) ?? 0
        
        if let ds = dataSource {
        
            values = (0..<itemCount).map({ds.chart(self, valueForItemAtIndex: $0)})
            
            itemSum = values.reduce(0){ $0 + ($1 ?? 0) }
            
            if itemCount != 0 && itemSum != 0{
                paths.removeAll(keepCapacity: false)
                percentage.removeAll(keepCapacity: false)
                percentage = values.map(){$0/self.itemSum}
                
                var angle = CGFloat(0)
                for i in 0..<itemCount{
                    
                    var itemArc = UIBezierPath(arcCenter: chartCenter, radius: chartRadius, startAngle: angle, endAngle: angle+CGFloat(2*M_PI*(percentage[i])), clockwise: true)
                    itemArc.addLineToPoint(chartCenter)
                    itemArc.closePath()
                    paths.append(itemArc)
                
                    let colorForArc = ds.chart?(self, colorForItemAtIndex: i) ?? defaultColors[i % defaultColors.count]
                    colorForArc.set()
                
                    itemArc.fill()
                    
                    angle += CGFloat(2*M_PI*(percentage[i]))
                }
                
                if let sel = selected{
                    let selectedItem = paths[sel]
                    selectedItem.lineWidth = 2.0
                    UIColor.blackColor().setStroke()
                    selectedItem.stroke()
                }
                
            }
        
        }
    }

}
