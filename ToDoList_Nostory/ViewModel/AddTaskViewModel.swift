//
//  AddTaskViewModel.swift
//  ToDoList_Nostory
//
//  Created by t032fj on 2022/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class AddTaskViewModel {
    
    private let disposeBag = DisposeBag()
    
    var titleTextOutput = PublishSubject<String>()
    var validRegisterSubject = BehaviorSubject<Bool>(value: false)
    
    var titleTextInput: AnyObserver<String> {
        titleTextOutput.asObserver()
    }
    
    var pictureOutput = BehaviorSubject(value: false)
    var pictureInput: Observable<Bool> { return pictureOutput }
    
    var validRegisterDriver: Driver<Bool> = Driver.never()
    
    init() {
        
        validRegisterDriver = validRegisterSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let titleValid = titleTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 1
            }
        
        let pictureValid = pictureInput
        
        Observable.combineLatest(titleValid, pictureValid){ $0 && $1 }
        .subscribe { validAll in
            self.validRegisterSubject.onNext(validAll)
        }.disposed(by: disposeBag)
    }
    
}
