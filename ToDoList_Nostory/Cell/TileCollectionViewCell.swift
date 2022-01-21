//
//  TileCollectionViewCell.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/15.
//

import UIKit

//let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

class TileCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TileCollectionViewCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.backgroundColor = .white
//        label.layer.borderWidth = 1.0
//        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "富士山")
//        imageView.layer.borderColor = UIColor.black.cgColor
//        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let screenWidth = screenSize.width / 2
        let screeHeight = screenSize.height / 2
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.anchor(top:  contentView.topAnchor, centerX: contentView.centerXAnchor,
                         width: screenWidth, height: screeHeight, topPadding: 20)
        label.anchor(top: imageView.bottomAnchor, centerX: contentView.centerXAnchor,
                     width: screenWidth, height: 40, topPadding: 20)
    }
    
    private func setUpLayout() {
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 6
//        contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
//        contentView.layer.borderWidth = 1.5
//        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}
