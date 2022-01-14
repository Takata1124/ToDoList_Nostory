//
//  UISearchBar_Extension.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/13.
//

import UIKit

extension UISearchBar {

    var textField: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
    
    func setSearchTextFieldBackgroundColor(color: UIColor) {
        guard let textField = textField else {
            return
        }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default:
            textField.backgroundColor = color
        @unknown default:
            break
        }
    }
}
