//
//  TimelineViewController.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/16.
//

import UIKit


class TimelineViewController: UIViewController, UITableViewDataSource {
    
    let userDefaults = UserDefaults.standard
    var userArray: [UserTableViewCellViewModel] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var userViewModel = UserListViewModel()
    var userViewArray: [UserTableViewCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        setupBinding()
        
        TextAppend("hellohello")
    }
    
    private func setupBinding() {
        
        userViewModel.users.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        fetchData()
    }
    
    func fetchData() {
        
        encodeDefault(list: userViewArray)
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

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModel.users.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = userViewModel.users.value[indexPath.row].name
        return cell
    }
    
    func TextAppend(_ element: String) {
        
//        userViewModel.users.value.append(UserTableViewCellViewModel(name: element))
//        print(userViewModel.users.value ?? "")
    }
    
}

