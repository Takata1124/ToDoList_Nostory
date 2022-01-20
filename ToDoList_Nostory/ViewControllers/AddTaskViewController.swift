//
//  AddTaskViewController.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/17.
//

import UIKit
import RxCocoa
import RxSwift

class AddTaskViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObserver()
    }
    
    let bottomView = BottomView()
    let middleView = MiddleView()
    let topView = TopView()
    let addTaskBottomView = AddTaskBottomView()
    
    let userDefaults = UserDefaults.standard
    var saveArray: Array! = [NSData]()
    
    var taskTitleName: String?
    var taskpngData: NSData?
    var toData: Data?
    
    let centerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.font = UIFont.systemFont(ofSize: 17)
        return textField
    }()
    
    let uiButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        return button
    }()
    
    var AddimageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "富士山")
        return imageView
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    private func setupLayout() {
        
        addTaskBottomView.inputButton.button.isEnabled = false
        
        centerView.addSubview(textField)
        centerView.addSubview(uiButton)
        uiButton.addSubview(AddimageView)
        
        textField.anchor(
            top: centerView.topAnchor, centerX: centerView.centerXAnchor, width: 300, height: 50, topPadding: 50
        )
        uiButton.anchor(
            top: textField.bottomAnchor, centerX: centerView.centerXAnchor, width: 300, height: 400, topPadding: 50
        )
        AddimageView.anchor(
            top: uiButton.topAnchor, bottom: uiButton.bottomAnchor, left: uiButton.leftAnchor, right: uiButton.rightAnchor
        )
        
        textField.delegate = self
        
        self.navigationItem.setTitleView(withTitle: "Add a picture")
        navigationItem.searchController?.searchBar.setSearchTextFieldBackgroundColor(color: .rgb(red: 200, green: 200, blue: 200))
        
        let baseStackView = UIStackView(arrangedSubviews: [topView, centerView, addTaskBottomView])
        baseStackView.axis = .vertical
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(baseStackView)
        
        [topView.heightAnchor.constraint(equalToConstant: 150),
         addTaskBottomView.heightAnchor.constraint(equalToConstant: 150),
         baseStackView.topAnchor.constraint(equalTo: view.topAnchor),
         baseStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         baseStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
         baseStackView.rightAnchor.constraint(equalTo: view.rightAnchor),]
            .forEach { $0.isActive = true }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        if textField.text != "" {
            taskTitleName = textField.text!
            
        } else {
            return true
        }
        
        return true
    }
    
    
    func openImagePicker() {
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    //delegate直下に置かないとNG
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? else {return}
        
        AddimageView.image = selectedImage
        print(selectedImage)
        
        taskpngData = selectedImage.pngData()! as NSData
        toData = Data(referencing: taskpngData!)
        
        addTaskBottomView.inputButton.button.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupBinding() {
        
        addTaskBottomView.dismissButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                print("tapped")
                self?.navigationController?.popViewController(animated: true)
                
            }.disposed(by: disposeBag)
        
        addTaskBottomView.inputButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                let task = Task(title: (self?.taskTitleName!)!, fileData: ((self?.toData)) as! Data )
                
                self?.taskSubject.onNext(task)
                
                self?.navigationController?.popViewController(animated: true)
                //dismiss処理が遅いため、先に処理が行われる。そのため非同期処理を実施
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self?.textField.text = ""
                    self?.AddimageView.image = nil
                }
            }
            .disposed(by: disposeBag)
        
        uiButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                print("tapped")
                self?.openImagePicker()
            }
            .disposed(by: disposeBag)
    }
}
