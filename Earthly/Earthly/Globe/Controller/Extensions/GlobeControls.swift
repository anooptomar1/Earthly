//
//  GlobeControls.swift
//  Earthly
//
//  Created by Max Rogers on 12/5/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import UIKit

extension GlobeViewController {
    
    // MARK: - Actions
    
    @IBAction func controlTapped(_ sender: UIButton) {
        self.controlButton.animateControlButton()
        
        if !controlsVisible {
            self.controlView.animateControlViewIn()
        } else {
            self.controlView.animateControlViewOut()
        }
        controlsVisible = !controlsVisible
    }


    
}


