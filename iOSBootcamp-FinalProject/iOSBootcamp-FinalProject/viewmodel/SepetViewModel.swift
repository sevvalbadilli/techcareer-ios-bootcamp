//
//  SepetViewModel.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 29.04.2025.
//


import Foundation
import RxSwift

class SepetViewModel {
    var repository = UrunlerRepository()
    var sepetListesi: BehaviorSubject<[SepetUrun]> {
        return repository.sepetListesi
    }

    func sepetiYukle(kullaniciAdi: String) {
        repository.sepetiYukle(kullaniciAdi: kullaniciAdi)
    }

    func sepeteEkle(urun: Urun, siparisAdeti: Int, kullaniciAdi: String) {
        repository.sepeteEkle(urun: urun, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
    }

    func sepettenSil(sepetId: Int, silinenAdet: Int, kullaniciAdi: String) {
            repository.sepettenSil(sepetId: sepetId, kullaniciAdi: kullaniciAdi)
        }
    

    }

