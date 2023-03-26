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
    
    @IBOutlet weak var practicesView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var practicesLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    var chart = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        presenter.getData()
        presenter.loadPracticData()
    }
    
    func prepareViews(){
        practicesView.backgroundColor = UIColor(patternImage: UIImage(named: "background14")!)
        practicesView.layer.cornerRadius = 20
        practicsCollectionView.delegate = self
        practicsCollectionView.dataSource = self
        titleLabel.textColor = newButtonLabelColor
        practicesLabel.textColor = newButtonLabelColor
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
        xAxis.labelFont = UIFont(name: "Jost-Regular", size: 10)!
                xAxis.labelTextColor = newButtonLabelColor
                xAxis.centerAxisLabelsEnabled = true
                xAxis.granularity = 3600
                xAxis.valueFormatter = DateValueFormatter()
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.axisLineColor = blueBackgorundColor
                
        let leftAxis = chart.leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.labelFont = UIFont(name: "Jost-Regular", size: 10)!
        leftAxis.drawGridLinesEnabled = false
        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 5
        leftAxis.yOffset = -9
        leftAxis.drawAxisLineEnabled = true
        leftAxis.labelTextColor = newButtonLabelColor
        leftAxis.axisLineColor = blueBackgorundColor
        chart.rightAxis.enabled = false
        //chart.legend.form = .line
        chart.animate(xAxisDuration: 2.5)
        view.addSubview(chart)
        setupChartLayout()
        chart.data = presenter.moodChartData
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue, sender: sender)
    }

}

extension MoodViewController: MoodViewProtocol{
    func updateUI() {
        practicsCollectionView.reloadData()
    }
    func updateChart(){
        prepareChart()
    }
}

extension MoodViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1{
            performSegue(withIdentifier: "moodAllExcSegue", sender: nil)
        }
        else{
        performSegue(withIdentifier: "moodExcSegue", sender: indexPath.row)
        }
    }
    
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
