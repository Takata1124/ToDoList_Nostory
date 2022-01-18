//
//  ListViewModel.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/12.
//

import UIKit
import RxSwift
import RxCocoa

struct ListModel: Codable {
    
    let taskName: String
}

class ListViewModel {
    
    let userDefaults = UserDefaults.standard
    var historyArray: [ListModel] = []
    
    var titleArray = BehaviorRelay<[ListModel]>(value: [])
    
    func fetchItems() {
        
        let product = [
            ListModel(taskName: "default"),
            ListModel(taskName: "default")
        ]
//        
//        titleArray.bind(onNext: product)
    }
}
