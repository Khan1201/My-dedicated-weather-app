//
//  Store.swift
//  Core
//
//  Created by 윤형석 on 8/8/25.
//

import Foundation

public protocol Store {
    associatedtype State: ObservableObject
    associatedtype Action
    var state: State { get }
    func send(_ action: Action)
}

public protocol NetworkFloaterStore: Store where State == NetworkFloaterStoreState, Action == NetworkFloaterStoreAction {}
