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
    
    // Realm Notification
    var notificationToken: NotificationToken?
    
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
        
        do {
            let realm = try Realm()
            let object = realm.objects(UserAllPhotos.self)
            
            notificationToken = object.observe({ [weak self] changes in
                
                guard let tableView = self?.tableView else { return }
                
                switch changes {
                case .initial(let _):
                    print("Init notification Realm ::")
                
                case .update(let _,
                             deletions: let deletions,
                             insertions: let insertions,
                             modifications: let modifications):
                    
                    tableView.performBatchUpdates {
                        
                        let deletionsIndexPath = deletions.map({ IndexPath(row: $0, section: 0)})
                        let insertionsIndexPath = insertions.map({ IndexPath(row: $0, section: 0)})
                        let modificationsIndexPath = modifications.map({ IndexPath(row: $0, section: 0)})
                        
                        tableView.deleteRows(at: deletionsIndexPath, with: .automatic)
                        tableView.insertRows(at: insertionsIndexPath, with: .automatic)
                        tableView.reloadRows(at: modificationsIndexPath, with: .automatic)

                    } completion: { completed in
                        print("completed update: \(completed)")
                    }
                    
                case .error(let error):
                    print(error)
                }
            })
        } catch {
            print(#function)
            print("❌ Realm notification error")
            print(error)
            
        }
        
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
                let deleteObject = self.contactListForTableViewDictionary[keyByIndexPath]
                
                // Delete from Realm
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.delete(deleteObject!)
                    }
                    
                } catch {
                    print(#function)
                    print("❌ Realm delete error")
                    print(error)
                }
                
                
                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FriendProfileSegueID" {
            let destination = segue.destination as! FriendProfileCollectionViewController
            let index = tableView.indexPathForSelectedRow
            // передаем на следующий VC выбранную ячейку
            let keyByIndexPath = contactListForTableViewDictionary.keys.sorted()[index!.section]
            destination.updateData(user: contactListForTableViewDictionary[keyByIndexPath]![index!.row])
        }
    }
    
    // MARK: - IBActions
    // MARK: - Public Methods
    // MARK: - Private Methods
    
    // Получаем данные друзей (id, имя, аватарку) из сети
    private func fetchUser() {
        Task {
            await service.loadFriendsProfile()
            await fetchRealmData()
            tableView.reloadData()
        }
        
    }
    
    private func fetchRealmData() async {
        
        do {
            let config = Realm.Configuration()
//            config.deleteRealmIfMigrationNeeded = true
            let realm = try await Realm(configuration: config)
            
            let UserList = realm.objects(User.self)
            // List -> Array
            source = UserList.map({ user in
                return user
            })
            
        } catch {
            print(#function)
            print("❌ Can't get object from Realm")
            print(error)
        }
        
        self.contactListForTableViewDictionary = self.createDictionaryForContactList(contactList: self.source)
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

