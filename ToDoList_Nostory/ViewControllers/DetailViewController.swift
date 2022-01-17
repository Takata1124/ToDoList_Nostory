//
//  DetailViewController.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/09.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    let bottomView = BottomView()
    let middleView = MiddleView(cellHight: 150, tableCell: DetailCell.self, cellIdentifier: "cell")
    let topView = TopView()
    
    let detailListViewModel = DetailListViewModel()
    let searchController = setSearchController()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        
        self.navigationItem.setTitleView(withTitle: "Detail")
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
    }
    
    private func setupBinding() {
        
        middleView.tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print(indexPath.row)
                //選択色取り消し
                self.middleView.tableView.deselectRow(at: indexPath, animated: true)
                print("hhhyy")
            })
            .disposed(by: disposeBag)
        
        detailListViewModel.titleArray
            .asDriver()
            .drive(
                middleView.tableView.rx.items(cellIdentifier: "cell", cellType: DetailCell.self)
            ) { (row, model, cell) in
                // cellの描画処理
                print(model)
                cell.detailText.text = model.detailName
            }
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
