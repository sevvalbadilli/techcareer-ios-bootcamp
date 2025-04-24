//
//  MainViewModel.swift
//  iOSBootcamp-Task02
//
//  Created by ŞEVVAL on 24.04.2025.
//

import Foundation
import RxSwift

class MainViewModel{
    
    
    var todoRepository = ToDoRepository.shared
    var todoListesi = BehaviorSubject<[ToDos]>(value: [])
       
       init() {
           veritabaniKopyala()
           todoListesi = todoRepository.todoListesi
       }
    
   
       func ara(aramaKelimesi: String) {
           todoRepository.ara(keyword: aramaKelimesi)
       }
       
       func sil(id: Int) {
           todoRepository.sil(id: id)
           todosuYukle()
       }
       
       func todosuYukle() {
           todoRepository.yukle()
       }
       
    func veritabaniKopyala() {
        let bundleYolu = Bundle.main.path(forResource: "todo_app", ofType: ".sqlite")
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let kopyalanacakYer = URL(fileURLWithPath: hedefYol).appendingPathComponent("todo_app.sqlite")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: kopyalanacakYer.path) {
            print("Veritabanı zaten var")
        } else {
            do {
                try fileManager.copyItem(atPath: bundleYolu!, toPath: kopyalanacakYer.path)
                print("Veritabanı başarıyla kopyalandı.")
            } catch {
                print("Veritabanı kopyalama hatası: \(error)")
            }
        }
    }

    
}
