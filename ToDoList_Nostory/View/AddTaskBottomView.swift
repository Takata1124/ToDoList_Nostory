//
//  AddTaskBottomView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/18.
//

import UIKit

class AddTaskBottomView: UIView {
    
    let dismissButton = BottomButtonView(width: 70, imageName: "plus")
    
    init() {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        backgroundColor = .rgb(red: 51, green: 51, blue: 102, alpha: 0.8)
        
        let baseStackView = UIStackView(arrangedSubviews: [dismissButton])
        baseStackView.axis = .horizontal
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 10
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(baseStackView)
        //
        [baseStackView.topAnchor.constraint(equalTo: topAnchor),
         baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
         baseStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
         baseStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
        ].forEach { $0.isActive = true }
    } 
}

