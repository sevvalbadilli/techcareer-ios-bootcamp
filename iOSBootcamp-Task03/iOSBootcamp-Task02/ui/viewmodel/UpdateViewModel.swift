//
//  UpdateViewModel.swift
//  iOSBootcamp-Task02
//
//  Created by ŞEVVAL on 24.04.2025.
//

import Foundation

class UpdateViewModel{
    
    var todoRepository = ToDoRepository.shared
        
        func guncelle(id: Int, yeniText: String) {
            todoRepository.guncelle(id: id, yeniText: yeniText)
        }
    
}
