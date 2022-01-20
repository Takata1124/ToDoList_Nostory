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
//    let today: String
}

class TaskViewModel {
    
    let defaults = UserDefaults.standard
    var tasks = BehaviorRelay<[Task]>(value: [])
    var filteredTask = [Task]()
    var taskArray: [Task] = []
    
    init() {
        
        var outArray: [Task] = []
    
        outArray = readItems(keyName: "taskArray")!
        print(outArray)
//        outArray.reverse()
        self.tasks.accept(outArray)
        
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()
        let datedate = f.string(from: now)
        print(datedate)
        print(type(of: datedate))
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
    
    func deleteItem(indexPath: Int, editing: Bool) {
        
        if editing == true {

            taskArray = filteredTask
            taskArray.remove(at: indexPath)
            taskArray.reverse()
            filteredTask = taskArray
            
            print(filteredTask)

        } else {

            print("pass")
        }
    }
}


