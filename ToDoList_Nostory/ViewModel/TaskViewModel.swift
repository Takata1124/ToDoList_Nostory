//
//  TaskViewModel.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/19.
//

import UIKit
import RxSwift
import RxCocoa

struct Task: Codable {
    
    let title: String
    let fileData: Data
}

class TaskViewModel {
    
    let defaults = UserDefaults.standard
    var tasks = BehaviorRelay<[Task]>(value: [])
    var taskArray: [Task] = []
    
    init() {
        
        var outArray: [Task] = []
    
        outArray = readItems(keyName: "taskArray")!
        outArray.reverse()
        self.tasks.accept(outArray)
        print(outArray)
    }
    
    func saveItems(items: [Task], keyName: String) {
        
        let data = items.map { try! JSONEncoder().encode($0) }
        defaults.set(data as [Any], forKey: keyName)
    }
    
    func readItems(keyName: String) -> [Task]? {
        
        guard let items = defaults.array(forKey: keyName) as? [Data] else { return [Task]() }

        let decodedItems = items.map { try! JSONDecoder().decode(Task.self, from: $0) }
        return decodedItems
    }
}


