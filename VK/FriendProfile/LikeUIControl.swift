//
//  LikeUIControl.swift
//  VK
//
//  Created by Дмитрий Супрун on 16.04.22.
//

import UIKit

class LikeControl: UIControl {
    
    // MARK: - IBOutlets
    // MARK: - Public Properties
    public var isLike: Bool = false {
        didSet {
            imageView.image = image
        }
    }
    // MARK: - Private Properties
    private weak var imageView: UIImageView!
    private var image: UIImage {
        return isLike ? UIImage(systemName: "heart.fill")! : UIImage(systemName: "heart")!
    }
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Override Methods
    // MARK: - IBActions
    // MARK: - Public Methods
    // MARK: - Private Methods
    private func setup() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        self.imageView = imageView
        backgroundColor = UIColor.clear
        
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        
    }
    
    @objc func touchUpInside () {
        isLike.toggle()
        sendActions(for: .valueChanged)
    }

    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

