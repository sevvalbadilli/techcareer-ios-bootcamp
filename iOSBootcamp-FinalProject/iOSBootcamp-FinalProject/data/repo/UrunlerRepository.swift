//
//  UrunlerRepository.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 29.04.2025.
//

import Foundation
import RxSwift
import Alamofire

class UrunlerRepository {
    var urunlerListesi = BehaviorSubject<[Urun]>(value: [])
    var sepetListesi = BehaviorSubject<[SepetUrun]>(value: [])
    
    
    private var tumUrunler: [Urun] = []

    func urunleriYukle() {
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
        
        AF.request(url, method: .get).responseData { response in
            guard let data = response.data else { return }
            do {
                let cevap = try JSONDecoder().decode(UrunCevap.self, from: data)
                if let liste = cevap.urunler {
                    self.tumUrunler = liste
                    self.urunlerListesi.onNext(liste)
                }
            } catch {
                print("Decode Hatası: \(error.localizedDescription)")
            }
        }
    }

    func ara(arananKelime: String) {
        let kelime = arananKelime.trimmingCharacters(in: .whitespacesAndNewlines)
        if kelime.isEmpty {
            urunlerListesi.onNext(tumUrunler)
        } else {
            let filtrelenmis = tumUrunler.filter {
                $0.ad?.lowercased().contains(kelime.lowercased()) ?? false
            }
            urunlerListesi.onNext(filtrelenmis)
        }
    }

    func sepeteEkle(urun: Urun, siparisAdeti: Int, kullaniciAdi: String) {
        guard let mevcutSepet = try? sepetListesi.value() else { return }

        if let ayniUrun = mevcutSepet.first(where: { $0.ad == urun.ad }) {
            sepettenSil(sepetId: ayniUrun.sepetId ?? 0, kullaniciAdi: kullaniciAdi) { _ in
                self.sepeteEkle(urun: urun, siparisAdeti: siparisAdeti + (ayniUrun.siparisAdeti ?? 0), kullaniciAdi: kullaniciAdi)
            }
        } else {
            let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
            let parameters: Parameters = [
                "ad": urun.ad ?? "",
                "resim": urun.resim ?? "",
                "kategori": urun.kategori ?? "",
                "fiyat": String(urun.fiyat ?? 0),
                "marka": urun.marka ?? "",
                "siparisAdeti": siparisAdeti,
                "kullaniciAdi": kullaniciAdi
            ]
            AF.request(url, method: .post, parameters: parameters).responseData { response in
                guard let data = response.data else { return }
                do {
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    if cevap.success == 1 {
                        self.sepetiYukle(kullaniciAdi: kullaniciAdi)
                    }
                } catch {
                    print("Decode Hatası: \(error.localizedDescription)")
                }
            }
        }
    }

    func sepetiYukle(kullaniciAdi: String) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        let parameters: Parameters = ["kullaniciAdi": kullaniciAdi]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            guard let data = response.data else { return }
            do {
                let cevap = try JSONDecoder().decode(SepetCevap.self, from: data)
                let orijinalListe = cevap.urunler_sepeti ?? []
    
                var birlestirilmis: [String: SepetUrun] = [:]
                
                for urun in orijinalListe {
                    guard let ad = urun.ad else { continue }
                    if let mevcut = birlestirilmis[ad] {
                        mevcut.siparisAdeti = (mevcut.siparisAdeti ?? 0) + (urun.siparisAdeti ?? 0)
                        birlestirilmis[ad] = mevcut
                    } else {
                        birlestirilmis[ad] = urun
                    }
                }
                
                let duzenlenmisListe = Array(birlestirilmis.values)
                self.sepetListesi.onNext(duzenlenmisListe)
            } catch {
                print("Decode Hatası: \(error.localizedDescription)")
            }
        }
    }


    func sepettenSil(sepetId: Int, kullaniciAdi: String, completion: ((Bool) -> Void)? = nil) {
           let url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php"
           let parameters: Parameters = ["sepetId": sepetId, "kullaniciAdi": kullaniciAdi]
           
           AF.request(url, method: .post, parameters: parameters).responseData { response in
               guard let data = response.data else {
                   completion?(false)
                   return
               }
               do {
                   let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                   if cevap.success == 1 {
                       self.sepetiYukle(kullaniciAdi: kullaniciAdi)
                       completion?(true)
                   } else {
                       completion?(false)
                   }
               } catch {
                   print("Decode Hatası: \(error.localizedDescription)")
                   completion?(false)
               }
           }
       }

}
