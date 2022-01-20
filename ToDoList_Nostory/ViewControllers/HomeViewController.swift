//
//  ViewController.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    //UIViewで型を指定するとエラーになる
    let bottomView = BottomView()
    let middleView = MiddleView()
    let topView = TopView()
    
    let middleCollectionView = MiddleCollectionView()
    let searchController = UISearchController()
    let addTaskViewController = AddTaskViewController()
    let taskViewModel = TaskViewModel()
    
    let userDefaults = UserDefaults.standard
    
    var editingBool: Bool? {
        
        didSet {
            if editingBool ?? false {
                navigationItem.rightBarButtonItem?.tintColor = .red
                middleCollectionView.deleteImage.isHidden = false
            } else {
                navigationItem.rightBarButtonItem?.tintColor = .yellow
                middleCollectionView.deleteImage.isHidden = true
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    
    var addBtn_2 = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(editBarButtonTapped(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
        setupSearchbar()
    }
    
    private func setupLayout() {
        
        navigationItem.rightBarButtonItem = addBtn_2
        editingBool = false
        
        self.navigationItem.setTitleView(withTitle: "Art Gallery")
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.setSearchTextFieldBackgroundColor(color: .rgb(red: 200, green: 200, blue: 200))
        navigationItem.searchController?.searchBar.tintColor = .yellow
        
        let baseStackView = UIStackView(arrangedSubviews: [topView, middleCollectionView, bottomView])
        baseStackView.axis = .vertical
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(baseStackView)
        
        [topView.heightAnchor.constraint(equalToConstant: 150),
         bottomView.heightAnchor.constraint(equalToConstant: 150),
         
         baseStackView.topAnchor.constraint(equalTo: view.topAnchor),
         baseStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         baseStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
         baseStackView.rightAnchor.constraint(equalTo: view.rightAnchor),]
            .forEach { $0.isActive = true }
        
        middleCollectionView.uiCollectionView.delegate = self
        middleCollectionView.uiCollectionView.dataSource = self
        
        self.taskViewModel.filteredTask = self.taskViewModel.tasks.value
        self.taskViewModel.filteredTask.reverse()
        self.middleCollectionView.viewModelCount = self.taskViewModel.filteredTask.count
    }
    
    private func setupSearchbar() {
        
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
        searchTextObservable
            .subscribe(onNext: { [unowned self] text in
                
                if text.isEmpty {
                    // 空文字の場合は全件表示
                    self.taskViewModel.filteredTask = self.taskViewModel.tasks.value
                    updateCollectionView()
                } else {
                    
                    var existing = self.taskViewModel.tasks.value
                    self.taskViewModel.filteredTask = existing.filter { $0.title.contains(text) }
                }
                self.middleCollectionView.viewModelCount = self.taskViewModel.filteredTask.count
                self.updateCollectionView()
                
            }).disposed(by: disposeBag)
    }
    
    func updateCollectionView() {
        
        self.middleCollectionView.uiCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.textField?.text = ""
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return taskViewModel.filteredTask.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCollectionViewCell", for: indexPath) as! TileCollectionViewCell
        
        cell.label.text = taskViewModel.filteredTask[indexPath.row].title
        cell.imageView.image = UIImage(data: taskViewModel.filteredTask[indexPath.row].fileData as Data)
        
        return cell
    }
    
    func textInput() {
        
        navigationItem.searchController?.searchBar.textField?.becomeFirstResponder()
    }
    
    private func setupBindings() {
        
        self.addBtn_2.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                if self?.editingBool == false {
                    self?.editingBool = true
                } else {
                    self?.editingBool = false
                }
            }
            .disposed(by: disposeBag)
        
        bottomView.settingButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
            }
            .disposed(by: disposeBag)
        
        bottomView.plusButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                self?.navigationController?.pushViewController(self!.addTaskViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        bottomView.searchButton.button.rx.tap
            .asDriver()
            .drive { _ in
                self.textInput()
            }
            .disposed(by: disposeBag)
        
        addTaskViewController.taskSubjectObservable
            .subscribe { task in
                
                var existingTasks = self.taskViewModel.tasks.value
                
                //                existingTasks.reverse()
                existingTasks.append(task.element!)
                
                self.taskViewModel.saveItems(items: existingTasks, keyName: "taskArray")
                
                var taskModel: [Task] = []
                //userdefaultsの処理に時間がかかるため
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                    
                    self.taskViewModel.tasks.accept(existingTasks)
                    taskModel = self.taskViewModel.tasks.value
                    taskModel.reverse()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                    self.taskViewModel.filteredTask = taskModel
                    self.middleCollectionView.viewModelCount = self.taskViewModel.filteredTask.count
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
                    
                    self.updateCollectionView()
                }
                
            }.disposed(by: disposeBag)
        
        middleCollectionView.uiCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                
                self.taskViewModel.deleteItem(indexPath: indexPath.row, editing: self.editingBool!)
                
                var taskModel: [Task] = []
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    
                    taskModel = self.taskViewModel.filteredTask
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    
                    self.taskViewModel.saveItems(items: taskModel, keyName: "taskArray")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    
                    taskModel = self.taskViewModel.readItems(keyName: "taskArray")!
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                    taskModel.reverse()
                    
                    self.taskViewModel.filteredTask = taskModel
                    self.middleCollectionView.viewModelCount = self.taskViewModel.filteredTask.count
                    self.updateCollectionView()
                }
            }).disposed(by: disposeBag)
        
    }
    
    //navigationItemがエラーになるので設定
    @objc func editBarButtonTapped(_ sender: UIBarButtonItem) {
        print("tapped")
        
    }
}






