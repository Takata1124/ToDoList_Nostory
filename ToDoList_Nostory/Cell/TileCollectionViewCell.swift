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
    
    var labelBool: Bool? {
        
        didSet {
            if labelBool == true {
                label.backgroundColor = .yellow
            } else {
                label.backgroundColor = .white
            }
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.backgroundColor = .white
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.cornerRadius = 10
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.black.cgColor
//        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let screenWidth = screenSize.width / 1.3
//        let screeHeight = screenSize.height / 2
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(dateLabel)
        
        imageView.anchor(top:  contentView.topAnchor, centerX: contentView.centerXAnchor,
                         width: screenWidth , height: screenWidth / 3 * 4, topPadding: 20)
        label.anchor(top: imageView.bottomAnchor, centerX: contentView.centerXAnchor,
                     width: screenWidth, height: 40, topPadding: 20)
        dateLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                         width: 100, height: 40, topPadding: 30, leftPadding: 40)
    }
    
    private func setUpLayout() {
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}
