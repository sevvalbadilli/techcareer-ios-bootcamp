//
//  AnasayfaViewModel.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 29.04.2025.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    var urunRepository = UrunlerRepository()
    var urunlerListesi = BehaviorSubject<[Urun]>(value: [])

    init() {
        urunlerListesi = urunRepository.urunlerListesi
    }

    func ara(arananKelime: String) {
        urunRepository.ara(arananKelime: arananKelime)
    }

    func urunleriYukle() {
        urunRepository.urunleriYukle()
    }

    func toggleFavorite(for urun: Urun) {
        if let urunId = urun.id {
            FavoritesManager.shared.toggleFavorite(id: urunId)
            FavoritesManager.shared.updateFavoritesCache()
            
            if let currentUrunler = try? urunlerListesi.value() {
                urunlerListesi.onNext(currentUrunler)
            } else {
                print("Favoriler güncellenemedi.")
            }
        } else {
            print("Ürün ID'si mevcut değil!")
        }
    }


    func isFavorite(urun: Urun) -> Bool {
        if let urunId = urun.id {
            return FavoritesManager.shared.isFavorite(id: urunId)
        } else {
            print("Ürün ID'si mevcut değil!")
            return false
        }
    }

}
