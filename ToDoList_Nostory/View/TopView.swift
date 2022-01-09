//
//  TopView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/09.
//

import UIKit

class TopView: UIView {
    
    let titleLabel = TitleLabel(text: "label", textColor: .black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .rgb(red: 200, green: 200, blue: 200)
        addSubview(titleLabel)
        
        titleLabel.anchor(bottom: bottomAnchor, centerX: centerXAnchor, bottomPadding: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}