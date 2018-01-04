//
//  GlobeSearch.swift
//  Earthly
//
//  Created by Max Rogers on 1/3/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import Foundation

extension GlobeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Hey"
        cell.textLabel?.textColor = UIColor.cyan
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
}

extension GlobeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        print(cell.textLabel?.text)
    }
    
}

extension GlobeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Forward Geocode New Text \(searchText)")
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        // TODO: - this means they cancelled or something
        return true
    }
    
}
