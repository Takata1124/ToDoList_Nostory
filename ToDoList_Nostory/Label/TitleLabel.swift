//
//  TitleLabel.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/09.
//

import UIKit

class TitleLabel: UILabel {
    
    init(text: String, textColor: UIColor) {
        super.init(frame: .zero)
        
        font = .boldSystemFont(ofSize: 25)
        self.text = text
        self.textColor = textColor
        
//        layer.borderWidth = 3
//        layer.borderColor = textColor.cgColor
//        layer.cornerRadius = 10
        
        textAlignment = .center
        alpha = 1
    }
    
//    init(text: String, font: UIFont) {
//        super.init(frame: .zero)
//        self.font = font
//        textColor = .white
//        self.text = text
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
