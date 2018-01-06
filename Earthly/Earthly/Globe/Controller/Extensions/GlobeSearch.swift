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
        self.searchBar.delegate = self
        
//        let searchVC = storyboard.instantiateViewController(withIdentifier: "searchTableView") as? UITableViewController
//        searchController = EarthlySearchController(searchResultsController: searchVC)
//        searchController.tableView = searchVC?.tableView
//        searchController.dimsBackgroundDuringPresentation = true
//        searchController.earthlySearchBar = self.searchBar
//        searchController.searchBar.delegate = self
//        searchController.searchResultsUpdater = self
//        searchController.delegate = self
        
        

    }
    
}

extension GlobeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchContainerView?.appear()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Forward Geocode New Text \(self.searchBar.text ?? "")")
        searchViewController?.placesOfInterest.removeAll()
        for char in searchBar.text ?? "" {
            searchViewController?.placesOfInterest.append("\(char)")
        }
    }
    
}
