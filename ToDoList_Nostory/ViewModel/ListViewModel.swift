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
    var titleArray = BehaviorRelay<[ListModel]>(value: [ListModel(taskName: "default")])

    init() {
        decodeDefault()
    }
    
    func encodeDefault(list: [ListModel]) {
        
        let encoder = JSONEncoder()
        //配列をエンコードする場合はpropertyListEncorder
        if let encoded = try? PropertyListEncoder().encode(list) {
            userDefaults.set(encoded, forKey: "list")
        }
    }
    
    func decodeDefault() {
        
        if let listTask = userDefaults.object(forKey: "list") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? PropertyListDecoder().decode([ListModel].self, from: listTask) {
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
    
    func append(_ element: ListModel) {
        
        historyArray.append(element)
        encodeDefault(list: historyArray)
        decodeDefault()

    }
}
