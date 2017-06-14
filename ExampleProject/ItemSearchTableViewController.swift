//
//  ItemSearchTableViewController.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 6/5/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import UIKit

class ItemSearchTableViewController: UITableViewController, EntityViewControllerInterface {

    var entity:EntityBase?
    private var entityArray = [EntityBase]()
    private var filteredEntityArray = [EntityBase]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.topItem?.title = "Item Search"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelHandler(sender:)))
        self.loadTableData()
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Item", "Bin", "Location"]
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func loadTableData()    {
        entityArray.append(Item(name: "Drill", qty:1, bin: Bin(name: "Top Shelf", location: Location(name: "Closet"))))
        entityArray.append(Item(name: "Screws", qty:12, bin: Bin(name: "Bottom Drawer", location: Location(name: "Basement"))))
        entityArray.append(Item(name: "Wood", bin: Bin(name: "Last Cabinet", location: Location(name: "Storage"))))
        entityArray.append((entityArray[0] as! Item).bin!)
        entityArray.append((entityArray[1] as! Item).bin!)
        entityArray.append((entityArray[2] as! Item).bin!)
        entityArray.append((entityArray[0] as! Item).bin!.location!)
        entityArray.append((entityArray[1] as! Item).bin!.location!)
        entityArray.append((entityArray[2] as! Item).bin!.location!)
    }
    
    func cancelHandler(sender: UIBarButtonItem) {
        print("Cancel clicked!")
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredEntityArray.count
        }
        return entityArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)
        var entity:EntityBase?
        if searchController.isActive && searchController.searchBar.text != "" {
            entity = filteredEntityArray[indexPath.row]
        } else {
            entity = entityArray[indexPath.row]
        }
        cell.textLabel?.text = entity!.name!
        if let item = entity as? Item? {
            cell.detailTextLabel?.text = "Bin: \(item!.bin!.name!), Location: \(item!.bin!.location!.name!)"
        } else if let bin = entity as? Bin? {
            cell.detailTextLabel?.text = "Location: \(bin!.location!.name!)"
        }
        else if let location = entity as? Location? {
            cell.detailTextLabel?.text = "(\(String(describing: location!.entityType!)))"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            self.entity = filteredEntityArray[indexPath.row]
        } else {
            self.entity = entityArray[indexPath.row]
        }
        print("\(self.entity!.name!) selected")
        self.performSegue(withIdentifier: "unwindToAddItem", sender: self)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredEntityArray = entityArray.filter({( entity : EntityBase) -> Bool in
            let categoryMatch = (scope == "All") || (String(describing:entity.entityType!) == scope)
            let name = entity.name!.lowercased()
            print("\(String(describing:entity.entityType!)) \(name) \(entity.name!.lowercased().contains(searchText.lowercased()))")
            return categoryMatch && entity.name!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

extension ItemSearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension ItemSearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
