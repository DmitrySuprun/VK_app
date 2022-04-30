//
//  NewsTableViewCell.swift
//  VK
//
//  Created by Дмитрий Супрун on 19.04.22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var newsText: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsText.text = "Создать экран новостей.\n Добавить туда таблицу и сделать ячейку для новости.\n  Ячейка должна содержать то же самое, что и в оригинальном приложении ВКонтакте: надпись, фотографии, кнопки «Мне нравится», «Комментировать», «Поделиться» и индикатор количества просмотров. Сделать поддержку только одной фотографии, которая должна быть квадратной формы и растягиваться на всю ширину ячейки. Высота ячейки должна вычисляться автоматически."
        imageNews.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showMoreButton(_ sender: Any) {
        newsText.numberOfLines = 0
        let tableView = superview as! UITableView
        tableView.reloadData()
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
    }
    
    @IBAction func commentButton(_ sender: Any) {
    }
    
    @IBAction func forwardButton(_ sender: Any) {
    }
    
    @IBAction func viewsButton(_ sender: Any) {
    }
    
}
