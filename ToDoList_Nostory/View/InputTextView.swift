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
    
    let maxLength: Int = 10
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.placeholder = "＋Input"
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.font = UIFont.systemFont(ofSize: 17)
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(textField)
        
        textField.anchor(
            top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor,
            topPadding: 30, bottomPadding: 30, leftPadding: 30, rightPadding: 30)
        
        textField.backgroundColor = .rgb(red: 200, green: 200, blue: 200, alpha: 1)
        textField.delegate = self
    }
    
    func textInput() {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        print("hhhh")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // キーボードを閉じる
        textField.resignFirstResponder()
//        print(textField.text!)
        textField.text = ""
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
