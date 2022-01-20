//
//  serSearchController.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/13.
//

import UIKit
import RxSwift
import RxCocoa

class setSearchController: UISearchController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.tintColor = .black
        
        
    }
    
    func textInput() {
        searchBar.textField?.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        //        view.endEditing(true)
        // 入力された値がnilでなければif文のブロック内の処理を実行
        if let word = searchBar.text {
            print(word)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.textField?.text = ""
    }
    
    func setupSearchBar() {
        
        
    }
    
   
}
