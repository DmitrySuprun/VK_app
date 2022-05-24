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
    
    // Временное свойство для работы с анимацией картинок в PhotoAnimationVC
    let imagesTemp: [UIImage?] = [UIImage(named: "33"),
                      UIImage(named: "34"),
                      UIImage(named: "35"),
                      UIImage(named: "36"),
                      UIImage(named: "37"),
                      UIImage(named: "38"),
                      UIImage(named: "39"),
                      UIImage(named: "40")]
    
    var sourse: [User] = [.init(name: "Иван", avatarImage: "1", likeCount: 1, isLike: true),
                          .init(name: "Петр", avatarImage: "2", likeCount: 2),
                          .init(name: "Глеб", avatarImage: "3", likeCount: 3),
                          .init(name: "Сергей", avatarImage: "4", likeCount: 4),
                          .init(name: "Елена", avatarImage: "5", likeCount: 5),
                          .init(name: "Юлия", avatarImage: "6", likeCount: 6),
                          .init(name: "Виктор", avatarImage: "7", likeCount: 7),
                          .init(name: "Вацлав", avatarImage: "8", likeCount: 8),
                          .init(name: "Гражина", avatarImage: "9", likeCount: 9),
                          .init(name: "Андрей", avatarImage: "10", likeCount: 10),
                          .init(name: "Роман", avatarImage: "11", likeCount: 11),
                          .init(name: "Ярослав", avatarImage: "12", likeCount: 12, isLike: true),
                          .init(name: "Алена", avatarImage: "13", likeCount: 13),
                          .init(name: "Филипп", avatarImage: "14", likeCount: 14),
                          .init(name: "Алексей", avatarImage: "15", likeCount: 15),
                          .init(name: "Жанна", avatarImage: "16", likeCount: 14),
                          .init(name: "Гелена", avatarImage: "17", likeCount: 13),
                          .init(name: "Борис", avatarImage: "18", likeCount: 12),
                          .init(name: "Николай", avatarImage: "19", likeCount: 11),
                          .init(name: "Юрий", avatarImage: "20", likeCount: 10),
                          .init(name: "Дмитрий", avatarImage: "21", likeCount: 9),
                          .init(name: "Кирилл", avatarImage: "22", likeCount: 8),
                          .init(name: "Татьяна", avatarImage: "23", likeCount: 7),
                          .init(name: "Ольга", avatarImage: "24", likeCount: 6),
                          .init(name: "Лиза", avatarImage: "25", likeCount: 5),
                          .init(name: "Инна", avatarImage: "26", likeCount: 4),
                          .init(name: "Мария", avatarImage: "27", likeCount: 3),
                          .init(name: "Константин", avatarImage: "28", likeCount: 2),
                          .init(name: "Евгений", avatarImage: "29", likeCount: 1),
                          .init(name: "Зинаида", avatarImage: "30", likeCount: 0),
                          .init(name: "Владислав", avatarImage: "31", likeCount: 1),
                          .init(name: "Вячеслав", avatarImage: "32", likeCount: 2),
                          .init(name: "Михаил", avatarImage: "33", likeCount: 3),
                          .init(name: "Пол", avatarImage: "34", likeCount: 4),
                          .init(name: "Джон", avatarImage: "35", likeCount: 5),
                          .init(name: "Элла", avatarImage: "36", likeCount: 6),
                          .init(name: "Антуан", avatarImage: "37", likeCount: 7),
                          .init(name: "Шон", avatarImage: "38", likeCount: 8),
                          .init(name: "Ибрагим", avatarImage: "39", likeCount: 9),
                          .init(name: "Сальвадорэ", avatarImage: "40", likeCount: 10)
    ]
    
    var friends: [User] = []
    // Двумерный массив отсортированный по первой букве
    var contactListForTableView = [[User]]()
    
    // MARK: - Private Properties
    // MARK: - Initializers
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Временно для работы с анимацией картинок в PhotoAnimationVC добавляем массив этих картинок к каждому User в sourse
        for i in sourse.indices {
            sourse[i].images = imagesTemp
        }
        
        friends = sourse.sorted(by: { $0.name < $1.name })
        contactListForTableView = sortContactListForTableView(contactList: friends)
        // заполняем временными картинками
        
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
        cell.avatarView.image = UIImage(named: contactListForTableView[indexPath.section][indexPath.row].avatarImage)!
        cell.name.text = contactListForTableView[indexPath.section][indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete contact?", message: "Action cannot be undone", preferredStyle: .alert)
            let buttonOk = UIAlertAction(title: "Ok", style: .default) { _ in
                if self.contactListForTableView[indexPath.section].count == 1 {
                    self.contactListForTableView.remove(at: indexPath.section)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                } else {
                    self.contactListForTableView[indexPath.section].remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            let buttonCancel = UIAlertAction(title: "Cancel", style: .destructive)
            alert.addAction(buttonOk)
            alert.addAction(buttonCancel)
            present(alert, animated: true)
            
        } else if editingStyle == .insert {}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendProfileSegueID" {
            let destination = segue.destination as! FriendProfileCollectionViewController
            let index = tableView.indexPathForSelectedRow
            destination.updateData(user: contactListForTableView[index!.section][index!.row])
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
