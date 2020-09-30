//
//  DetailController.swift
//  StatefulDataViewExample
//
//  Created by Sinar Nirmata on 30/09/20.
//  Copyright © 2020 Sinar Nirmata. All rights reserved.
//

import StatefulDataView
import UIKit

class DetailController: UIViewController {
    @IBOutlet private var stateView: StatefulDataView?
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var authorLabel: UILabel?
    @IBOutlet private var dateLabel: UILabel?
    @IBOutlet private var descriptionLabel: UILabel?
    @IBOutlet private var itemImageView: UIImageView?
    
    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stateView?.setState(.empty)
        stateView?.refreshHandler = { view in
            view.removeFromSuperview()
        }
        
        guard let photo = photo else { return }
        titleLabel?.text = photo.title
        authorLabel?.text = photo.author
        dateLabel?.text = photo.dateTaken
        descriptionLabel?.text = photo.description
        
        guard let urlString = photo.media,
            let url = URL(string: urlString) else { return }
        itemImageView?.load(url: url)
    }
    
    @IBAction
    func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }
}
