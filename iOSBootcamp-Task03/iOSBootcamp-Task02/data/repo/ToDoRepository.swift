//
//  ToDoRepository.swift
//  iOSBootcamp-Task02
//
//  Created by ŞEVVAL on 24.04.2025.
//


import Foundation
import RxSwift

class ToDoRepository {
    
    static let shared = ToDoRepository()
    
    var todoListesi = BehaviorSubject<[ToDos]>(value: [])
    let db: FMDatabase?
    
    
    init() {
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniURL = URL(fileURLWithPath: hedefYol).appendingPathComponent("todo_app.sqlite")
        db = FMDatabase(path: veritabaniURL.path)
    }
    
    
    func ekle(todo: String) {
        guard let db = db, db.open() else {
            print("Veritabanı bağlantısı açılamadı.")
            return
        }
        
        do {
            try db.executeUpdate("INSERT INTO toDos (name) VALUES (?)", values: [todo])
            print("Todo eklendi: \(todo)")
        } catch {
            print("Ekleme hatası: \(error.localizedDescription)")
        }
        db.close()
        yukle()
    }
    
   
    func guncelle(id: Int, yeniText: String) {
        guard let db = db, db.open() else {
            print("Veritabanı bağlantısı açılamadı.")
            return
        }
        
        do {
            try db.executeUpdate("UPDATE toDos SET name = ? WHERE id = ?", values: [yeniText, id])
            print("Todo güncellendi: \(yeniText)")
        } catch {
            print("Güncelleme hatası: \(error.localizedDescription)")
        }
        db.close()
        yukle()
    }
    
    
    func sil(id: Int) {
        guard let db = db, db.open() else {
            print("Veritabanı bağlantısı açılamadı.")
            return
        }
        
        do {
            try db.executeUpdate("DELETE FROM toDos WHERE id = ?", values: [id])
            print("Todo silindi: ID \(id)")
        } catch {
            print("Silme hatası: \(error.localizedDescription)")
        }
        db.close()
        yukle()
    }
    
    
    func ara(keyword: String) {
        guard let db = db, db.open() else {
            print("Veritabanı bağlantısı açılamadı.")
            return
        }
        
        var liste = [ToDos]()
        do {
            let result = try db.executeQuery("SELECT * FROM toDos WHERE name LIKE ?", values: ["%\(keyword)%"])
            while result.next() {
                let id = Int(result.int(forColumn: "id"))
                let name = result.string(forColumn: "name")!
                liste.append(ToDos(id: id, name: name))
            }
            todoListesi.onNext(liste)
        } catch {
            print("Arama hatası: \(error.localizedDescription)")
        }
        db.close()
    }
    
    
    func yukle() {
        guard let db = db, db.open() else {
            print("Veritabanı bağlantısı açılamadı.")
            return
        }
        
        var liste = [ToDos]()
        do {
            let result = try db.executeQuery("SELECT * FROM toDos", values: nil)
            while result.next() {
                let id = Int(result.int(forColumn: "id"))
                let name = result.string(forColumn: "name")!
                liste.append(ToDos(id: id, name: name))
            }
            todoListesi.onNext(liste)
        } catch {
            print("Yükleme hatası: \(error.localizedDescription)")
        }
        db.close()
    }
}
