//
//  InputTextView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/11.
//

import UIKit
import RxSwift

class InputTextView: UIView, UITextFieldDelegate {
    
    let titleLabel = TitleLabel(text: "label", textColor: .black)
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
//        textField.placeholder = "入力欄"
        textField.textAlignment = .center
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .rgb(red: 200, green: 200, blue: 200, alpha: 0.8)
        addSubview(textField)
        
        textField.anchor(
            top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor,
            topPadding: 30, bottomPadding: 30, leftPadding: 30, rightPadding: 30)
        
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textInput() {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
//        print(textField.text!)
        textField.text = ""
        return true
    }
    
    
}
