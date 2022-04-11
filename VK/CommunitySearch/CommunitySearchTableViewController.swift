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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return communitiesSearchList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunitySearchCellID", for: indexPath) as! CommunitySearchTableViewCell
        var configuration = cell.defaultContentConfiguration()
        configuration.image = UIImage(named: communitiesSearchList[indexPath.row].image)
        configuration.text = communitiesSearchList[indexPath.row].name
        cell.contentConfiguration = configuration
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            communitiesSearchList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindSegueToCommunityControllerID" {
            let destination = segue.destination as! CommunitiesTableViewController
            let newCommunity = communitiesSearchList[tableView.indexPathForSelectedRow!.row]
            destination.communitiesList.append(newCommunity)
        }
    }

}
