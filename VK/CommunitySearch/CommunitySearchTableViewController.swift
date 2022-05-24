//
//  CommunitySearchTableViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 11.04.22.
//

import UIKit

class CommunitySearchTableViewController: UITableViewController {
    
    var communitiesSearchList: [Community] = [.init(name: "Север", image: "101"),
                                              .init(name: "Юг", image: "102"),
                                              .init(name: "Восток", image: "103"),
                                              .init(name: "Запад", image: "104"),
                                              .init(name: "Земля", image: "105"),
                                              .init(name: "Вода", image: "106"),
                                              .init(name: "Воздух", image: "107")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communitiesSearchList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunitySearchCellID", for: indexPath) as! CommunitySearchTableViewCell
        var configuration = cell.defaultContentConfiguration()
        configuration.image = UIImage(named: communitiesSearchList[indexPath.row].image)
        configuration.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        configuration.text = communitiesSearchList[indexPath.row].name
        cell.contentConfiguration = configuration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            communitiesSearchList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindSegueToCommunityControllerID" {
            let destination = segue.destination as! CommunitiesTableViewController
            let newCommunity = communitiesSearchList[tableView.indexPathForSelectedRow!.row]
            if !destination.communitiesList.contains(newCommunity) {
                destination.communitiesList.append(newCommunity)
            }
            
        }
    }
    
}
