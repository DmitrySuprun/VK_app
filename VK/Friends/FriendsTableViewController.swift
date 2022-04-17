//
//  FriendsTableViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 9.04.22.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    // MARK: - Public Properties
    
    let sourse: [User] = [.init(name: "Иван", image: "1", likeCount: 1),
                          .init(name: "Петр", image: "2", likeCount: 2),
                          .init(name: "Глеб", image: "3", likeCount: 3),
                          .init(name: "Сергей", image: "4", likeCount: 4),
                          .init(name: "Елена", image: "5", likeCount: 5),
                          .init(name: "Юлия", image: "6", likeCount: 6),
                          .init(name: "Виктор", image: "7", likeCount: 7),
                          .init(name: "Вацлав", image: "8", likeCount: 8),
                          .init(name: "Гражина", image: "9", likeCount: 9),
                          .init(name: "Андрей", image: "10", likeCount: 10),
                          .init(name: "Роман", image: "11", likeCount: 11),
                          .init(name: "Ярослав", image: "12", likeCount: 12),
                          .init(name: "Алена", image: "13", likeCount: 13),
                          .init(name: "Филипп", image: "14", likeCount: 14),
                          .init(name: "Алексей", image: "15", likeCount: 15),
                          .init(name: "Жанна", image: "16", likeCount: 14),
                          .init(name: "Гелена", image: "17", likeCount: 13),
                          .init(name: "Борис", image: "18", likeCount: 12),
                          .init(name: "Николай", image: "19", likeCount: 11),
                          .init(name: "Юрий", image: "20", likeCount: 10),
                          .init(name: "Дмитрий", image: "21", likeCount: 9),
                          .init(name: "Кирилл", image: "22", likeCount: 8),
                          .init(name: "Татьяна", image: "23", likeCount: 7),
                          .init(name: "Ольга", image: "24", likeCount: 6),
                          .init(name: "Лиза", image: "25", likeCount: 5),
                          .init(name: "Инна", image: "26", likeCount: 4),
                          .init(name: "Мария", image: "27", likeCount: 3),
                          .init(name: "Константин", image: "28", likeCount: 2),
                          .init(name: "Евгений", image: "29", likeCount: 1),
                          .init(name: "Зинаида", image: "30", likeCount: 0),
                          .init(name: "Владислав", image: "31", likeCount: 1),
                          .init(name: "Вячеслав", image: "32", likeCount: 2),
                          .init(name: "Михаил", image: "33", likeCount: 3),
                          .init(name: "Пол", image: "34", likeCount: 4),
                          .init(name: "Джон", image: "35", likeCount: 5),
                          .init(name: "Элла", image: "36", likeCount: 6),
                          .init(name: "Антуан", image: "37", likeCount: 7),
                          .init(name: "Шон", image: "38", likeCount: 8),
                          .init(name: "Ибрагим", image: "39", likeCount: 9),
                          .init(name: "Сальвадорэ", image: "40", likeCount: 10)]
    
    var friends: [User] = []
    var contactListForTableView = [[User]]()
    
    // MARK: - Private Properties
    // MARK: - Initializers
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friends = sourse.sorted(by: { $0.name < $1.name })
        contactListForTableView = sortContactListForTableView(contactList: friends)

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactListForTableView.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListForTableView[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(contactListForTableView[section][0].name.first!)
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var result = [String]()
        for i in 0..<contactListForTableView.count {
            result.append(String(contactListForTableView[i][0].name.first!))
        }
        
        return result
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCellID", for: indexPath) as! FriendsTableViewCell
        
        // реализация ячейки со стандартными полями
        //        var configuration = cell.defaultContentConfiguration()
        //        configuration.text = friends[indexPath.row].name
        //        configuration.imageProperties.maximumSize = CGSize(width: 30, height: 30)
        //        configuration.image = UIImage(named: friends[indexPath.row].image)
        //        cell.contentConfiguration = configuration
        
        //реализация ячейки через storyboard и outlet
        cell.avatarView.image = UIImage(named: contactListForTableView[indexPath.section][indexPath.row].image)!
        cell.name.text = contactListForTableView[indexPath.section][indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if contactListForTableView[indexPath.section].count == 1 {
                contactListForTableView.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            } else {
                contactListForTableView[indexPath.section].remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendProfileSegueID" {
            let destination = segue.destination as! FriendProfileCollectionViewController
            let index = tableView.indexPathForSelectedRow
            destination.updateData(user: friends[index!.row])
        }
    }
    
    // MARK: - IBActions
    // MARK: - Public Methods
//
//    func firstLettersArray(_ friends: [User]) -> [Character] {
//        return Array(Set(friends.compactMap( {$0.name.first!}))).sorted()
//    }
//
    // MARK: - Private Methods
    private func sortContactListForTableView (contactList: [User]) -> [[User]] {
        let sortedList = friends

        var result = [[User]]()
        var arrayTemp = [sortedList[0]]

        for i in 1...(contactList.count - 1) {
            if arrayTemp.last!.name.first! == sortedList[i].name.first! {
                arrayTemp.append(sortedList[i])
            } else {
                result.append(arrayTemp)
                arrayTemp.removeAll()
                arrayTemp.append(sortedList[i])
            }
        }
        result.append(arrayTemp)
        return result
    }
    
}
