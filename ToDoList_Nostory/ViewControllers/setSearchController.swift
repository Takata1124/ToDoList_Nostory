//
//  serSearchController.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/13.
//

import UIKit

class setSearchController: UISearchController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        searchBar.setSearchTextFieldBackgroundColor(color: .rgb(red: 200, green: 200, blue: 200))
        searchBar.delegate = self
        searchBar.tintColor = .black
//        searchBar.textField?.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textInput() {
        searchBar.textField?.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
//        view.endEditing(true)
        // 入力された値がnilでなければif文のブロック内の処理を実行
        if let word = searchBar.text {
            // デバッグエリアに出力
            print(word)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.textField?.text = ""
    }
}
