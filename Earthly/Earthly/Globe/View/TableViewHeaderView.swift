//
//  TableViewHeaderView.swift
//  Earthly
//
//  Created by Max Rogers on 1/6/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit

class TableViewHeaderView: UIView {
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 40))
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.white
        label.text = "Places of Interest"
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6998608733)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
