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
        table.register(TaskCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = ListViewModel()
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor)
        tableView.rowHeight = 70.0
        tableView.separatorColor = .black
        tableView.separatorInset = .zero
        bindTableData()
    }
    
    private func bindTableData() {
        
        tableView.rx.modelSelected(ListModel.self).bind { tweet in
            print(tweet.taskName)
        }.disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
