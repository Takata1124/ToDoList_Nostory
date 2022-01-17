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
        //        table.register(TaskCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = ListViewModel()
    private var disposeBag = DisposeBag()
    
    init(cellHight: CGFloat, tableCell: UITableViewCell.Type, cellIdentifier: String) {
        super.init(frame: .zero)
        
        tableView.register(tableCell.self, forCellReuseIdentifier: cellIdentifier)
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor)
        tableView.rowHeight = cellHight
        tableView.separatorInset = .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
