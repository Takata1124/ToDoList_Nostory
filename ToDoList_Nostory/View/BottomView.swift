//
//  TopView.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa

class BottomView: UIView {
    
    let plusButton = BottomButtonView(width: 70, imageName: "plus")
    let uiButton_2 = BottomButtonView(width: 70, title: "New")
    let uiButton_3 = BottomButtonView(width: 70, imageName: "bell")
    let searchButton = BottomButtonView(width: 70, imageName: "gearshape")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        backgroundColor = .rgb(red: 51, green: 51, blue: 102, alpha: 0.8)
        
        let baseStackView = UIStackView(arrangedSubviews: [plusButton, uiButton_2, uiButton_3, searchButton])
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
    
    private func setupBindings() {
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BottomButtonView: UIView {
    
    var button: BottomButton?
    
    init(width: CGFloat, imageName: String = "", title: String = "") {
        super.init(frame: .zero)
        
        button = BottomButton(type: .custom)
        button?.setImage(UIImage(systemName: imageName)?.resize(size: .init(width: width * 0.4, height: width * 0.4)), for: .normal)
        button?.setTitle(title, for: .normal)
        button?.setTitleColor(UIColor.black, for: .normal)
        button?.translatesAutoresizingMaskIntoConstraints = false
        button?.backgroundColor = .white
        button?.layer.cornerRadius = width / 2
        button?.layer.shadowOffset = .init(width: 1.5, height: 2)
        button?.layer.shadowColor = UIColor.black.cgColor
        button?.layer.shadowOpacity = 0.3
        button?.layer.shadowRadius = 15
        
        addSubview(button!)
        
        button?.anchor(centerY: centerYAnchor, centerX: centerXAnchor, width: width, height: width)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BottomButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
                    
                    self.transform = .init(scaleX: 0.8, y: 0.8)
                    self.layoutIfNeeded()
                }
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
                    
                    self.transform = .identity
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
