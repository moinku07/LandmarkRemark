//
//  NoteCollectionViewController.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 30/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit
import MapKit

protocol NoteCollectionViewControllerDelegate: NSObject {
    func didSelect(annotation: MKAnnotation, atIndex index: Int)
}

class NoteCollectionViewController: UICollectionViewController {
    
    weak var delegate: NoteCollectionViewControllerDelegate?
    
    var annotations: [MKAnnotation] = [MKAnnotation](){
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = .clear
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return annotations.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NoteCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCollectionViewCell
    
        cell.title.text = annotations[indexPath.row].title ?? ""
        cell.noteText.text = annotations[indexPath.row].subtitle ?? ""
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(annotation: annotations[indexPath.row], atIndex: indexPath.row)
    }

}
