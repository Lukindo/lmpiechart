# LMPieChart
The ```LMPieChart``` is a custom ```UIView``` subclass for plotting pie charts. The chart requires an object that act as a datasource. The data source must adopt the ```LMPieChartDataSource protocol```. The chart item selections can be handled by delegate adopting ```LMPieChartDelegate protocol```.
##Usage
- add ```LMPieChart.swift``` to your project
- set up class for ```UIView``` to ```LMPieChart```
- specify datasource for the chart
- implement:
```swift
func numberOfItemsInPieChart(chart: LMPieChart) -> Int
```
```swift
func chart(chart: LMPieChart, valueForItemAtIndex index: Int) -> Double
```
##API
...
