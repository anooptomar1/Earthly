//
//  AnnotationView.swift
//  Earthly
//
//  Created by Max Rogers on 1/8/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit
import HDAugmentedReality

protocol AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView)
}


class AnnotationView: ARAnnotationView {
    var titleLabel: UILabel?
    var distanceLabel: UILabel?
    var delegate: AnnotationViewDelegate?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        loadUI()
    }
    
    func loadUI() {
        titleLabel?.removeFromSuperview()
        distanceLabel?.removeFromSuperview()
        
        self.cornerRadius = 10
        
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.size.width - 20, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        self.titleLabel = label
        self.addSubview(label)
        
        
        distanceLabel = UILabel(frame: CGRect(x: 10, y: 40, width: self.frame.size.width - 20, height: 20))
        distanceLabel?.backgroundColor = UIColor.clear
        distanceLabel?.textColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 0.5)
        distanceLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(distanceLabel!)
        
        if let annotation = annotation as? PlaceOfInterest {
            titleLabel?.text = annotation.placeName
            distanceLabel?.text = String(format: "%.2f miles", annotation.distanceFromUser * 0.000621371)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame = CGRect(x: 10, y: 0, width: self.frame.size.width - 20, height: 40)
        distanceLabel?.frame = CGRect(x: 10, y: 40, width: self.frame.size.width - 20, height: 20)
        backgroundColor = UIColor(white: 0.3, alpha: 0.7)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouch(annotationView: self)
    }
    
}
