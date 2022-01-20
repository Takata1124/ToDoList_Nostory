//
//  MiddleCollectionView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/18.
//

import UIKit

class MiddleCollectionView: UIView {
    
    let taskViewModel = TaskViewModel()
    lazy var viewModelCount = taskViewModel.tasks.value.count
    
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
        layout.minimumLineSpacing = 30
        
        let collectionView = UICollectionView (
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(TileCollectionViewCell.self, forCellWithReuseIdentifier: TileCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .yellow
        countLabel.text = "\(viewModelCount)展"
        
        addSubview(uiCollectionView)
        addSubview(countLabel)
        
        uiCollectionView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor)
        countLabel.anchor(top: topAnchor, left: leftAnchor, width: 100, height: 30, topPadding: 15, leftPadding: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}