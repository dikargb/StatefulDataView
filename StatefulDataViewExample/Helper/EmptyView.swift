//
//  EmptyView.swift
//  StatefulDataViewExample
//
//  Created by Sinar Nirmata on 30/09/20.
//  Copyright © 2020 Sinar Nirmata. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    var text: String?
    
    lazy private var emptyLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    init(text: String) {
        self.text = text
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        addSubview(emptyLabel)
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.textAlignment = .center
        
        emptyLabel.text = text
        emptyLabel.sizeToFit()
        
        let hConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[label]-16-|",
            options: .init(rawValue: 0),
            metrics: nil,
            views: ["label": emptyLabel])
        
        let vConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[label]-|",
            options: .init(rawValue: 0),
            metrics: nil,
            views: ["label": emptyLabel])
        
        addConstraints(hConstraints)
        addConstraints(vConstraints)
    }
}

