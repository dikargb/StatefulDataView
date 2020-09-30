//
//  ErrorView.swift
//  StatefulDataViewExample
//
//  Created by Sinar Nirmata on 30/09/20.
//  Copyright © 2020 Sinar Nirmata. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    var text: String?
    var btnTitle: String?
    
    lazy private var errorLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    lazy private var actionButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()
    
    init(text: String, button: String) {
        self.text = text
        self.btnTitle = button
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        addSubview(errorLabel)
        addSubview(actionButton)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.titleLabel?.textAlignment = .center
        
        errorLabel.text = text
        errorLabel.sizeToFit()
        
        actionButton.setTitle(btnTitle, for: .normal)
        
        let hConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[label]-16-|",
            metrics: nil,
            views: ["label": errorLabel])
        
        let vConstraints = NSLayoutConstraint(
            item: errorLabel,
            attribute: .centerY,
            relatedBy: .equal, toItem: self,
            attribute: .centerY,
            multiplier: 1, constant: 0)
        
        addConstraints(hConstraints)
        addConstraint(vConstraints)
        
        let topConstraint = NSLayoutConstraint(
            item: actionButton,
            attribute: .top,
            relatedBy: .equal, toItem: errorLabel,
            attribute: .bottom,
            multiplier: 1, constant: 32)
        
        let centerVConstraint = NSLayoutConstraint(
            item: actionButton,
            attribute: .centerX,
            relatedBy: .equal, toItem: errorLabel,
            attribute: .centerX,
            multiplier: 1, constant: 0)
        
        addConstraints([centerVConstraint, topConstraint])
    }
}
