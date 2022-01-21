//
//  ViewController.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    //UIViewで型を指定するとエラーになる
    let bottomView = BottomView()
    let middleView = MiddleView()
    let topView = TopView()
    
    let middleCollectionView = MiddleCollectionView()
    let searchController = UISearchController()
    let addTaskViewController = AddTaskViewController()
    let listViewController = ListViewController()
    
    let taskViewModel = TaskViewModel()
    
    var tempTaskModel: [Task] = []
    
    let userDefaults = UserDefaults.standard
    
    var editingBool: Bool? {
        
        didSet {
            if editingBool ?? false {
//                navigationItem.rightBarButtonItem?.tintColor = .red
                middleCollectionView.deleteImage.isHidden = false
            } else {
//                navigationItem.rightBarButtonItem?.tintColor = .yellow
                middleCollectionView.deleteImage.isHidden = true
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    
//    var addBtn_2 = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(editBarButtonTapped(_:)))
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
        setupSearchbar()
    }
    
    private func setupLayout() {
        
//        navigationItem.rightBarButtonItem = addBtn_2
        editingBool = false
        
        self.navigationItem.setTitleView(withTitle: "Art Gallery")
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.setSearchTextFieldBackgroundColor(color: .rgb(red: 200, green: 200, blue: 200))
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchBar.tintColor = .yellow
        
        let baseStackView = UIStackView(arrangedSubviews: [topView, middleCollectionView, bottomView])
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
        
        middleCollectionView.uiCollectionView.delegate = self
        middleCollectionView.uiCollectionView.dataSource = self
        
        self.taskViewModel.filteredTask = self.taskViewModel.tasks.value
        self.taskViewModel.filteredTask.reverse()
        self.middleCollectionView.viewModelCount = self.taskViewModel.filteredTask.count
    }
    
    private func setupSearchbar() {
        // インクリメンタルサーチのテキストを取得するためのObservable
        let incrementalSearchTextObservable = rx
        // UISearchBarに文字列入力中に呼ばれるUISearchBarDelegateのメソッドをフック
            .methodInvoked(#selector(UISearchBarDelegate.searchBar(_:shouldChangeTextIn:replacementText:)))
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        // 確定したsearchBar.textを取得
            .flatMap { [unowned self] _ in Observable.just(self.navigationItem.searchController?.searchBar.text ?? "") }
        // UISearchBarのクリア（×）ボタンや確定ボタンタップにテキストを取得するためのObservable
        let textObservable = self.navigationItem.searchController?.searchBar.rx.text.orEmpty.asObservable()
        // 2つのObservableをマージ
        let searchTextObservable = Observable.merge(incrementalSearchTextObservable, textObservable!)
        // 初期化時に空文字が流れてくるので無視
            .skip(1)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        // 変化があるまで文字列が流れないようにする、つまり連続して同じテキストで検索しないようにする。
            .distinctUntilChanged()
        // subscribeして流れてくるテキストを使用して検索
        searchTextObservable
            .subscribe(onNext: { [unowned self] text in
                
                if text.isEmpty {
                    
                    tempTaskModel = self.taskViewModel.tasks.value
                    tempTaskModel.reverse()
                    self.taskViewModel.filteredTask = tempTaskModel
                    updateCollectionView()
                } else {
                    
                    tempTaskModel = self.taskViewModel.tasks.value
                    tempTaskModel.reverse()
                    self.taskViewModel.filteredTask = tempTaskModel.filter { $0.title.contains(text) }
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
        
        bottomView.settingButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                if self?.editingBool == false {
                    self?.editingBool = true
                } else {
                    self?.editingBool = false
                }
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
                
                HUD.show(.progress)
                
                var existingTasks = self.taskViewModel.tasks.value
                existingTasks.append(task.element!)
                self.taskViewModel.saveItems(items: existingTasks, keyName: "taskArray")
                //userdefaultsの処理に時間がかかるため
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                    
                    self.taskViewModel.tasks.accept(existingTasks)
                    self.tempTaskModel = self.taskViewModel.tasks.value
                    self.tempTaskModel.reverse()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
                    
                    self.taskViewModel.filteredTask = self.tempTaskModel
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0){
                    
                    self.middleCollectionView.viewModelCount = self.taskViewModel.filteredTask.count
                    self.updateCollectionView()
                    HUD.hide()
                }
            }.disposed(by: disposeBag)
        
        middleCollectionView.uiCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                
                if self.editingBool == false { return }
                
                HUD.show(.progress)
                
                self.taskViewModel.deleteItem(indexPath: indexPath.row, editing: self.editingBool!)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    
                    self.tempTaskModel = self.taskViewModel.filteredTask
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    
                    self.taskViewModel.saveItems(items: self.tempTaskModel, keyName: "taskArray")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    
                    self.tempTaskModel = self.taskViewModel.readItems(keyName: "taskArray")!
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 9.0) {
                    self.tempTaskModel.reverse()
                    self.taskViewModel.filteredTask = self.tempTaskModel
                    self.middleCollectionView.viewModelCount = self.taskViewModel.filteredTask.count
                    self.updateCollectionView()
                    HUD.hide()
                }
            }).disposed(by: disposeBag)
    }
}






