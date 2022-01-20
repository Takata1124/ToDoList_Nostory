//
//  ViewController.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //UIViewで型を指定するとエラーになる
    let bottomView = BottomView()
    let middleView = MiddleView()
    let topView = TopView()
    let middleCollectionView = MiddleCollectionView()
    
    var backView = UIView()
    
    let detailViewController = DetailViewController()
    let searchController = setSearchController()
    let addTaskViewController = AddTaskViewController()
    
    let taskViewModel = TaskViewModel()
    
    let userDefaults = UserDefaults.standard
    
    private let disposeBag = DisposeBag()
    
    //ビルド時のみロード
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .rgb(red: 200, green: 200, blue: 200, alpha: 1)
        
        self.navigationItem.setTitleView(withTitle: "Art Museum")
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.setSearchTextFieldBackgroundColor(color: .rgb(red: 200, green: 200, blue: 200))
        
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
        
        backView = .init(frame: CGRect(x: 0, y: 150, width: self.view.frame.width, height: 622))
        backView.backgroundColor = .rgb(red: 0, green: 0, blue: 0, alpha: 0.7)
        backView.isHidden = true
        baseStackView.addSubview(backView)
        
        middleCollectionView.uiCollectionView.delegate = self
        middleCollectionView.uiCollectionView.dataSource = self
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskViewModel.tasks.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCollectionViewCell", for: indexPath) as! TileCollectionViewCell
        
        cell.label.text = taskViewModel.tasks.value[indexPath.item].title
        cell.imageView.image = UIImage(data: taskViewModel.tasks.value[indexPath.row].fileData as Data)
        
        return cell
        
    }
    
    private func setupBindings() {
        
        middleCollectionView.uiCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print(indexPath.item)
                //                self.detailViewController.homeTitle = self.tasks.value[cellCount].title
                //                self.navigationController?.pushViewController(self.detailViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        
        bottomView.settingButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                //                                self.middleView.tableView.deselectRow(at: indexPath, animated: true)
                self?.navigationController?.pushViewController(self!.detailViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        bottomView.plusButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                self?.addTaskViewController.modalPresentationStyle = .fullScreen
                self?.present(self!.addTaskViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        bottomView.searchButton.button.rx.tap
            .asDriver()
            .drive { _ in
                print("search")
                self.searchController.textInput()
            }
            .disposed(by: disposeBag)
        
        addTaskViewController.taskSubjectObservable
            .subscribe { task in
                
                var existingTasks = self.taskViewModel.tasks.value
                //optional型をアンラップ
                existingTasks.append(task.element!)
                print(existingTasks[0].title)
                self.taskViewModel.saveItems(items: existingTasks, keyName: "taskArray")
                
                existingTasks.reverse()
                self.taskViewModel.tasks.accept(existingTasks)
                
                
                self.middleCollectionView.uiCollectionView.reloadData()
                
            }.disposed(by: disposeBag)
        
    }
}






