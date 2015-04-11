//
//  ViewController.swift
//  LMPieChart
//
//  Created by Lukas Macko on 08/04/15.
//  Copyright (c) 2015 Lukas Macko. All rights reserved.
//

import UIKit

class ViewController: UIViewController,LMPieChartDataSource, LMPieChartDelegate {

    @IBOutlet weak var chart: LMPieChart!{
        didSet{
            chart.dataSource = self
            chart.delegate = self
        }
    }
    
    let values = [1,2,3,4,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func chart(chart: LMPieChart, valueForItemAtIndex index: Int) -> Double {
        return Double(values[index])
    }
    
    func numberOfItemsInPieChart(chart: LMPieChart) -> Int {
        return values.count
    }
    func chart(chart: LMPieChart, didSelectItemAtIndex index: Int, withValue value: Double, andPercentage percent: Double) {
        println("Selected index: \(index), value: \(value), percentage: \(percent) ")
    }


}

