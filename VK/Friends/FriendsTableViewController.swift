//
//  FriendsTableViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 9.04.22.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    // MARK: - Public Properties
    
    // сервисный класс загрузки данных из API idFriends и данные друзей
    let service = UserService()
    
    // полученные данные от API
    var usersFromApiVK: UserModel!
    
    // Массив моделей всех друзей
    var source: [User] = []
    
    // Отсортированный словарь с данными друзей
    var contactListForTableViewDictionary = [ String:[User] ]()
    
    
    // MARK: - Private Properties
    // MARK: - Initializers
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Загружаем данные из Realm
        fetchReamData()
        
        // получаем данные из API VK
        fetchUser()
        
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
        cell.avatarView.loadImage(url: contactListForTableViewDictionary[keyByIndexPath]![indexPath.row].avatarImage)
        cell.name.text = contactListForTableViewDictionary[keyByIndexPath]![indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete contact?", message: "Action cannot be undone", preferredStyle: .alert)
            let buttonOk = UIAlertAction(title: "Ok", style: .default) { _ in
                
                let keyByIndexPath = self.contactListForTableViewDictionary.keys.sorted()[indexPath.section]
                // если удаляется последний друг в секции, то удаляется и секция
                if self.contactListForTableViewDictionary[keyByIndexPath]?.count == 1 {
                    self.contactListForTableViewDictionary[keyByIndexPath] = nil
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                } else {
                    self.contactListForTableViewDictionary[keyByIndexPath]?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            // подтверждение удаления
            let buttonCancel = UIAlertAction(title: "Cancel", style: .destructive)
            alert.addAction(buttonOk)
            alert.addAction(buttonCancel)
            present(alert, animated: true)
            
        } else if editingStyle == .insert {}
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "FriendProfileSegueID" {
//            let destination = segue.destination as! FriendProfileCollectionViewController
//            let index = tableView.indexPathForSelectedRow
//            // передаем на следующий VC выбранную ячейку
//            let keyByIndexPath = contactListForTableViewDictionary.keys.sorted()[index!.section]
//            destination.updateData(user: contactListForTableViewDictionary[keyByIndexPath]![index!.row])
//        }
//    }
    
    // MARK: - IBActions
    // MARK: - Public Methods
    // MARK: - Private Methods
    
    private func fetchReamData() {
        
        do {
            let realm = try Realm()
            let test = realm.objects(User.self)
            source = test.map({ user in
                return user
            })
            
        } catch {
            print(#function)
            print("Can't get object from Realm")
        }
        
        self.contactListForTableViewDictionary = self.createDictionaryForContactList(contactList: self.source)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // Получаем данные друзей (id, имя, аватарку)
    private func fetchUser() {
        service.loadFriendsProfile() { [weak self] result in
            switch result {
            case .success(let user):
                // add User to Realm
                do {
                    let realm = try Realm()
                    print(realm.configuration.fileURL)
                    try realm.write {
                        realm.deleteAll()
                        user.userData.forEach { user in
                            realm.add(user)
                        }
                    }
                } catch {
                    print(#function)
                    print("Realm write ERROR")
                }
            case .failure(let error):
                print(#function)
                print(error)
            }
        }
    }
   
    // Создаем словарь для удобной работы с TableView
    private func createDictionaryForContactList (contactList: [User]) -> [String : [User]] {
        // Модель словаря
        var result = [ String:[User] ]()
        
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
