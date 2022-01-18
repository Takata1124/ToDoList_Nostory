//
//  CollectionTableViewCell.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/15.
//

import UIKit
import RxSwift
import RxCocoa

protocol CollectionTableViewCellDelegate: AnyObject {
    
    func collectionTableViewCellDidTapItem(with viewModel: TileCollectionViewCellViewModel)
 
}

struct UserTableViewCellViewModel: Codable {
    let name: String
}


class CollectionTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionTableViewCell"
    weak var delegatee: CollectionTableViewCellDelegate?
    
    private var viewModels: [TileCollectionViewCellViewModel] = []
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        let collectionView = UICollectionView (
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(TileCollectionViewCell.self, forCellWithReuseIdentifier: TileCollectionViewCell.identifier)
        collectionView.backgroundColor = .rgb(red: 200, green: 200, blue: 200, alpha: 1)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.delegate = self
//        collectionView.dataSource = self
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModels.count
////        return userViewModel.users.value.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: TileCollectionViewCell.identifier, for: indexPath
//        ) as? TileCollectionViewCell else {
//            fatalError()
//        }
//        cell.label.text = userViewModel.users.value[indexPath.row].name
////        cell.configure(with: viewModels[indexPath.row])
//        return cell
//        
//    }
    
//    func configure(with viewModel: [TileCollectionViewCellViewModel]) {
//        self.viewModels = viewModel
//    }
    
    
    
}

extension CollectionTableViewCell: UICollectionViewDelegate,  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace:CGFloat = 100
        let height: CGFloat = contentView.bounds.height - horizontalSpace
        let width = contentView.bounds.width - horizontalSpace
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let viewModel = viewModels[indexPath.row]
        print(indexPath.row)
//        self.middleView.tableView.deselectRow(at: indexPath, animated: true)
       
//        delegatee?.collectionTableViewCellDidTapItem(with: viewModel)
    }
}
 
