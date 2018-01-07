//
//  GlobeSearch.swift
//  Earthly
//
//  Created by Max Rogers on 1/3/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import Foundation

extension GlobeViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchContainer" {
            if let searchVC = segue.destination as? SearchTableViewController {
                self.searchViewController = searchVC
            }
        }
    }
    
    func configureSearchController() {
        searchBar.delegate = self
        searchViewController?.globeDelegate = self
    }
    
}

extension GlobeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TOOD: activity indicator
        if !EarthlyGeocoder.shared.geocoder.isGeocoding {
            if searchContainerView.alpha == 0.0 {
                self.searchContainerView?.appear()
            }
            let searchText = self.searchBar.text ?? ""
            EarthlyGeocoder.shared.forwardGeocode(textQuery: searchText, completion: { (newLocations) in
                self.searchViewController?.placesOfInterest.removeAll()
                self.searchViewController?.placesOfInterest = newLocations
            })
        }
    }
    
}
