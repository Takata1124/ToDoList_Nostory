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
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        
        let baseStackView = UIStackView(arrangedSubviews: [topView, middleView, bottomView])
        baseStackView.axis = .vertical
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(baseStackView)
        
        [topView.heightAnchor.constraint(equalToConstant: 100),
         bottomView.heightAnchor.constraint(equalToConstant: 150),
         
         baseStackView.topAnchor.constraint(equalTo: view.topAnchor),
         baseStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         baseStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
         baseStackView.rightAnchor.constraint(equalTo: view.rightAnchor),].forEach { $0.isActive = true }
    }
    
    private func setupBindings() {
        
        bottomView.searchButton.button?.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                let detailViewController = DetailViewController()
                detailViewController.modalPresentationStyle = .fullScreen
                self?.present(detailViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}
