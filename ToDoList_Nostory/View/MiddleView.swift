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
//        tableView.backgroundColor = .rgb(red: 51, green: 51, blue: 102, alpha: 0.8)
//        tableView.separatorColor = .red
        tableView.separatorInset = .zero
        bindTableData()
    }
    
    private func bindTableData() {
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
