//
//  UINavigation_Extension.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/11.
//

import UIKit

extension UINavigationItem {

    func setTitleView(withTitle title: String, subTitile: String = "", action: Selector = "") {
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .yellow
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical

        self.titleView = stackView
    }
}
