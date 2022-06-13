//
//  FriendProfileCollectionViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 11.04.22.
//

import UIKit

class FriendProfileCollectionViewController: UICollectionViewController {
    
    let service = GetAllPhotoService()
    
    var userProfileInfo = UserModel(name: "", avatarImage: "", likeCount: 0)

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
        return userProfileInfo.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendProfileCellID", for: indexPath) as! FriendProfileCollectionViewCell
        cell.userImage.loadImage(url: userProfileInfo.images[indexPath.row].0)
        cell.likeControl.likeCount = userProfileInfo.images[indexPath.row].1
        cell.likeControl.isLike = userProfileInfo.isLike

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoAnimationViewControllerID" {
            let destination = segue.destination as! PhotoAnimationViewController
            destination.userProfileInfo = self.userProfileInfo
        }
    }
    
    // Передача данных из FriendstableView
    func updateData(user: UserModel) {
        userProfileInfo = user
    }
    
    func fetchAllPhoto() {
        service.loadPhoto(id: String(userProfileInfo.id)) { [weak self] result in
            switch result {
            case .success(let photo):
                DispatchQueue.main.async {
                    self?.userProfileInfo.images = photo
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
