//
//  BottomButton.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/14.
//

import UIKit

class BottomButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
                    
                    self.backgroundColor = .rgb(red: 200, green: 200, blue: 200, alpha: 1)
                    self.transform = .init(scaleX: 0.8, y: 0.8)
                    self.layoutIfNeeded()
                }
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
                    
                    self.backgroundColor = .rgb(red: 200, green: 200, blue: 200, alpha: 1)
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
