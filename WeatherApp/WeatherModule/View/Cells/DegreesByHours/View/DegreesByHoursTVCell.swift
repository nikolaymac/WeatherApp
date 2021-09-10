//
//  DegreesByHoursTVCell.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 08.09.2021.
//

import UIKit

class DegreesByHoursTVCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.register(UINib(nibName: "DegreesHourCVCell", bundle: nil), forCellWithReuseIdentifier: "DegreesHourCVCell")
        }
    }
    var viewModel: DegreesByHoursTVModel! {
        didSet {
            updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func updateUI() {
        collectionView.reloadData()
    }
    
}
extension DegreesByHoursTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let modelCell: CellViewAnyModel = viewModel.setupModelForCellAt(indexPath)
        return collectionView.dequeueReusableCell(withModel: modelCell, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: collectionView.frame.height)
    }
}
