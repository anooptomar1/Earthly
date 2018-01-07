//
//  EarthlySearchBar.swift
//  Earthly
//
//  Created by Max Rogers on 1/2/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit

class EarthlySearchBar: UISearchBar {
    
    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        searchBarStyle = .minimal
        placeholder = "Ex: Milwaukee, WI"
    }

}

