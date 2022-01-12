//
//  MiddleView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/09.
//

import UIKit
import RxSwift
import RxCocoa

//struct Product {
//
//    let imageName: String
//    let title: String
//}
//
//struct ProductViewModel {
//
////    var items = PublishSubject<[Product]>()
//    var relay = BehaviorRelay<[Product]>(value: [])
//
//    func fetchItems() {
//
//        let products = [
//            Product(imageName: "house", title: "Home"),
//            Product(imageName: "gear", title: "Setting"),
//            Product(imageName: "person.circle", title: "Profile")
//        ]
//
//        relay.accept(products)
//
////        items.onNext(products)
////        items.onCompleted()
//    }
//
//}

struct ListModel {
    
    let initTweet: String
}

class ListViewModel {
    
    var titleArray = BehaviorRelay<[ListModel]>(value: [ListModel(initTweet: "hello")])
    
    init() {
        //       relayItems = Observable<[TweetModel]>(value: tweetList)
        titleArray.accept(titleArray.value + [ListModel(initTweet: "kind")])
    }
    
    func append(_ element: ListModel) {
        titleArray.accept(titleArray.value + [element])
        print(titleArray.value)
    }
}

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
        
        bindTableData()
    }
    
    private func bindTableData() {
        
        tableView.rx.modelSelected(ListModel.self).bind { tweet in
            print(tweet.initTweet)
        }.disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
