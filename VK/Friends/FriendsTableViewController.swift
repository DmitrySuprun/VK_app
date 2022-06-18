//
//  FriendsTableViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 9.04.22.
//

import UIKit
import CoreData

class FriendsTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    // MARK: - Public Properties
    
    // context of CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        // чтение данных из CoreData
        fetchCoreData()
        
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
    
    // CoreData
    
    // Для поиска файлов .sqlite в симуляторе и анализе через стороннее приложение
    func getCoreDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print("Core Data DB Path ::")
        print("\(path ?? "Not found")")
    }
    
    private func saveCoreData() {
        for item in source {
            let user = UserCoreData(context: self.context)
            user.id = Int64(item.id)
            user.name = item.name
            user.avatarImage = item.avatarImage
            user.isLike = item.isLike
            for image in item.images {
                let images = ImagesCoreData(context: self.context)
                images.image = image.0
                images.likeCount = Int64(image.1)
                user.addToImages(images)
            }
            do {
                try self.context.save()
            } catch {
                print("❌❌❌ Can't save data in DataCore")
            }
        }
    }
    
    private func fetchCoreData() {
        do {
            let result = try self.context.fetch(UserCoreData.fetchRequest())
            
            for item in result {
                
                addUser(name: item.name ?? "",
                        id: Int(item.id),
                        avatarImage: item.avatarImage ?? "",
                        images: [])
            }
        } catch {
            print("❌❌❌ Couldn't read CoreData")
        }
        self.updateAndReloadTableView()
    }
    
    private func deleteAllCoreData() {
        
        do {
            let result = try self.context.fetch(UserCoreData.fetchRequest())
            for item in result {
                self.context.delete(item)
            }
        } catch {
            print("❌❌❌ Couldn't read CoreData in delete func")
        }
        
        do {
            try self.context.save()
        } catch {
            print("❌❌❌ Can't delete CoreData")
        }
    }
    
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
                // сохраняем полученные данные в DataCore
                self?.updateDataCore()
            case .failure(let error):
                print(#function)
                print(error)
            }
        }
    }
    
    private func updateDataCore() {
        // Обновляем CoreData удаляем все значения и записываем новые
        self.deleteAllCoreData()
        self.source.removeAll()
        
        for userFromApi in self.usersFromApiVK.userData {
            
            let name = userFromApi.firstName + " " + userFromApi.lastName
            let avatarImageLoad = userFromApi.avatarImage
            let id = userFromApi.id
            
            let user = UserCoreData(context: self.context)
            user.id = Int64(id)
            user.name = name
            user.avatarImage = avatarImageLoad
            user.isLike = false
            
            let images = ImagesCoreData(context: self.context)
            images.likeCount = 0
            images.image = ""
            user.addToImages(images)
            
            
        }
        do {
            try self.context.save()
        } catch {
            print("❌❌❌ Can't save data in DataCore")
        }
        self.fetchCoreData()
    }
    
    
    private func addUser(name: String, id: Int, avatarImage: String, images: [(String, Int)]) {
        let model = UserModel(name: name,
                              id: id,
                              avatarImage: avatarImage,
                              likeCount: 0,
                              isLike: Bool.random(),
                              images: images)
        self.source.append(model)
    }
    
    private func updateAndReloadTableView() {
        
        self.contactListForTableViewDictionary = self.createDictionaryForContactList(contactList: self.source)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // Создаем словарь для удобной работы с TableView
    private func createDictionaryForContactList (contactList: [UserModel]) -> [String : [UserModel]] {
        // Модель словаря
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
