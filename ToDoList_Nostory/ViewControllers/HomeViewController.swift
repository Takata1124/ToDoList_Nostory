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

class HomeViewController: UIViewController {
    
    //UIViewで型を指定するとエラーになる
    let bottomView = BottomView()
    let middleView = MiddleView()
    let topView = TopView()
    let collectionView = CollectionView()
    
    var inputTextView = InputTextView()
    var backView = UIView()
    
    let detailViewController = DetailViewController()
    let timelineViewController = TimelineViewController()
    let searchController = setSearchController()
    
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
        
        backView = .init(frame: CGRect(x: 0, y: 150, width: self.view.frame.width, height: 622))
        backView.backgroundColor = .rgb(red: 0, green: 0, blue: 0, alpha: 0.7)
        backView.isHidden = true
        baseStackView.addSubview(backView)
        
        inputTextView = .init(frame: CGRect(x: self.view.frame.width/2 - 200, y: self.view.frame.height/2 - 100, width: 400, height: 125))
        inputTextView.layer.cornerRadius = 20
        inputTextView.isHidden = true
        baseStackView.addSubview(inputTextView)
    }
    
    private func setupBindings() {
        
//        middleView.tableView.rx.itemSelected
//            .subscribe(onNext: { indexPath in
//                print(indexPath.row)
//                self.middleView.tableView.deselectRow(at: indexPath, animated: true)
//                self.navigationController?.pushViewController(self.detailViewController, animated: true)
//            })
//            .disposed(by: disposeBag)

        
        bottomView.settingButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                //                self.middleView.tableView.deselectRow(at: indexPath, animated: true)
                self?.navigationController?.pushViewController(self!.timelineViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        bottomView.plusButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                print("tap")
                self?.backView.isHidden = false
                self?.inputTextView.isHidden = false
                self?.inputTextView.textInput()
            }
            .disposed(by: disposeBag)
        
        bottomView.searchButton.button.rx.tap
            .asDriver()
            .drive { _ in
                print("search")
                self.searchController.textInput()
            }
            .disposed(by: disposeBag)
        
        //下記内容はviewControllerでないと処理が走らない
//        listViewModel.titleArray
//            .asDriver()
//            .drive(
//                middleView.tableView.rx.items(cellIdentifier: "homeCell", cellType: TaskCell.self)
//            ) { (row, model, cell) in
//                // cellの描画処理
////                cell.nameLabel.text = model.taskName
//                cell.nameLabel.text = "hello"
//            }
//            .disposed(by: disposeBag)
//        
//        listViewModel.titleArray.bind(
//            to: middleView.tableView.rx.items(
//                cellIdentifier: "cell", cellType: UITableViewCell.self)
//        ){ row, item, cell in
//            cell.textLabel?.text = item.taskName
//            
//        }.disposed(by: disposeBag)
        
//        let tileCollectionViewCell = TileCollectionViewCell()
        
//        userListViewModel.users
//            .asDriver()
//            .drive(
//                collectionTableViewCell.collectionView.rx.items(
//                    cellIdentifier: "TileCollectionViewCell",
//                    cellType: TileCollectionViewCell.self
//                )
//            ) { (row, model, cell) in
//                cell.label.text = model.name
//            }
//            .disposed(by: disposeBag)
        
        inputTextView.textField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .compactMap {[unowned self] in inputTextView.textField.text}
            .drive(onNext: { text in
                
                //                let collectionTableViewCellViewModel = CollectionTableViewCellViewModel()
                //                let collectionTableViewCell = CollectionTableViewCell()
                
                //                print("editingDidEnd")
                self.inputTextView.isHidden = true
                self.backView.isHidden = true
                
                if text != "" {
                    //                    collectionTableViewCellViewModel.TextAppend(element: TileCollectionViewCellViewModel(name: text))
                    //                    self.collectionTableViewCell.TextAppend(text)
                    print(text)
                }
                else { return }
                
            
            })
            .disposed(by: disposeBag)
    }
}


