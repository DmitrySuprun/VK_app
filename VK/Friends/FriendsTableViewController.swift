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
    
    // сервисный класс загрузки данных из API idFriends и данные друзей
    let service = UserService()
    // сервисный класс загрузки всех фотографий пользователя
    let getAllPhotosService = GetAllPhotoService()
    // полученные данные от API
    var usersFromApiVK: User!
    // Массив моделей всех друзей
    var source: [UserModel] = []
    // Отсортированный словарь с данными друзей
    var contactListForTableViewDictionary = [ String:[UserModel] ]()
    
    // MARK: - Private Properties
    // MARK: - Initializers
    // MARK: - Override Methods
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // получаем id'шники друзей
        fetchFriendsID()
        
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
    
    // Получаем id друзей пользователя
    private func fetchFriendsID() {
       
        
        self.service.loadFriendsID { [weak self] result in
            switch result {
            case .success(let items):
                // Запрашиваем данные пользователей по их id
                self?.fetchUser(ids: items)
            case .failure(let error):
                print(#function)
                print(error)
            }
        }
    }
    
    // Получаем данные друзей (имя, аватарку)
    private func fetchUser(ids: [Int]) {
        service.loadFriendsProfile(userID: ids) { [weak self] result in
            switch result {
            case .success(let user):
                self?.usersFromApiVK = user
                // Получаем все фотографии конкретного пользователя
                self?.getAllPhoto()
            case .failure(let error):
                print(#function)
                print(error)
            }
        }
    }
    
    // Получаем все фото друга
    private func getAllPhoto() {
        
        self.updateSource()
        
    }
    
    private func updateSource() {
        
        for user in self.usersFromApiVK.userData {
            
            let name = user.firstName + " " + user.lastName
            let avatarImageLoad = user.avatarImage
            let id = user.id
            addUser(name: name, id: id, avatarImage: avatarImageLoad, images: [])
            
        }
    }
    
    func addUser(name: String, id: Int, avatarImage: String, images: [(String, Int)]) {
        let model = UserModel(name: name,
                              id: id,
                              avatarImage: avatarImage,
                              likeCount: Int.random(in: 1...10),
                              isLike: Bool.random(),
                              images: images)
        self.source.append(model)
        self.contactListForTableViewDictionary = self.createDictionaryForContactList(contactList: self.source)
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
    
    private func createDictionaryForContactList (contactList: [UserModel]) -> [String : [UserModel]] {
        
        var result = [ String:[UserModel] ]()
        
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
