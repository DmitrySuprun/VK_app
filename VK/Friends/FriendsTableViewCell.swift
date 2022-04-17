//
//  FriendsTableViewCell.swift
//  VK
//
//  Created by Дмитрий Супрун on 9.04.22.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
   
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    // параметры тени можно поменять в storyboard
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowOpacity: Float = 1
    @IBInspectable var shadowRadius: CGFloat = 1
    
    // MARK: - Public Properties
    
    // свойство в которое передается картинка аватарки
    var avatarView = UIImageView()
    
    // MARK: - Private Properties
    // MARK: - Initializers
    // MARK: - Override Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        // получаем размер imageView со storyboard
        let size = avatar.frame.height
        
        // обрезаем и красим тень
        avatar.layer.cornerRadius = size / 2
        avatar.layer.shadowColor = shadowColor.cgColor
        avatar.layer.shadowOpacity = shadowOpacity
        avatar.layer.shadowRadius = shadowRadius
        avatar.layer.shadowOffset = CGSize(width: 5, height: 2)
        avatar.layer.masksToBounds = false
        
        // добавляем на вью с тенью вью с аватаркой
        avatarView.frame = .init(x: 0, y: 0, width: size, height: size)
        avatarView.layer.cornerRadius = size / 2
        avatarView.clipsToBounds = true
        avatar.addSubview(avatarView)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    // MARK: - Public Methods
    // MARK: - Private Methods
}
