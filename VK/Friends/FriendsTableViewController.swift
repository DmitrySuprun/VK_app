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
    
    // сервисный класс загрузки данных из API
    let service = UserService()
    var usersID = [Int]()
    var userFromApiVK: User!
    
    // Временное свойство для работы с анимацией картинок в PhotoAnimationVC
    let imagesTemp: [UIImage?] = [UIImage(named: "33"),
                      UIImage(named: "34"),
                      UIImage(named: "35"),
                      UIImage(named: "36"),
                      UIImage(named: "37"),
                      UIImage(named: "38"),
                      UIImage(named: "39"),
                      UIImage(named: "40")]
    
    var source: [UserModel] = []
    
    var friends: [UserModel] = []
    // Двумерный массив отсортированный по первой букве
    var contactListForTableView = [[ UserModel ]]()
    // Переделываем таблицу из многомерного массива на Set
    var contactListForTableViewDictionary = [ String:[UserModel] ]()
    
    // MARK: - Private Properties
    // MARK: - Initializers
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFriendsID()
        
        // Временно для работы с анимацией картинок в PhotoAnimationVC добавляем массив этих картинок к каждому User в source
        for i in source.indices {
            source[i].images = imagesTemp
        }
//        createDictionaryForContactList(contactList: sourse)
//        friends = source.sorted(by: { $0.name < $1.name })
//        contactListForTableView = sortContactListForTableView(contactList: friends)
        // заполняем временными картинками
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        return contactListForTableView.count
        return contactListForTableViewDictionary.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return contactListForTableView[section].count
        return contactListForTableViewDictionary.keys.count

    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return String(contactListForTableView[section][0].name.first!)
//        return contactListForTableViewDictionary.keys.sorted()[section]

//    }
    
    
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        var result = [String]()
//        for i in 0..<contactListForTableView.count {
//            result.append(String(contactListForTableView[i][0].name.first!))
//        }
//
//        return result
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCellID", for: indexPath) as! FriendsTableViewCell
        
        // реализация ячейки со стандартными полями
        //        var configuration = cell.defaultContentConfiguration()
        //        configuration.text = friends[indexPath.row].name
        //        configuration.imageProperties.maximumSize = CGSize(width: 30, height: 30)
        //        configuration.image = UIImage(named: friends[indexPath.row].image)
        //        cell.contentConfiguration = configuration
        
        //реализация ячейки через storyboard и outlet
        cell.avatarView.image = contactListForTableView[indexPath.section][indexPath.row].avatarImage
        cell.name.text = contactListForTableView[indexPath.section][indexPath.row].name
        
        cell.avatarView.image = contactListForTableViewDictionary.keys.sorted()[indexPath.section]
        
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
    
    private func updateSource() {
        source = []
        for i in 0..<userFromApiVK.response.count {
            let name = userFromApiVK.response[i].firstName + " " + userFromApiVK.response[i].lastName
            let avatarImage = UIImageView()
            avatarImage.loadImage(url: userFromApiVK.response[i].avatarImage)
            let userModel = UserModel(name: name, avatarImage: avatarImage.image!, likeCount: Int.random(in: 1...30), isLike: Bool.random(), images: [nil])
            self.source.append(userModel)
        }
        contactListForTableViewDictionary = createDictionaryForContactList(contactList: source)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    private func fetchFriendsID() {
        service.loadFriendsID { result in
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    print(items)
                    self.usersID = items
                    self.fetchUser()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchUser() {
        print(usersID)
        service.loadFriendsProfile(userID: usersID) { result in
            switch result {
            case .success(let user):
                self.userFromApiVK = user
                self.updateSource()
                print(user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    private func sortContactListForTableView (contactList: [UserModel]) -> [[UserModel]] {
//        let sortedList = friends
//
//        var result = [[UserModel]]()
//        var arrayTemp = [sortedList[0]]
//
//        for i in 1...(contactList.count - 1) {
//            if arrayTemp.last!.name.first! == sortedList[i].name.first! {
//                arrayTemp.append(sortedList[i])
//            } else {
//                result.append(arrayTemp)
//                arrayTemp.removeAll()
//                arrayTemp.append(sortedList[i])
//            }
//        }
//        result.append(arrayTemp)
//        return result
//    }
    
    private func createDictionaryForContactList (contactList: [UserModel]) -> [String : [UserModel]] {

        var result = [String : [UserModel]]()

        for item in contactList {

            if var existingArray = result[String(item.name.first!)] {
                existingArray.append(item)
                result[String(item.name.first!)] = existingArray
            } else {
                result.updateValue([item], forKey: String(item.name.first!))
            }
        }
        return result
    }

}
