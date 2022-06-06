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
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactListForTableViewDictionary.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyByIndexPath = contactListForTableViewDictionary.keys.sorted()[section]
        return contactListForTableViewDictionary[keyByIndexPath]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactListForTableViewDictionary.keys.sorted()[section]
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactListForTableViewDictionary.keys.sorted()
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
        let keyByIndexPath = contactListForTableViewDictionary.keys.sorted()[indexPath.section]
        
        cell.avatarView.image = contactListForTableViewDictionary[keyByIndexPath]![indexPath.row].avatarImage
        cell.name.text = contactListForTableViewDictionary[keyByIndexPath]![indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete contact?", message: "Action cannot be undone", preferredStyle: .alert)
            let buttonOk = UIAlertAction(title: "Ok", style: .default) { _ in
                
                let keyByIndexPath = self.contactListForTableViewDictionary.keys.sorted()[indexPath.section]
                
                if self.contactListForTableViewDictionary[keyByIndexPath]?.count == 1 {
                    self.contactListForTableViewDictionary[keyByIndexPath] = nil
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                } else {
                    self.contactListForTableViewDictionary[keyByIndexPath]?.remove(at: indexPath.row)
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
            
            let keyByIndexPath = contactListForTableViewDictionary.keys.sorted()[index!.section]
            destination.updateData(user: contactListForTableViewDictionary[keyByIndexPath]![index!.row])
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
        
        for i in 0..<userFromApiVK.response.count {
            let name = self.userFromApiVK.response[i].firstName + " " + self.userFromApiVK.response[i].lastName
            let avatarImageLoad = UIImageView()
            avatarImageLoad.loadImage(url: self.userFromApiVK.response[i].avatarImage)
            let userModel = UserModel(name: name, avatarImage: avatarImageLoad.image, likeCount: Int.random(in: 1...30), isLike: Bool.random(), images: [nil])
            self.source.append(userModel)
            
            
            
            
        }
        print(source)
        contactListForTableViewDictionary = createDictionaryForContactList(contactList: source)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    private func fetchFriendsID() {
        service.loadFriendsID { result in
            switch result {
            case .success(let items):
                self.usersID = items
                self.fetchUser()
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
                print(user)
                self.updateSource()
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
