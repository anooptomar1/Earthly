//
//  EarthlyActivityIndicator.swift
//  Earthly
//
//  Created by Max Rogers on 1/6/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit

class EarthlyActivityIndicator: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 15
        backgroundColor = UIColor.white
        let globeImageView = UIImageView(image: #imageLiteral(resourceName: "LoadingCloud"))
        globeImageView.contentMode = .scaleAspectFit
        
        globeImageView.frame = CGRect(origin: bounds.origin, size: CGSize(width: frame.size.height/1.3, height: frame.size.width/1.3))
        globeImageView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        addSubview(globeImageView)
        
        let expandTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        let rotateTransform = CGAffineTransform(rotationAngle: CGFloat.pi)
        globeImageView.transform = expandTransform
        globeImageView.transform = rotateTransform
        UIView.animate(withDuration: 1.2,
                       delay:0.0,
                       usingSpringWithDamping:0.50,
                       initialSpringVelocity:0.1,
                       options: [.curveEaseOut, .repeat],
                       animations: {
                        globeImageView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
