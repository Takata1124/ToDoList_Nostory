//
//  DetailCell.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/13.
//

import UIKit
import SnapKit

class DetailCell: UITableViewCell {
    
    let detailText: UITextField = {
        let textFiled = UITextField()
        textFiled.textColor = .black
        textFiled.backgroundColor = .clear
        textFiled.textAlignment = .left
                textFiled.layer.borderWidth = 1.0
                textFiled.layer.borderColor = UIColor.black.cgColor
        //        textFiled.layer.cornerRadius = 20
        //        textFiled.layer.shadowOffset = .init(width: 2, height: 4)
        //        textFiled.layer.shadowColor = UIColor.black.cgColor
        //        textFiled.layer.shadowOpacity = 0.3
        //        textFiled.layer.shadowRadius = 50
        textFiled.isEnabled = false
        return textFiled
    }()
    
    let boxView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 30
        view.layer.shadowOffset = .init(width: 2, height: 4)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 50
//        view.backgroundColor = .lightGray
        return view
    }()
    
    let roundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 15
        return view
    }()
    
    let uiBox: UIView = {
        let uiView = UIView()
        
        return uiView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
          
        setupView()
    }
    
    private func setupView() {
        
        boxView.addSubview(roundView)
        roundView.anchor(left: boxView.leftAnchor, centerY: boxView.centerYAnchor, width: 30, height: 30, leftPadding: 20)
        
        boxView.addSubview(detailText)
        detailText.anchor(right: boxView.rightAnchor, centerY: boxView.centerYAnchor, width: 265, height: 90, rightPadding: 20)
        
        uiBox.addSubview(boxView)
        boxView.anchor(centerY: uiBox.centerYAnchor, centerX: uiBox.centerXAnchor, width: 350, height: 125)
        
        self.contentView.addSubview(uiBox)
        uiBox.snp.makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(self.contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
