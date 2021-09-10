//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 07.09.2021.
//

import UIKit
import Moya
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.register(nibModels: [DegreesTVCell.self, DegreesByHoursTVCell.self, DailyTVCell.self, SunTVCell.self])
        }
    }
    var model: WeatherViewModel!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    func setupScreen() {
        let blueColor = UIColor(red: 0.039, green: 0.606, blue: 0.925, alpha: 1)
        self.view.backgroundColor = blueColor
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 220
       
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: 0,
                                       width: refreshControl.bounds.size.width,
                                       height: refreshControl.bounds.size.height)
        refreshControl.addTarget(model, action: #selector(model.refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.sendSubviewToBack(refreshControl)
        model.loadData()
    }
   
}
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.numberOfRowsInSection(section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let modelCell: CellViewAnyModel = model.setupModelForCellAt(indexPath)
        return tableView.dequeueReusableCell(withModel: modelCell, for: indexPath)
      
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
