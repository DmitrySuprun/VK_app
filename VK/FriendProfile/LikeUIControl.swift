//
//  LikeUIControl.swift
//  VK
//
//  Created by Дмитрий Супрун on 16.04.22.
//

import UIKit

class LikeControl: UIControl {
    
    // MARK: - Public Properties
        
    public var likeCount: Int = 0
    // при изменении значения control'a меняются картинка и лайки
    public var isLike: Bool = true {
        didSet {
            imageView.image = image
            lableView.text = String(likeCount)
        }
    }
    // MARK: - Private Properties
    
    private weak var imageView: UIImageView!
    private weak var lableView: UILabel!
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
    // для обновления при появлении окна likeCount, т.к. при инициализации всегда 0
    override func layoutSubviews() {
        isLike.toggle()
    }
    // MARK: - IBActions
    // MARK: - Public Methods
    
    @objc func touchUpInside () {
        
        let animation = CASpringAnimation(keyPath: #keyPath(CALayer.bounds))

        animation.fromValue = CGRect(x: 0, y: 0,
                                     width: imageView.bounds.width - 5,
                                     height: imageView.bounds.height - 5)
        animation.toValue = imageView.bounds
        animation.initialVelocity = 0.1
        animation.damping = 0.7
        animation.stiffness = 70
        animation.mass = 0.1
        animation.duration = 1
        imageView.layer.add(animation, forKey: nil)
        
        if !isLike {
            likeCount += 1
        } else {
            likeCount -= 1
        }
        isLike.toggle()
        // для реализации @IBAction control'a
        sendActions(for: .valueChanged)
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        
        let imageView = UIImageView()
        let label = UILabel()
        
        label.text = String(likeCount)
        label.textAlignment = .center
        label.textColor = .white
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(label)
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.imageView = imageView
        self.lableView = label
        backgroundColor = UIColor.clear
        
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
}

