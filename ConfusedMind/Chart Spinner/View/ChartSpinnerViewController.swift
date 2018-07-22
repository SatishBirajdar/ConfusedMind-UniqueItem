//
//  SelectItemViewController.swift
//  ConfusedMind
//
//  Created by Satish Birajdar on 2017-10-04.
//  Copyright © 2017 SBSoftwares. All rights reserved.
//

import Foundation
import UIKit
import Charts
import CoreData
import AVFoundation

class ChartSpinnerViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var itemsView: PieChartView!
    @IBOutlet weak var emptyChartView: UIView!
    @IBOutlet weak var spinButton: UIButton!
    
    @IBOutlet weak var speakerButton: UIButton!
    
    var managedContext = ManagedContext()
    var items : [NSManagedObject] = []
    var chartItems: [ChartItem] = []
    var nonVisitedChartItems: [ChartItem] = []
    var nonVisitedIndexes: [Int] = []
    
    var seconds = 1
    var timer = Timer()
    var isTimerRunning = false
    
    var aRandomInt = 0.0
    
    var isSpeakerEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            
        } else {
            // Fallback on earlier versions
        }
        
        initialScreenSetup()
    }
    
    func initialScreenSetup() {
        navigationController?.navigationBar.tintColor = UIColor.white
        emptyChartView.isHidden = true
        itemsView.chartDescription?.text = ""
        itemsView.highlightPerTapEnabled = false
        spinButton.layer.cornerRadius = 12
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        itemsView.noDataText = "No data"
        items = managedContext.fetchOptions()
        contextToObject(items)
        showChartViewWithOptions(optionsCount: items.count)
    }
    
    func contextToObject(_ items: [NSManagedObject]){
        var chartItem : ChartItem
        for i in 0 ... (items.count-1) {
            chartItem = ChartItem(id: i, visited: false, data: (items[Int(i)].value(forKeyPath: "name") as? String)!)
            chartItems.append(chartItem)
        }
    }
    
    func showChartViewWithOptions(optionsCount: Int){
        guard optionsCount != 0 else {
            emptyChartView.isHidden = false
            itemsView.isHidden = true
            spinButton.isHidden = true
            speakerButton.isHidden = true
            return
        }
        
        emptyChartView.isHidden = true
        itemsView.isHidden = false
        spinButton.isHidden = false
        speakerButton.isHidden = false
        setChart(dataPoints: items)
        
        /**
         Notify PieChart about the change
         */
        itemsView.notifyDataSetChanged()
        itemsView.delegate = self
    }
    
    @IBAction func spinButtonAction(_ sender: Any) {
        spinAction()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ChartSpinnerViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc func updateTimer() {
        
        if self.seconds < 0 {
            timer.invalidate()
            itemsView.centerText = ""
            itemsView.highlightValue(x: aRandomInt, y: 0.0, dataSetIndex: 0)
            
            self.seconds = 1
            isTimerRunning = false
            
            
            chartItems = chartItems.map{
                var chartItem = $0
                if $0.id == Int(aRandomInt) {
                    chartItem.visited = true
                }
                return chartItem
            }
            
            nonVisitedChartItems = chartItems.filter { !$0.visited }
            nonVisitedIndexes = nonVisitedChartItems.map { $0.id }
            
//            let itemName = items[Int(aRandomInt)].value(forKeyPath: "name") as? String
            let itemName = nonVisitedChartItems[Int(aRandomInt)].data
            let synth = AVSpeechSynthesizer()
            let myUtterance = AVSpeechUtterance(string: itemName)
            myUtterance.rate = 0.5
            

            
//            nonVisitedIndexes = chartItems.filter { item in !item.visited { $0.id }   }
            


            if isSpeakerEnabled {
                synth.speak(myUtterance)
            } else {
                synth.stopSpeaking(at: AVSpeechBoundary.word)
            }
        } else {
            self.seconds -= 1
        }
    }
    
    func generateRandomNumber(min: Int, max: Int) -> Double {
        let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
        return Double(randomNum)
    }
    
    @IBAction func speakerButtonClicked(_ sender: UIButton) {
        let speaker = UIImage(named: "soundSpeaker")
        let mute = UIImage(named: "soundMute")
        guard isSpeakerEnabled else {
            isSpeakerEnabled = true
            sender.setImage(speaker, for: UIControlState.normal)
            return
        }
        sender.setImage(mute, for: UIControlState.normal)
        isSpeakerEnabled = false
    }
}

extension ChartSpinnerViewController: ChartSpinnerPresenterView {
    func setChart(dataPoints: [NSManagedObject]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let item = self.items[i]
            let itemName = item.value(forKeyPath: "name") as? String
            
            let dataEntry = PieChartDataEntry(value: 1.0, label: itemName, data:  dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartData.setDrawValues(false)
        self.itemsView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        pieChartDataSet.colors = colors
    }
    
    func spinAction() {
        itemsView.highlightValue(x: -1, y: -1, dataSetIndex: 0)
        aRandomInt = generateRandomNumber(min:0, max: self.nonVisitedIndexes.count)
        
        self.itemsView.spin(duration: 3, fromAngle: 0, toAngle: 1080)
        
        let myString = "spinning..."
        let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        
        itemsView.centerAttributedText = myAttrString
        
        if isTimerRunning == false {
            runTimer()
        }
    }
    
}
