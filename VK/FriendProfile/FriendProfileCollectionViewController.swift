//
//  FriendProfileCollectionViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 11.04.22.
//

import UIKit
import RealmSwift

class FriendProfileCollectionViewController: UICollectionViewController {
    
    var currentUser = User()
    
    let service = FetchAllPhotoService()
    
    var userProfileInfo = UserAllPhotos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllPhoto()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userProfileInfo.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendProfileCellID", for: indexPath) as! FriendProfileCollectionViewCell
        cell.userImage.loadImage(url: userProfileInfo.photos[indexPath.row].photoURL)
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = UIColor.systemBlue.cgColor
        cell.likeControl.likeCount = userProfileInfo.photos[indexPath.row].likeCount
        cell.likeControl.isLike = userProfileInfo.photos[indexPath.row].isLiked
        
        return cell
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "PhotoAnimationViewControllerID" {
    //            let destination = segue.destination as! PhotoAnimationViewController
    //            destination.userProfileInfo = self.userProfileInfo
    //        }
    //    }
    
    // Передача данных из FriendsTableView
    
    func updateData(user: User) {
        self.currentUser = user
    }
    
    func fetchAllPhoto() {
        Task {
            try await service.loadPhoto(id: String(currentUser.id))
            await fetchRealmData()
            collectionView.reloadData()

        }
    }
    
    func fetchRealmData() async {
        do {
            let realm = try await Realm()
            let allPhoto = realm.object(ofType: UserAllPhotos.self, forPrimaryKey: currentUser.id)
            DispatchQueue.main.async {
                // Force-unwrap
                self.userProfileInfo = allPhoto!
                self.collectionView.reloadData()
            }
        } catch {
            print(#function)
            print("❌ Realm can't read data")
            print(error)
        }
    }
}
