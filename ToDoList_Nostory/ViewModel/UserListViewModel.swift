//
//  UserListViewModel.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/17.
//

import UIKit
import RxSwift
import RxCocoa

class UserListViewModel {
    
    var users = BehaviorRelay<[UserTableViewCellViewModel]>(value:[UserTableViewCellViewModel(name: "default")])

    let userDefaults = UserDefaults.standard
    var userViewArray: [UserTableViewCellViewModel] = []
    
    init() {
        decodeDefault()
    }
    
    func encodeDefault(list: [UserTableViewCellViewModel]) {
        
        //配列をエンコードする場合はpropertyListEncorder
        if let encoded = try? PropertyListEncoder().encode(list) {
            userDefaults.set(encoded, forKey: "list")
        }
    }
    
    func decodeDefault() {
        
        if let listTask = userDefaults.object(forKey: "list") as? Data {
            do {
                let userModels = try? PropertyListDecoder().decode([UserTableViewCellViewModel].self, from: listTask)
                
                userViewArray = userModels!
            } catch {
                fatalError()
            }
        } else {
            print("error")
            return
        }
        
        users.accept(userViewArray.reversed())
    }
    
    func TextAppend(_ element: UserTableViewCellViewModel) {
        
        userViewArray.append(element)
        encodeDefault(list: userViewArray)
        decodeDefault()
        
    }
    
}
