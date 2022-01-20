//
//  TopView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/08.
//

import UIKit

class BottomView: UIView {
    
    let plusButton = BottomButtonView(width: 70, imageName: "plus")
    let newButton = BottomButtonView(width: 70, imageName: "magnifyingglass")
    var searchButton = BottomButtonView(width: 70, imageName: "star")
    let settingButton = BottomButtonView(width: 70, imageName: "trash")
    
    init() {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        backgroundColor = .rgb(red: 51, green: 51, blue: 102, alpha: 0.8)
        
        let baseStackView = UIStackView(arrangedSubviews: [plusButton, newButton, searchButton, settingButton])
        baseStackView.axis = .horizontal
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 10
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(baseStackView)
        
        [baseStackView.topAnchor.constraint(equalTo: topAnchor),
         baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
         baseStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
         baseStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
        ].forEach { $0.isActive = true }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
