//
//  FavorilerViewModel.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 30.04.2025.
//

import Foundation
import RxSwift

class FavorilerViewModel {
    private let disposeBag = DisposeBag()
    private let urunRepository = UrunlerRepository()

  
    let favoriUrunler = BehaviorSubject<[Urun]>(value: [])

    init() {
        
        urunRepository.urunleriYukle()
        
        urunRepository.urunlerListesi
            .subscribe(onNext: { [weak self] urunler in
                self?.loadFavoriler(from: urunler)
            })
            .disposed(by: disposeBag)
    }

    private func loadFavoriler(from urunler: [Urun]) {
        let favoriIds = FavoritesManager.shared.getFavorites()
        
        let favoriUrunlerListesi = urunler.filter { urun in
            
            guard let urunId = urun.id else {
                return false
            }
            return favoriIds.contains(urunId)
        }

        favoriUrunler.onNext(favoriUrunlerListesi)
    }

}
