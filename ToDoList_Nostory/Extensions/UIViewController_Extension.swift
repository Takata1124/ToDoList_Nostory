//
//  UIViewController_Extension.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/19.
//

import UIKit

let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //ここでは画面の横サイズの半分の大きさのcellサイズを指定
        return CGSize(width: screenSize.height / 1.7 / 4 * 3 , height: screenSize.height / 1.7)
    }
}
