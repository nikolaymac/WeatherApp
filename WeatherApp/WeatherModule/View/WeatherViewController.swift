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
            tableView.delegate = self
            tableView.register(nibModels: [DegreesTVCell.self, DegreesByHoursTVCell.self, DailyTVCell.self, SunTVCell.self])
        }
    }
    var model: WeatherViewModel!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    func updateData(error: WeatherError? = nil) {
        if error != nil {
            showErrorVC(error: error)
//            switch error {
//            case .noInternetConnection:
//                showErrorVC(error: "We have problem with internet!")
//            case .dataFailure:
//                showErrorVC(error: "Fail receive data")
//            default:
//                break
//            }
        }
       
        refreshControl.endRefreshing()
        tableView?.reloadData()
        if let header = tableView.tableHeaderView as? MyCustomHeader {
            header.viewModel = model.modelDegrees()
            view.setNeedsLayout()
        }
    }
    func setupScreen() {
      
        tableView.estimatedRowHeight = 220
        let headerView = MyCustomHeader(reuseIdentifier: "sectionHeader")
        headerView.viewModel = model.modelDegrees()
        
        tableView.tableHeaderView = headerView 

        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: 50,
                                       width: refreshControl.bounds.size.width,
                                       height: refreshControl.bounds.size.height)
        refreshControl.addTarget(model, action: #selector(model.refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.sendSubviewToBack(refreshControl)
        setupData()
    }
    
    func setupData() {
        model.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = tableView.tableHeaderView {

            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }

    func showErrorVC(error: WeatherError?) {
        if let vc = storyboard?.instantiateViewController(identifier: "ErrorViewController") as? ErrorViewController {
            vc.error = error
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        }
       
    }
    @IBAction func unwindToWeather(_ unwindSegue: UIStoryboardSegue) {
        setupData()
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
}
