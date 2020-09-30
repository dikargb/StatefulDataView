//
//  ItemCell.swift
//  StatefulDataView
//
//  Created by Sinar Nirmata on 30/09/20.
//  Copyright © 2020 Sinar Nirmata. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var authorLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var itemImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        itemImageView?.image = nil
    }
    
    func configure(title: String?, author: String?, date: String?, image: String?) {
        titleLabel?.text = title
        authorLabel?.text = author
        dateLabel?.text = date
        
        if let image = image,
            let url = URL(string: image) {
            itemImageView?.load(url: url)
        }
    }
}
