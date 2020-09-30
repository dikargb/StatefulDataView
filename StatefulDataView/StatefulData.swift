//
//  StatefulData.swift
//  StatefulDataView
//
//  Created by Sinar Nirmata on 30/09/20.
//  Copyright © 2020 Sinar Nirmata. All rights reserved.
//

import Foundation
import UIKit

/// Key to store view in associated object
private var emptyKey: UInt8 = 0
/// Key to store view in associated object
private var errorKey: UInt8 = 0
/// Key to store view in associated object
private var loadingKey: UInt8 = 0

/// State enums as data view status
public enum DataState {
    case error(Error?)
    case empty
    case loading
    case populated([Any])
    
    /// Get data view items, only return non nil if state is populated
    var items: [Any] {
        switch self {
        case .populated(let items): return items
        default: return []
        }
    }
}

/// StatefulData protocol to configure states and their updates
protocol StatefulData {
    func updateState()
    func setState(_ state: DataState, reloadAfter: Bool)
}

public extension UIView {
    /// Embedded empty view for view
    var emptyView: UIView? {
        get { return associatedObject(base: self, key: &emptyKey) }
        set { associateObject(base: self, key: &emptyKey, value: newValue) }
    }
    /// Embedded error view for view
    var errorView: UIView? {
        get { return associatedObject(base: self, key: &errorKey) }
        set { associateObject(base: self, key: &errorKey, value: newValue) }
    }
    /// Embedded loading view for view
    var loadingView: UIView? {
        get { return associatedObject(base: self, key: &loadingKey) }
        set { associateObject(base: self, key: &loadingKey, value: newValue) }
    }

    /// Associated object helper to get embedded views
    private func associatedObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>) -> ValueType? {
        return objc_getAssociatedObject(base, key) as? ValueType
    }

    /// Associated object helper to set embedded views
    private func associateObject<ValueType: AnyObject>(base: AnyObject,
                                               key: UnsafePointer<UInt8>,
                                               value: ValueType?) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
}
