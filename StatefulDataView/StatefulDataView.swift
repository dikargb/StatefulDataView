//
//  StatefulDataView.swift
//  StatefulDataView
//
//  Created by Sinar Nirmata on 30/09/20.
//  Copyright © 2020 Sinar Nirmata. All rights reserved.
//

import UIKit

open class StatefulDataView: UIView, StatefulData {
    var state: DataState = .empty { didSet { updateState() }}
    
    open dynamic var data: Any?
    open dynamic var refreshHandler: ((UIView) -> Void)?
    
    lazy private var tryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reload", for: .normal)
        button.titleLabel?.sizeToFit()
        return button
    }()
    
    func updateState() {
        removeCurrentStateView()

        tryButton.backgroundColor = self.backgroundColor
        tryButton.addTarget(self, action: #selector(refreshInitiated(_:)), for: .touchUpInside)
        
        var blockView: UIView?
        
        switch state {
        case .empty:
            blockView = emptyView ?? tryButton
        case .error:
            blockView = errorView ?? tryButton
        case .loading:
            blockView = loadingView ?? tryButton
        default: break
        }
        
        guard let v = blockView else { return }
        addSubview(v)
        bringSubviewToFront(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        let hConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[blockView]-|",
            metrics: nil, views: ["blockView": v])
        
        let vConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[blockView]-|",
            metrics: nil, views: ["blockView": v])
        
        superview?.addConstraints(hConstraints + vConstraints)
    }
    
    public func setState(_ state: DataState, reloadAfter: Bool = true) {
        self.state = state
    }
    
    public func getState() -> DataState {
        return state
    }
    
    private func removeCurrentStateView() {
        emptyView?.removeFromSuperview()
        errorView?.removeFromSuperview()
        loadingView?.removeFromSuperview()
        tryButton.removeFromSuperview()
    }
    
    @objc func refreshInitiated(_ view: UIView) {
        refreshHandler?(view)
    }
}
