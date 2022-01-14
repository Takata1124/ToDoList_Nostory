//
//  DetailListViewModel.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/13.
//

import UIKit
import RxSwift
import RxCocoa

struct DetailListModel: Codable {
    
    let detailName: String
}

class DetailListViewModel {
    
    let userDefaults = UserDefaults.standard
    
    var historyArray: [DetailListModel] = []
    var titleArray = BehaviorRelay<[DetailListModel]>(value: [DetailListModel(detailName: "default")])

    init() {
        decodeDefault()
    }
    
    func encodeDefault(list: [DetailListModel]) {
        
//        let encoder = JSONEncoder()
        //配列をエンコードする場合はpropertyListEncorder
        if let encoded = try? PropertyListEncoder().encode(list) {
            userDefaults.set(encoded, forKey: "list")
        }
    }
    
    func decodeDefault() {
        
        if let listTask = userDefaults.object(forKey: "list") as? Data {
//            let decoder = JSONDecoder()
            if let loadedPerson = try? PropertyListDecoder().decode([DetailListModel].self, from: listTask) {
                historyArray = loadedPerson
                print(loadedPerson)
            } else {
                print("error")
                return
            }
        }
        
        titleArray.accept(historyArray.reversed())
        print(historyArray)
    }
    
    func append(_ element: DetailListModel) {
        
        historyArray.append(element)
        encodeDefault(list: historyArray)
        decodeDefault()
    }
}

