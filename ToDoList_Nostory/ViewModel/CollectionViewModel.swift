//
//  CollectionViewModel.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/16.
//

import UIKit
import RxSwift
import RxCocoa

struct TileCollectionViewCellViewModel: Codable {
    
    let name: String
}

class CollectionTableViewCellViewModel: UIViewController {
    
    var viewModels: [TileCollectionViewCellViewModel] = [
        TileCollectionViewCellViewModel(name: "Apple"),
        TileCollectionViewCellViewModel(name: "Apple"),
        TileCollectionViewCellViewModel(name: "Apple"),
        TileCollectionViewCellViewModel(name: "Apple"),
    ]
    // storyboardでしかアウトレット接続はできない
//    {
//        didSet{
//            let collectionView = CollectionView()
//            collectionView.reloadTableView()
//        }
//    }
    
    func TextAppend(element: TileCollectionViewCellViewModel) {

        self.viewModels.append(element)
        print(self.viewModels)
        
    }
}

class CollectionViewModel {
    
//    var viewModels: [CollectionTableViewCellViewModel] = [
//
//        CollectionTableViewCellViewModel(
//            viewModels: [
//                TileCollectionViewCellViewModel(name: "Apple"),
//                TileCollectionViewCellViewModel(name: "FaceBook"),
//                TileCollectionViewCellViewModel(name: "Instagram"),
//            ]
//        )
//    ]

}
