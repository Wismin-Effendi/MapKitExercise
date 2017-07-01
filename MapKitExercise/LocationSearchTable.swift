//
//  LocationSearchTable.swift
//  MapKitExercise
//
//  Created by Wismin Effendi on 7/1/17.
//  Copyright © 2017 iShinobi. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    
    var machingItems: [MKMapItem] = []
    var mapView: MKMapView?  
}

extension LocationSearchTable: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start {[weak self] (response, _) in
            guard let response = response else { return }
            
            self?.machingItems = response.mapItems
            self?.tableView.reloadData()
        }
    }
    
    func parseAddress(_ selectedItem: MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format: "%@%@%@%@%@%@%@",
            // street number 
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name 
            selectedItem.thoroughfare ?? "",
            comma,
            // city 
            selectedItem.locality ?? "",
            secondSpace,
            // state 
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

// MARK: UITableViewDataSource
extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return machingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let selectedItem = machingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem)
        return cell
    }
}
