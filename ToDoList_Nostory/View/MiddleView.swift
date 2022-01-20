//
//  MiddleView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/09.
//

import UIKit
import RxSwift
import RxCocoa

class MiddleView: UIView {

    let tableView: UITableView = {
        
        let table = UITableView()
        //forCellReuseIdentifierは"cell"でないとエラー
//        table.backgroundColor = .white
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor)
        tableView.rowHeight = 100
        tableView.separatorInset = .zero

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


