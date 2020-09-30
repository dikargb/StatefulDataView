//
//  LoadingView.swift
//  StatefulDataViewExample
//
//  Created by Sinar Nirmata on 30/09/20.
//  Copyright © 2020 Sinar Nirmata. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.color = .systemBlue
        ai.hidesWhenStopped = true
        ai.style = .large
        ai.startAnimating()
        return ai
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let hConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[aiView]-|",
            options: .init(rawValue: 0),
            metrics: nil,
            views: ["aiView": activityIndicator])
        
        let vConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[aiView]-|",
            options: .init(rawValue: 0),
            metrics: nil,
            views: ["aiView": activityIndicator])
        
        addConstraints(hConstraints)
        addConstraints(vConstraints)
    }
}

