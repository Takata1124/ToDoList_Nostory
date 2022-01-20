//
//  MiddleCollectionView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/18.
//

import UIKit

class MiddleCollectionView: UIView {
    
    let taskViewModel = TaskViewModel()
    //lazy var 出ないとエラー
    lazy var viewModelCount = taskViewModel.filteredTask.count {
        didSet {
            countLabel.text = "\(viewModelCount)展"
        }
    }
    
    let countLabel: UILabel = {
       let label = UILabel()
        label.textColor = .yellow
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    let uiCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView (
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(TileCollectionViewCell.self, forCellWithReuseIdentifier: TileCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
       
        return collectionView
    }()
    
    let uiImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"夜画像")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let deleteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "trash")
        imageView.tintColor = .red
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .yellow

        uiCollectionView.backgroundView = uiImageView
        
        deleteImage.isHidden = true
        
        addSubview(uiCollectionView)
        addSubview(deleteImage)
        addSubview(countLabel)
        
        uiCollectionView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor)
        deleteImage.anchor(centerY: centerYAnchor, centerX: centerXAnchor, width: 200, height: 200)
        countLabel.anchor(top: topAnchor, left: leftAnchor, width: 100, height: 30, topPadding: 15, leftPadding: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
