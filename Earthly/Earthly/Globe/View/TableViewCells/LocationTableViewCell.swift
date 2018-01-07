//
//  LocationTableViewCell.swift
//  Earthly
//
//  Created by Max Rogers on 1/6/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell, ConfigurableCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var locationLabel: UILabel!
    
    typealias T = SearchableLocation
    var model: SearchableLocation?
    
    // MARK: - Configuration
    
    func configure(with model: SearchableLocation) {
        self.model = model
        locationLabel.text = model.name
    }

}
