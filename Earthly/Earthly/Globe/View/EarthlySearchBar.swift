//
//  EarthlySearchBar.swift
//  Earthly
//
//  Created by Max Rogers on 1/2/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit

class EarthlySearchBar: UISearchBar {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        searchBarStyle = .minimal
        let textField = value(forKey: "searchField") as? UITextField
        textField?.textColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    }

}

