//
//  PlaceDetailViewController.swift
//  Earthly
//
//  Created by Max Rogers on 1/9/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit
import FSPagerView

class PlaceDetailViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var earthlyImagePager: EarthlyImagePager!
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    var placeDetail: PlaceOfInterest!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        earthlyImagePager.pageControl = pageControl
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        placeNameLabel.text = placeDetail.placeName
        
        if placeDetail.images.count > 0 {
            earthlyImagePager.images = placeDetail.images
        } else {
            earthlyImagePager.removeFromSuperview()
        }
        
        descriptionTextView.text = placeDetail.infoText
        print(placeDetail.infoText)

        if placeDetail.phoneNumber == nil { callButton.removeFromSuperview() }
        if placeDetail.website == nil { directionsButton.removeFromSuperview() }
    }
    
    // MARK: - IBActions
    
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callPressed(_ sender: UIButton) {
        OpenSystem.phoneCall(withNumber: placeDetail.phoneNumber!)
    }
    
    @IBAction func directionsPressed(_ sender: UIButton) {
        OpenSystem.maps(forPlace: placeDetail)
    }
    
    @IBAction func websitePressed(_ sender: UIButton) {
         if let website = placeDetail.website, let websiteURL = URL(string: website) {
            OpenSystem.website(withURL: websiteURL)
        }
    }
    
    

}
