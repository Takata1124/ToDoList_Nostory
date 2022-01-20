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
       
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .yellow
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = subTitile
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical

        self.titleView = stackView
        //        self.leftBarButtonItem = addBtn
        
    }
    
   
}
