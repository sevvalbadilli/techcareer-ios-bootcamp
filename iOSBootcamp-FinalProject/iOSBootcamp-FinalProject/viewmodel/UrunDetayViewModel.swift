//
//  UrunDetayViewModel.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 29.04.2025.
//

import Foundation
import RxSwift

class UrunDetayViewModel {
    var repository = UrunlerRepository()

    func sepeteEkle(urun: Urun, adet: Int, kullaniciAdi: String) {
        repository.sepeteEkle(urun: urun, siparisAdeti: adet, kullaniciAdi: kullaniciAdi)
    }
}
