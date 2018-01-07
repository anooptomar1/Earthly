//
//  ConfigurableCell.swift
//  Earthly
//
//  Created by Max Rogers on 1/6/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//
import Foundation

protocol ConfigurableCell {
    associatedtype T
    var model: T? { get set }
    func configure(with model : T)
}
