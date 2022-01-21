

import UIKit
import RxSwift
import RxCocoa

struct Task: Codable {
    
    let title: String
    let fileData: Data
    let today: String
    let tapbutton: Bool
}

class TaskViewModel {
    
    let defaults = UserDefaults.standard
    var tasks = BehaviorRelay<[Task]>(value: [])
    var filteredTask = [Task]()
    var taskArray: [Task] = []
    
    init() {
        
//        //userDefaultsの初期化
//        defaults.removeObject(forKey: "taskArray")
        
        var outArray: [Task] = []
        
        outArray = readItems(keyName: "taskArray")!
        self.tasks.accept(outArray)
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

        taskArray = filteredTask
        taskArray.remove(at: indexPath)
        taskArray.reverse()
        filteredTask = taskArray
    }
}


