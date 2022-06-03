//
//  CommunitiesTableViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 11.04.22.
//

import UIKit

class CommunitiesTableViewController: UITableViewController {
    
    var communitiesList = [Community]()
    private var searchBackup = [Community]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communitiesList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCellID", for: indexPath) as! CommunitiesTableViewCell
        var configuration = cell.defaultContentConfiguration()
        configuration.image = UIImage(named: communitiesList[indexPath.row].image)
        configuration.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        configuration.imageProperties.cornerRadius = CGFloat(25)
        configuration.text = communitiesList[indexPath.row].name
        cell.contentConfiguration = configuration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            communitiesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    @IBAction func unwindToCommunitiesController(_ segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
}

extension CommunitiesTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBackup = communitiesList
    }
    func searchBarTextDidEndEditing (_ searchBar: UISearchBar) {
        communitiesList = searchBackup
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        communitiesList = searchBackup
        if !searchText.isEmpty {
            communitiesList = communitiesList.filter({ $0.name.lowercased().contains(searchText.lowercased())})
        }
        tableView.reloadData()
    }
}
