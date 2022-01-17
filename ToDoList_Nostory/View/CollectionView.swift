//
//  CollectionTableView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/15.
//

import UIKit

class CollectionView: UIView, CollectionTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func collectionTableViewCellDidTapItem(with viewModel: TileCollectionViewCellViewModel) {
        print("hello")
    }
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()
    
    let collectionTableViewCellViewModel = CollectionTableViewCellViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        return collectionTableViewCellViewModel.viewModels.count
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = collectionTableViewCellViewModel.viewModels
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionTableViewCell.identifier, for: indexPath
        ) as? CollectionTableViewCell else {
            fatalError()
        }
        cell.delegatee = self
//        cell.configure(with: viewModel)
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
