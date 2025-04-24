//
//  AddViewModel.swift
//  iOSBootcamp-Task02
//
//  Created by ŞEVVAL on 24.04.2025.
//

import Foundation

class AddViewModel{
    
    var todoRepository = ToDoRepository.shared
       
       func kaydet(todo: String) {
           todoRepository.ekle(todo: todo)
       }
    
}
