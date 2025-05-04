//
//  SepetViewController.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 1.05.2025.
//

import UIKit
import RxSwift

class SepetViewController: UIViewController {

    let tableView = UITableView()
    let toplamFiyatLabel = UILabel()
    let viewModel = SepetViewModel()
    let kullaniciAdi = "sevval"

    var sepetUrunleri: [SepetUrun] = [] {
        didSet {
            tableView.reloadData()
            hesaplaToplamFiyat()
            updateEmptyState()
        }
    }

    var sepetUrunleriSubscription: Disposable?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sepetim"
        view.backgroundColor = .white
        setupUI()
        setupBindings()
        viewModel.sepetiYukle(kullaniciAdi: kullaniciAdi)
    }

    private func setupUI() {
        tableView.register(UrunSepetTableViewCell.self, forCellReuseIdentifier: UrunSepetTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        toplamFiyatLabel.translatesAutoresizingMaskIntoConstraints = false
        toplamFiyatLabel.font = .boldSystemFont(ofSize: 18)
        toplamFiyatLabel.textAlignment = .center

        view.addSubview(tableView)
        view.addSubview(toplamFiyatLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: toplamFiyatLabel.topAnchor),

            toplamFiyatLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toplamFiyatLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            toplamFiyatLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            toplamFiyatLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupBindings() {
        // Abonelik manuel yönetimiyle
        sepetUrunleriSubscription = viewModel.sepetListesi
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] urunler in
                print("Sepet güncellendi: \(urunler)")
                self?.sepetUrunleri = urunler
            }, onError: { error in
                print("Hata oluştu: \(error)")
            })

    }

    private func hesaplaToplamFiyat() {
        let toplam = sepetUrunleri.reduce(0.0) { toplam, urun in
            let fiyat = Double(urun.fiyat ?? 0)
            let adet = Double(urun.siparisAdeti ?? 0)
            return toplam + (fiyat * adet)
        }
        UIView.transition(with: toplamFiyatLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.toplamFiyatLabel.text = "Toplam: \(String(format: "%.2f", toplam)) ₺"
        }
    }

    private func updateEmptyState() {
        if sepetUrunleri.isEmpty {
            let imageView = UIImageView(image: UIImage(named: "cart"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .gray
            tableView.backgroundView = imageView
        } else {
            tableView.backgroundView = nil
        }
    }

    deinit {
        sepetUrunleriSubscription?.dispose()
    }
}

extension SepetViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepetUrunleri.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let urun = sepetUrunleri[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UrunSepetTableViewCell.reuseIdentifier, for: indexPath) as! UrunSepetTableViewCell
        cell.configure(with: urun)

        cell.onDelete = { [weak self] in
            guard let self = self else { return }
            self.sepetUrunleri.remove(at: indexPath.row)
            self.viewModel.sepettenSil(sepetId: urun.sepetId ?? 0, silinenAdet: 1, kullaniciAdi: self.kullaniciAdi)
            self.tableView.reloadData() // Tabloyu güncelliyoruz
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urun = sepetUrunleri[indexPath.row]
        guard let sepetId = urun.sepetId else { return }
        
        let alert = UIAlertController(title: "Sil", message: "\(urun.ad ?? "") ürününü silmek istiyor musun?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Evet", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            
            let silinenAdet = urun.siparisAdeti ?? 1
            self.viewModel.sepettenSil(sepetId: sepetId, silinenAdet: silinenAdet, kullaniciAdi: self.kullaniciAdi)
            self.sepetUrunleri.remove(at: indexPath.row)
            self.tableView.reloadData() // Tabloyu güncelle
        }))
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))

        present(alert, animated: true)
    }
}
