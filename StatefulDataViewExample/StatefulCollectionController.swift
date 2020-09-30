//
//  StatefulCollectionController.swift
//  StatefulDataViewExample
//
//  Created by Sinar Nirmata on 30/09/20.
//  Copyright © 2020 Sinar Nirmata. All rights reserved.
//

import StatefulDataView
import UIKit

class StatefulCollectionController: UIViewController {
    @IBOutlet private var collectionView: StatefulCollectionView?
    
    private let fetcher = Fetcher()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView?.errorView = ErrorView(text: "Oops!", button: "Try Again")
        collectionView?.emptyView = EmptyView(text: "No Data")
        collectionView?.loadingView = LoadingView()
        
        collectionView?.setState(.empty)
        
        collectionView?.register(UINib(nibName: "ItemCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ItemCollectionCell")
        collectionView?.cellItemSize = CGSize(width: (collectionView!.frame.width - 12) / 2, height: 200)
        collectionView?.cellItemHandler = { indexPath in
            let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "ItemCollectionCell", for: indexPath) as! ItemCollectionCell
            let item = self.fetcher.items[indexPath.row]
            cell.configure(title: item.title,
                           author: item.author,
                           date: item.dateTaken,
                           image: item.media)
            return cell
        }
        collectionView?.cellItemSelectionHandler = { cell, indexPath in
            guard let cell = cell as? ItemCollectionCell else { return }
            print(cell)
        }
        collectionView?.setRefreshControl({ rc in
            self.fetcher.execute { photos in
                let items = photos ?? []
                DispatchQueue.main.async {
                    rc.endRefreshing()
                    self.collectionView?.setState(.populated(items))
                }
            }
        })
    }
    
    @IBAction
    func setError() {
        collectionView?.setState(.error(nil))
    }
    
    @IBAction
    func setEmpty() {
        collectionView?.setState(.empty)
    }
    
    @IBAction
    func setPopulated() {
        collectionView?.setState(.loading)
        fetcher.execute { photos in
            let items = photos ?? []
            DispatchQueue.main.async {
                self.collectionView?.setState(.populated(items))
            }
        }
    }
    
    @IBAction
    func setDismiss() {
        dismiss(animated: true, completion: nil)
    }
}
