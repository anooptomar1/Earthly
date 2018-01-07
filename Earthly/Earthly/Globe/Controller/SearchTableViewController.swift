//
//  SearchTableViewController.swift
//  Earthly
//
//  Created by Max Rogers on 1/6/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var earthlySearchBar: EarthlySearchBar!
    var placesOfInterest: [SearchableLocation] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    weak var globeDelegate: GlobeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesOfInterest.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as? LocationTableViewCell else { return UITableViewCell() }
        cell.configure(with: placesOfInterest[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40)
        return TableViewHeaderView(frame: frame)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? LocationTableViewCell,
        let location = cell.model else { return }
        globeDelegate?.shouldZoom(toCoordinates: location.coordinates, withScope: location.scope, name: location.name, displayMarker: true)
    }

}
