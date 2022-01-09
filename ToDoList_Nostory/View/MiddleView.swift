//
//  MiddleView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/09.
//

import UIKit
import RxSwift
import RxCocoa

struct Product {
    
    let imageName: String
    let title: String
}

struct ProductViewModel {
    
    var items = PublishSubject<[Product]>()
    
    func fetchItems() {
        
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Setting"),
            Product(imageName: "person.circle", title: "Profile")
        ]
        items.onNext(products)
        items.onCompleted()
    }
    
    
}

class MiddleView: UIView {
    
    private let tableView: UITableView = {
        
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = ProductViewModel()
    
    private var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor)
        bindTableData()
    }
    
    private func bindTableData() {
        
        viewModel.items.bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)
        ) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print(indexPath.row)
//                self.goView()
            })
            .disposed(by: bag)
        
        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        
        viewModel.fetchItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
