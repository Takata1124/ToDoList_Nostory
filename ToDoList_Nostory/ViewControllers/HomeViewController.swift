//
//  ViewController.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    //UIViewで型を指定するとエラーになる
    let bottomView = BottomView()
    let middleView = MiddleView()
    let topView = TopView()
    //inputViewはエラー
    let inputTextView = InputTextView()
    
    let detailViewController = DetailViewController()
    
    let listViewModel = ListViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        
        self.navigationItem.setTitleView(withTitle: "Home")
        
        let baseStackView = UIStackView(arrangedSubviews: [topView, inputTextView, middleView, bottomView])
        baseStackView.axis = .vertical
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(baseStackView)
        
        [topView.heightAnchor.constraint(equalToConstant: 100),
         inputTextView.heightAnchor.constraint(equalToConstant: 100),
         bottomView.heightAnchor.constraint(equalToConstant: 125),
         
         baseStackView.topAnchor.constraint(equalTo: view.topAnchor),
         baseStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         baseStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
         baseStackView.rightAnchor.constraint(equalTo: view.rightAnchor),]
        .forEach { $0.isActive = true }
    }
    
    private func setupBindings() {
        
        middleView.tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print(indexPath.row)
                
                self.detailViewController.modalPresentationStyle = .fullScreen
                self.present(self.detailViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        bottomView.settingButton.button?.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                self?.detailViewController.modalPresentationStyle = .fullScreen
                self?.present(self!.detailViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        bottomView.plusButton.button?.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.inputTextView.textInput()
            }
            .disposed(by: disposeBag)
        
        bottomView.searchButton.button?.rx.tap
            .asDriver()
            .drive { _ in
                print("search")
            }
            .disposed(by: disposeBag)
        
        //viewControllerでないと処理が走らない
        listViewModel.titleArray
            .asDriver()
            .drive(
            middleView.tableView.rx.items(cellIdentifier: "cell", cellType: TaskCell.self)
            ) { (row, model, cell) in
                // cellの描画処理
                cell.nameLabel.text = model.taskName
            }
            .disposed(by: disposeBag)
        
        inputTextView.textField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .compactMap {[unowned self] in inputTextView.textField.text}
            .drive(onNext: { text in
                // キーボードが閉じた時に処理が走る
                print("editingDidEnd")
                if text != "" { self.listViewModel.append(ListModel(taskName: text)) } else { return }
            })
            .disposed(by: disposeBag)
    }
}


