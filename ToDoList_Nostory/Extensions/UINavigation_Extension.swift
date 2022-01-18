//
//  UINavigation_Extension.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/11.
//

import UIKit

extension UINavigationItem {
    
    func setTitleView(withTitle title: String, subTitile: String = "", action: Selector = "") {
        
//        var addBtn: UIBarButtonItem!
//        var addBtn_2: UIBarButtonItem!

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white

        let subTitleLabel = UILabel()
        subTitleLabel.text = subTitile
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.textColor = .gray

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical
        
        //イニシャライズ後ボタンのプロパティを入力しなければエラー
//        addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: action)
//        addBtn_2 = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: action)

        self.titleView = stackView
//        self.leftBarButtonItem = addBtn
//        self.rightBarButtonItem = addBtn_2
        self.rightBarButtonItem?.tintColor = .black
    }
}
