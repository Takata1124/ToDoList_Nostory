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
        textAlignment = .center
        alpha = 1
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
