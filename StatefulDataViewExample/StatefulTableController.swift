//
//  ViewController.swift
//  StatefulDataViewExample
//
//  Created by Sinar Nirmata on 30/09/20.
//  Copyright © 2020 Sinar Nirmata. All rights reserved.
//

import StatefulDataView
import UIKit

class StatefulTableController: UIViewController {
    @IBOutlet private var tableView: StatefulTableView?
    
    private let fetcher = Fetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView?.errorView = ErrorView(text: "Oops!", button: "Try Again")
        tableView?.emptyView = EmptyView(text: "No Data")
        tableView?.loadingView = LoadingView()
        
        tableView?.setState(.empty)
        
        tableView?.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        tableView?.cellItemHandler = { indexPath in
            let cell = self.tableView?.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            let item = self.fetcher.items[indexPath.row]
            cell.configure(title: item.title,
                           author: item.author,
                           date: item.dateTaken,
                           image: item.media)
            return cell
        }
        tableView?.cellItemSelectionHandler = { cell, indexPath in
            guard let detailController = self.storyboard?.instantiateViewController(identifier: "DetailController") as? DetailController else { return }
            let item = self.fetcher.items[indexPath.row]
            
            detailController.photo = item
            self.present(detailController, animated: true, completion: nil)
        }
        tableView?.setRefreshControl({ rc in
            self.fetcher.execute { photos in
                let items = photos ?? []
                DispatchQueue.main.async {
                    rc.endRefreshing()
                    self.tableView?.setState(.populated(items))
                }
            }
        })
    }
    
    @IBAction
    func setError() {
        tableView?.setState(.error(nil))
    }
    
    @IBAction
    func setEmpty() {
        tableView?.setState(.empty)
    }
    
    @IBAction
    func setPopulated() {
        tableView?.setState(.loading)
        fetcher.execute { photos in
            let items = photos ?? []
            DispatchQueue.main.async {
                self.tableView?.setState(.populated(items))
            }
        }
    }
}

