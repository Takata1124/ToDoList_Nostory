//
//  BottomButtonView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/14.
//

import UIKit

class BottomButtonView: UIView {
    
//    var buttonColor: UIColor? {
//        didSet {
//            button.backgroundColor = buttonColor
//        }
//    }
    
    var button: UIButton = {
        let button = BottomButton(type: .custom)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .rgb(red: 200, green: 200, blue: 200)
        button.layer.shadowOffset = .init(width: 1.5, height: 2)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 15
        return button
    }()
    
    init(width: CGFloat, imageName: String = "", title: String = "") {
        super.init(frame: .zero)
        
        button.setImage(UIImage(systemName: imageName)?.resize(size: .init(width: width * 0.4, height: width * 0.4)), for: .normal)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = width / 2
        
        addSubview(button)
        button.anchor(centerY: centerYAnchor, centerX: centerXAnchor, width: width, height: width)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
