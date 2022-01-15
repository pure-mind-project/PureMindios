//
//  MoodViewController.swift
//  PureMind
//
//  Created by Клим on 17.08.2021.
//

import UIKit
import Charts

protocol MoodViewProtocol: UIViewController{
    func updateUI()
    func updateChart()
}

class MoodViewController: UIViewController, ChartViewDelegate {
    var presenter: MoodPresenterProtocol!
    
    @IBOutlet weak var practicsCollectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIView!
    var chart = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        prepareChart()
    }
    
    
    
    func prepareCollectionView(){
        practicsCollectionView.delegate = self
        practicsCollectionView.dataSource = self
    }
    
    func prepareChart(){
        chart.delegate = self
        chart.frame = CGRect(x: 38, y: 268, width: 293, height: 345)
        chart.legend.enabled = false
        chart.drawGridBackgroundEnabled = false
        chart.chartDescription!.enabled = false
        chart.gridBackgroundColor = UIColor(red: 198, green: 222, blue: 255, alpha: 0.2)
        chart.dragEnabled = false
        chart.setScaleEnabled(false)
        chart.pinchZoomEnabled = false
        chart.highlightPerDragEnabled = false
        chart.backgroundColor = UIColor(red: 198, green: 222, blue: 255, alpha: 0.2)
        chart.borderColor = UIColor(red: 198, green: 222, blue: 255, alpha: 1)
        chart.layer.cornerRadius = 15
        let xAxis = chart.xAxis
        xAxis.labelPosition = .bottomInside
                xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
                xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
                xAxis.drawAxisLineEnabled = false
                //xAxis.drawGridLinesEnabled = true
                xAxis.centerAxisLabelsEnabled = true
                xAxis.granularity = 3600
                xAxis.valueFormatter = DateValueFormatter()
        xAxis.drawAxisLineEnabled = false
        xAxis.axisLineColor = UIColor(red: 198, green: 222, blue: 255, alpha: 1)
                
                let leftAxis = chart.leftAxis
                leftAxis.labelPosition = .insideChart
                leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
                //leftAxis.drawGridLinesEnabled = true
                leftAxis.granularityEnabled = true
                leftAxis.axisMinimum = 0
                leftAxis.axisMaximum = 170
                leftAxis.yOffset = -9
        leftAxis.drawAxisLineEnabled = false
                leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        leftAxis.axisLineColor = UIColor(red: 198, green: 222, blue: 255, alpha: 1)
                chart.rightAxis.enabled = false
                //chart.legend.form = .line
                chart.animate(xAxisDuration: 2.5)
        view.addSubview(chart)
        setupChartLayout()
        chart.data = presenter.setDataCount(30, range: 90)
    }
    
    func setupChartLayout(){
        let margins = contentView.layoutMarginsGuide
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        chart.topAnchor.constraint(equalTo: margins.topAnchor, constant: 45).isActive = true
        chart.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -483).isActive = true
        chart.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.406742).isActive = true
        
        //pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //pieChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        chart.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true //right
        chart.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true //left
    }
    
    @objc func moveToDiary(){
        print("Coming soon!")
    }
    
    @objc func moveToChat(){
        performSegue(withIdentifier: "chatMoodSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue, sender: nil)
    }

}

extension MoodViewController: MoodViewProtocol{
    func updateUI() {
        practicsCollectionView.reloadData()
    }
    
    func updateChart() {
        print("o")
    }
}

extension MoodViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.practicsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = practicsCollectionView.dequeueReusableCell(withReuseIdentifier: PracticViewCell.identifier, for: indexPath) as? PracticViewCell
        else {fatalError("Invalid Cell kind")}
        presenter.prepareCell(cell: cell, index: indexPath.row)
        return cell
    }
}
