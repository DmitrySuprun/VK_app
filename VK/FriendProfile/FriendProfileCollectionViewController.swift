////
////  FriendProfileCollectionViewController.swift
////  VK
////
////  Created by Дмитрий Супрун on 11.04.22.
////
//
//import UIKit
//import RealmSwift
//
//class FriendProfileCollectionViewController: UICollectionViewController {
//    
//    let service = GetAllPhotoService()
//    
//    var userProfileInfo = User()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        fetchAllPhoto()
//    }
//
//    // MARK: UICollectionViewDataSource
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return userProfileInfo.images.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendProfileCellID", for: indexPath) as! FriendProfileCollectionViewCell
//        cell.userImage.loadImage(url: userProfileInfo.images[indexPath.row].0)
//        cell.contentView.layer.cornerRadius = 10
//        cell.contentView.layer.borderWidth = 3
//        cell.contentView.layer.borderColor = UIColor.systemBlue.cgColor
//        cell.likeControl.likeCount = userProfileInfo.images[indexPath.row].1
//        cell.likeControl.isLike = userProfileInfo.isLike
//
//        return cell
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "PhotoAnimationViewControllerID" {
//            let destination = segue.destination as! PhotoAnimationViewController
//            destination.userProfileInfo = self.userProfileInfo
//        }
//    }
//    
//    // Передача данных из FriendsTableView
//    func updateData(user: UserModel) {
//        userProfileInfo = user
//    }
//    
//    func fetchAllPhoto() {
//        service.loadPhoto(id: String(userProfileInfo.id)) { [weak self] result in
//            switch result {
//            case .success(let photo):
//                
//                var result = [(String, Int)]()
//                for item in photo.photos {
//                    for size in item.sizes {
//                        if size.type == "x" {
//                            result.append((size.url, item.likes.count ?? 0))
//                        }
//                    }
//                }
//                
//                do {
////                    var config = Realm.Configuration()
////                    config.deleteRealmIfMigrationNeeded = true
////                    let realm = try Realm(configuration: config)
//                    let realm = try Realm()
//                    try realm.write {
//                        realm.add(photo)
//                    }
//                } catch {
//                    print(#function)
//                    print("Realm Error")
//                }
//                
//                DispatchQueue.main.async {
//                    self?.userProfileInfo.images = result
//                    self?.collectionView.reloadData()
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//}
