//
//  DetailViewController.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/09.
//

import UIKit
import RxSwift
import RxCocoa

struct User {
    let name: String
    let imageName: String
}

class DetailViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    
    
    let bottomView = BottomView()
    let middleView = MiddleView()
    let topView = TopView()
    
    let detailListViewModel = DetailListViewModel()
    let searchController = UISearchController()
    let searchBar = UISearchBar()
    
    private let disposeBag = DisposeBag()
    
    var homeTitle: String = "detail"
    
    private let allUsers = [
        User(name: "かとう", imageName: "Home"),
        User(name: "たなか", imageName: "Settings"),
        User(name: "ひらや", imageName: "Profile"),
        User(name: "おおはし", imageName: "Flights"),
        User(name: "やまもと", imageName: "Activity"),
    ]
    
    private var filteredUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredUsers = allUsers
        
        setupLayout()
        setupSearchBar()
        setupBinding()
        
    }
    
    private func setupSearchBar() {
        
        navigationItem.searchController?.searchBar.delegate = self
        
        // インクリメンタルサーチのテキストを取得するためのObservable
        let incrementalSearchTextObservable = rx
        // UISearchBarに文字列入力中に呼ばれるUISearchBarDelegateのメソッドをフック
            .methodInvoked(#selector(UISearchBarDelegate.searchBar(_:shouldChangeTextIn:replacementText:)))
        // searchBar.textの値が確定するまで0.3待つ
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        // 確定したsearchBar.textを取得
            .flatMap { [unowned self] _ in Observable.just(self.navigationItem.searchController?.searchBar.text ?? "") }
        
        // UISearchBarのクリア（×）ボタンや確定ボタンタップにテキストを取得するためのObservable
        let textObservable = self.navigationItem.searchController?.searchBar.rx.text.orEmpty.asObservable()
        
        // 2つのObservableをマージ
        let searchTextObservable = Observable.merge(incrementalSearchTextObservable, textObservable!)
        // 初期化時に空文字が流れてくるので無視
            .skip(1)
        // 0.3秒経過したら入力確定とみなす
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        // 変化があるまで文字列が流れないようにする、つまり連続して同じテキストで検索しないようにする。
            .distinctUntilChanged()
        // subscribeして流れてくるテキストを使用して検索
        searchTextObservable.subscribe(onNext: { [unowned self] text in
            
            if text.isEmpty {
                // 空文字の場合は全件表示
                self.filteredUsers = self.allUsers
            } else {
                // 入力文字列がある場合はデータをフィルタリングして表示
                self.filteredUsers = self.allUsers.filter { $0.name.contains(text) }
            }
            middleView.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    
    private func setupLayout() {
        
        self.navigationItem.setTitleView(withTitle: homeTitle)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.setSearchTextFieldBackgroundColor(color: .rgb(red: 200, green: 200, blue: 200))
//        self.navigationItem.searchController?.searchBar.delegate = self
        
        let baseStackView = UIStackView(arrangedSubviews: [topView, middleView, bottomView])
        baseStackView.axis = .vertical
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(baseStackView)
        
        [topView.heightAnchor.constraint(equalToConstant: 150),
         bottomView.heightAnchor.constraint(equalToConstant: 125),
         baseStackView.topAnchor.constraint(equalTo: view.topAnchor),
         baseStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         baseStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
         baseStackView.rightAnchor.constraint(equalTo: view.rightAnchor),]
            .forEach { $0.isActive = true }
        
        middleView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        middleView.tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = filteredUsers[indexPath.row].name
        cell.imageView?.image = UIImage(systemName: filteredUsers[indexPath.row].imageName)
        print(filteredUsers[indexPath.row].imageName)
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 入力された値がnilでなければif文のブロック内の処理を実行
        if let word = searchBar.text {
            print(word)
        }
    }
    
    private func setupBinding() {
        
        middleView.tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print(indexPath.row)
                //選択色取り消し
                self.middleView.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        bottomView.searchButton.button.rx.tap
            .asDriver()
            .drive { _ in
                print("search")
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}


