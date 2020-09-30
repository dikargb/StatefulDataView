//
//  StatefulCollectionView.swift
//  StatefulDataView
//
//  Created by Sinar Nirmata on 30/09/20.
//  Copyright © 2020 Sinar Nirmata. All rights reserved.
//

import UIKit

open class StatefulCollectionView: UICollectionView, StatefulData {
    var state: DataState = .empty { didSet { updateState() }}
    
    open dynamic var items: [Any] { return state.items }
    open dynamic var cellItemHandler: ((IndexPath) -> UICollectionViewCell)? { didSet { reloadData() }}
    open dynamic var cellItemSelectionHandler: ((UICollectionViewCell, IndexPath) -> Void)?
    open dynamic var cellItemSize: CGSize?
    open dynamic var refreshHandler: ((UIRefreshControl) -> Void)?
    open dynamic var loadMoreHandler: (() -> Void)?
        
    open override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
    }
    
    func updateState() {
        removeCurrentStateView()
        
        var blockView: UIView?
        
        switch state {
        case .empty: blockView = emptyView
        case .error: blockView = errorView
        case .loading: blockView = loadingView
        default: break
        }
        
        guard let v = blockView else { return }
        superview?.insertSubview(v, aboveSubview: self)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: v, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: v, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)]
        
        superview?.addConstraints(constraints)
    }
    
    public func setDelegate(_ data: UICollectionViewDelegate&UICollectionViewDataSource&UICollectionViewDelegateFlowLayout) {
        delegate = data
        dataSource = data
        reloadData()
    }
    
    public func setRefreshControl(_ handler: @escaping ((UIRefreshControl) -> Void)) {
        refreshHandler = handler
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    public func setState(_ state: DataState, reloadAfter: Bool = true) {
        self.state = state
        if reloadAfter { self.reloadData() }
    }
    
    public func getState() -> DataState {
        return state
    }
    
    private func removeCurrentStateView() {
        emptyView?.removeFromSuperview()
        errorView?.removeFromSuperview()
        loadingView?.removeFromSuperview()
    }
    
    @objc
    private func refreshControlValueChanged(_ refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        refreshHandler?(refreshControl)
    }
}

extension StatefulCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = cellItemHandler?(indexPath) else { return UICollectionViewCell() }
        switch state {
        case .populated:
            if !items.isEmpty {
                if indexPath.row >= items.count - 2 {
                    loadMoreHandler?()
                }
            }
        default:
            break
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = cellItemHandler?(indexPath) else { return }
        cellItemSelectionHandler?(cell, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellItemSize ?? CGSize(width: collectionView.frame.width,
                                      height: 200)
    }
}
