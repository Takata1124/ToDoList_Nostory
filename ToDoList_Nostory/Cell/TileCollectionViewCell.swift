//
//  TileCollectionViewCell.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/15.
//

import UIKit

class TileCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TileCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.backgroundColor = .white
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "富士山")
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 6
        contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
        contentView.layer.borderWidth = 1.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, centerX: centerXAnchor,
                     height: 40, topPadding: 30, leftPadding: 30, rightPadding: 30)
        imageView.anchor(top: label.bottomAnchor, bottom: contentView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, centerX: centerXAnchor,
                         topPadding: 30, bottomPadding: 30, leftPadding: 30, rightPadding: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: TileCollectionViewCellViewModel) {
        contentView.backgroundColor = .rgb(red: 51, green: 51, blue: 102, alpha: 0.8)
        label.text = viewModel.name
    }
}
