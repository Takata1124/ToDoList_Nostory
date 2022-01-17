//
//  MiddleView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/09.
//

import UIKit
import RxSwift
import RxCocoa

class MiddleView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    let tableView: UITableView = {
        
        let table = UITableView()
        //forCellReuseIdentifierは"cell"でないとエラー
        table.backgroundColor = .lightGray
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor)
        //        tableView.rowHeight = cellHight
        tableView.separatorInset = .zero
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //    init(cellHight: CGFloat, tableCell: UITableViewCell.Type, cellIdentifier: String) {
    //        super.init(frame: .zero)
    //
    ////        tableView.register(tableCell.self, forCellReuseIdentifier: cellIdentifier)
    //
    //
    //    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ sampleTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = "hello"
        
        
        
        return cell
        
    }
}


