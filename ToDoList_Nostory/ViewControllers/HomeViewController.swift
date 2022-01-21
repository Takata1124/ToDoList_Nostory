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
    
    let userDefaults = UserDefaults.standard
    //UIViewで型を指定するとエラーになる
    let bottomView = BottomView()
    let middleView = MiddleView()
    let topView = TopView()
    
    let middleCollectionView = MiddleCollectionView()
    let searchController = UISearchController()
    let addTaskViewController = AddTaskViewController()
    
    let taskViewModel = TaskViewModel()
    
    var tempTaskModel: [Task] = []
    
    var editingBool: Bool? {
        
        didSet {
            if editingBool == false {
                
                middleCollectionView.deleteImage.isHidden = true
            } else {
                
                middleCollectionView.deleteImage.isHidden = false
            }
        }
    }
    
    var editMode: Bool? {
        
        didSet {
            if editMode == false {
                
                self.navigationController?.navigationBar.tintColor = .white
            } else {
                
                self.navigationController?.navigationBar.tintColor = .yellow
            }
        }
    }
    
    var tappedButtonBool: Bool?
    
    private let disposeBag = DisposeBag()
    
    var editButton = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(editBarButtonTapped(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
        setupSearchbar()
    }
    
    private func setupLayout() {
        
        navigationItem.rightBarButtonItem = editButton
        
        editingBool = false
        editMode = false
        tappedButtonBool = false
        
        self.navigationItem.setTitleView(withTitle: "Art Gallery")
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.setSearchTextFieldBackgroundColor(color: .rgb(red: 200, green: 200, blue: 200))
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchBar.tintColor = .yellow
        self.navigationController?.navigationBar.tintColor = .white
        
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
            .methodInvoked(#selector(UISearchBarDelegate.searchBar(_:shouldChangeTextIn:replacementText:)))
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMap { [unowned self] _ in Observable.just(self.navigationItem.searchController?.searchBar.text ?? "") }
        let textObservable = self.navigationItem.searchController?.searchBar.rx.text.orEmpty.asObservable()
        let searchTextObservable = Observable.merge(incrementalSearchTextObservable, textObservable!)
        // 初期化時に空文字が流れてくるので無視
            .skip(1)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        // 変化があるまで文字列が流れないようにする、つまり連続して同じテキストで検索しないようにする。
            .distinctUntilChanged()
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
        cell.labelBool = taskViewModel.filteredTask[indexPath.row].tapbutton
        cell.dateLabel.text = taskViewModel.filteredTask[indexPath.row].today
        return cell
    }
    
    func textInput() {
        
        navigationItem.searchController?.searchBar.textField?.becomeFirstResponder()
    }
    
    private func filterTask() {
        
        taskViewModel.tasks
            .subscribe { _ in
                self.tempTaskModel = self.taskViewModel.tasks.value
                self.tempTaskModel.reverse()
                self.taskViewModel.filteredTask = self.tempTaskModel.filter { $0.tapbutton == true }
                self.middleCollectionView.viewModelCount = self.taskViewModel.filteredTask.count
                self.updateCollectionView()
            }
            .disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        
        editButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                if self?.editMode == false {
                    
                    self?.editMode = true
                } else {
                    self?.editMode = false
                    self?.editingBool = false
                    self?.tappedButtonBool = false
                    self?.buttonCollerReset()
                }
            }
            .disposed(by: disposeBag)
        
        bottomView.deleteButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                if self?.editMode == false { return }
                if self?.editingBool == false { self?.editingBool = true } else { self?.editingBool = false }
                self?.handleSelectedButton(selectedButton: (self?.bottomView.deleteButton)!)
                if self?.tappedButtonBool == false { self?.tappedButtonBool = true } else { self?.tappedButtonBool = false }
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
        
        bottomView.starButton.button.rx.tap
            .asDriver()
            .drive { _ in
                
                self.handleSelectedButton(selectedButton: self.bottomView.starButton)
                if self.tappedButtonBool == false { self.tappedButtonBool = true } else { self.tappedButtonBool = false }
            }
            .disposed(by: disposeBag)
        
        addTaskViewController.taskSubjectObservable
            .subscribe { task in
                
                HUD.show(.progress)
                
                var existingTasks = self.taskViewModel.tasks.value
                existingTasks.append(task.element!)
                self.taskViewModel.saveItems(items: existingTasks, keyName: "taskArray")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                    
                    self.taskViewModel.tasks.accept(existingTasks)
                    self.tempTaskModel = self.taskViewModel.tasks.value
                    self.tempTaskModel.reverse()
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
                
                if self.editMode == false { return }
                
                if self.editingBool == true {
                    
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
                } else {
                    
                    HUD.show(.progress)
                    
                    let tempTask = self.taskViewModel.filteredTask[indexPath.row]
                    var tapBool = self.taskViewModel.filteredTask[indexPath.row].tapbutton
                    if tapBool == true { tapBool = false } else { tapBool = true }
                    
                    let newTask = Task(title: tempTask.title, fileData: tempTask.fileData, today: tempTask.today, tapbutton: tapBool)
                    
                    self.tempTaskModel = self.taskViewModel.filteredTask
                    self.tempTaskModel[indexPath.row] = newTask
                    self.tempTaskModel.reverse()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                        self.taskViewModel.saveItems(items: self.tempTaskModel, keyName: "taskArray")
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                        
                        self.tempTaskModel.reverse()
                        self.taskViewModel.filteredTask = self.tempTaskModel
                        self.updateCollectionView()
                        HUD.hide()
                    }
                }
                
            }).disposed(by: disposeBag)
    }
    
    private func buttonCollerReset() {
        
        let Allbuttons = [
            bottomView.plusButton, bottomView.searchButton, bottomView.starButton, bottomView.deleteButton]
        
        Allbuttons.forEach { button in
            button.button.backgroundColor = .rgb(red: 200, green: 200, blue: 200)
            button.button.isEnabled = true
        }
    }
    
    private func handleSelectedButton(selectedButton: UIView) {
        
        let Allbuttons = [
            bottomView.plusButton, bottomView.searchButton, bottomView.starButton, bottomView.deleteButton]
        
        if tappedButtonBool == false {
            
            Allbuttons.forEach { button in
                if button == selectedButton {
                    button.button.isEnabled = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        if button == self.bottomView.starButton {
                            button.button.backgroundColor = .yellow
                            self.filterTask()
                        } else {
                            button.button.backgroundColor = .red
                        }
                    }
                } else {
                    button.button.isEnabled = false
                }
                navigationItem.searchController?.searchBar.textField?.isEnabled = false
            }
        } else {
            
            Allbuttons.forEach { button in
                button.button.isEnabled = true
            }
            navigationItem.searchController?.searchBar.textField?.isEnabled = true
            
            self.tempTaskModel = self.taskViewModel.tasks.value
            self.tempTaskModel.reverse()
            self.taskViewModel.filteredTask = self.tempTaskModel
            //時間差でセレクト後に色を変化させる
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.buttonCollerReset()
                self.updateCollectionView()
                self.middleCollectionView.viewModelCount = self.taskViewModel.filteredTask.count
            }
        }
    }
    //反応なし
    @objc func editBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
}






