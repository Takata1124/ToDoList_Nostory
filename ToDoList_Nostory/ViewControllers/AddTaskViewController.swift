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
    
    var taskSubjectObservable: Observable<Task> { return taskSubject.asObserver() }
    
    let bottomView = BottomView()
    let topView = TopView()
    let addTaskBottomView = AddTaskBottomView()
    
    let addTaskViewModel = AddTaskViewModel()
    
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
        textField.placeholder = "15文字まで"
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
        return imageView
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    private func setupLayout() {
        
        //ロード時に追加ボタンをfalse
        addTaskBottomView.inputButton.button.isEnabled = false
        
        centerView.addSubview(textField)
        centerView.addSubview(uiButton)
        uiButton.addSubview(AddimageView)
        
        let textFieldHeight = screenSize.height / 2
        
        textField.anchor(
            top: centerView.topAnchor, centerX: centerView.centerXAnchor, width: textFieldHeight / 4 * 3, height: 50, topPadding: 20
        )
        uiButton.anchor(
            top: textField.bottomAnchor, centerX: centerView.centerXAnchor, width: textFieldHeight / 4 * 3, height: textFieldHeight, topPadding: 20
        )
        AddimageView.anchor(
            top: uiButton.topAnchor, bottom: uiButton.bottomAnchor, left: uiButton.leftAnchor, right: uiButton.rightAnchor
        )
        
        textField.delegate = self
        
        self.navigationItem.setTitleView(withTitle: "Add a picture")
        navigationItem.searchController?.searchBar.setSearchTextFieldBackgroundColor(color: .rgb(red: 200, green: 200, blue: 200))
        self.navigationController?.navigationBar.tintColor = .yellow
        
        let baseStackView = UIStackView(arrangedSubviews: [topView, centerView, addTaskBottomView])
        baseStackView.axis = .vertical
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(baseStackView)
        
        [topView.heightAnchor.constraint(equalToConstant: 150),
         addTaskBottomView.heightAnchor.constraint(equalToConstant: 125),
         baseStackView.topAnchor.constraint(equalTo: view.topAnchor),
         baseStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         baseStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
         baseStackView.rightAnchor.constraint(equalTo: view.rightAnchor),]
            .forEach { $0.isActive = true }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        if textField.text != "" { taskTitleName = textField.text! } else { return true }
        
        return true
    }
    
    func openImagePicker() {
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? else {return}
        
        AddimageView.image = selectedImage
        taskpngData = selectedImage.pngData()! as NSData
        toData = Data(referencing: taskpngData!)
        
        addTaskViewModel.pictureOutput.onNext(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //今日の日付を取得
    func makindDate() -> String{
        
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()
        let datedate = f.string(from: now)
        return datedate
    }
    
    private func setupBinding() {
        
        textField.rx.text
            .asDriver()
            .drive { text in
                self.addTaskViewModel.titleTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        textField.rx.text
            .map { text in
                if let text = text, text.count > 15 {
                    return String(text.prefix(15))
                } else {
                    return text ?? ""
                }
            }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        
        addTaskBottomView.dismissButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
                
            }.disposed(by: disposeBag)
        
        addTaskBottomView.inputButton.button.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                let todayTime: String = (self?.makindDate())!
                let task = Task(
                    title: (self?.taskTitleName!)!, fileData: ((self?.toData)) as! Data, today: todayTime, tapbutton: false)
                self?.taskSubject.onNext(task)
                self?.navigationController?.popViewController(animated: true)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.textField.text = ""
                    self?.AddimageView.image = nil
                }
            }
            .disposed(by: disposeBag)
        
        uiButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                self?.openImagePicker()
            }
            .disposed(by: disposeBag)
        
        addTaskViewModel.validRegisterDriver
            .drive { validAll in
                
                self.addTaskBottomView.inputButton.button.isEnabled = validAll
            }
            .disposed(by: disposeBag)
    }
}
