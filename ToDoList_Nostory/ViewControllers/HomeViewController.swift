//
//  ViewController.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var tasks = BehaviorRelay<[Task]>(value: [
//        Task(title: "name", fileData: nil),
//        Task(title: "string", fileData: nil)
    ])
    
    //UIViewで型を指定するとエラーになる
    let bottomView = BottomView()
    let middleView = MiddleView()
    let topView = TopView()
    let collectionView = CollectionView()
    let middleCollectionView = MiddleCollectionView()
    
    var inputTextView = InputTextView()
    var backView = UIView()
    
    let detailViewController = DetailViewController()
    let timelineViewController = TimelineViewController()
    let searchController = setSearchController()
    let addTaskViewController = AddTaskViewController()
    
    let listViewModel = ListViewModel()
    let userListViewModel = UserListViewModel()
    
    let collectionTableViewCell = CollectionTableViewCell()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .rgb(red: 200, green: 200, blue: 200, alpha: 1)
        
        self.navigationItem.setTitleView(withTitle: "Home")
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.setSearchTextFieldBackgroundColor(color: .rgb(red: 200, green: 200, blue: 200))
        
        let baseStackView = UIStackView(arrangedSubviews: [topView, middleCollectionView, bottomView])
        baseStackView.axis = .vertical
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(baseStackView)
        
        [topView.heightAnchor.constraint(equalToConstant: 150),
         bottomView.heightAnchor.constraint(equalToConstant: 125),
         //         middleView.heightAnchor.constraint(equalToConstant: 150),
         
         baseStackView.topAnchor.constraint(equalTo: view.topAnchor),
         baseStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         baseStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
         baseStackView.rightAnchor.constraint(equalTo: view.rightAnchor),]
            .forEach { $0.isActive = true }
        
        backView = .init(frame: CGRect(x: 0, y: 150, width: self.view.frame.width, height: 622))
        backView.backgroundColor = .rgb(red: 0, green: 0, blue: 0, alpha: 0.7)
        backView.isHidden = true
        baseStackView.addSubview(backView)
        
        inputTextView = .init(frame: CGRect(x: self.view.frame.width/2 - 200, y: self.view.frame.height/2 - 100, width: 400, height: 125))
        inputTextView.layer.cornerRadius = 20
        inputTextView.isHidden = true
        baseStackView.addSubview(inputTextView)
        
        middleCollectionView.uiCollectionView.delegate = self
        middleCollectionView.uiCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCollectionViewCell", for: indexPath) as! TileCollectionViewCell
        
        //配列を逆にする
        let totalCount = tasks.value.count - 1
        var cellCount = totalCount - indexPath.item
        
        cell.label.text = tasks.value[cellCount].title
        cell.imageView.image = UIImage(data: tasks.value[cellCount].fileData! as Data)
        
        return cell
        
    }
    
    private func setupBindings() {
        
        middleCollectionView.uiCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print(indexPath.item)
                
                let totalCount = self.tasks.value.count - 1
                var cellCount = totalCount - indexPath.item
                
                self.detailViewController.homeTitle = self.tasks.value[cellCount].title
                self.navigationController?.pushViewController(self.detailViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        
        bottomView.settingButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                //                self.middleView.tableView.deselectRow(at: indexPath, animated: true)
//                self?.navigationController?.pushViewController(self!.timelineViewController, animated: true)
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
        
        inputTextView.textField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .compactMap {[unowned self] in inputTextView.textField.text}
            .drive(onNext: { text in
                
                self.inputTextView.isHidden = true
                self.backView.isHidden = true
                
                if text != "" {
                    
                    print(text)
                }
                else { return }
                
                
            })
            .disposed(by: disposeBag)
        
        addTaskViewController.taskSubjectObservable
            .subscribe { task in
                
                var existingTasks = self.tasks.value
                //optional型をアンラップ
                existingTasks.append(task.element!)
                
                self.tasks.accept(existingTasks)
//                self.middleView.tableView.reloadData()
                self.middleCollectionView.uiCollectionView.reloadData()
                
            }.disposed(by: disposeBag)
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //ここでは画面の横サイズの半分の大きさのcellサイズを指定
        return CGSize(width: screenSize.width / 1.4 , height: screenSize.height / 1.8)
    }
}




