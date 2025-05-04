//
//  UrunDetayViewController.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 1.05.2025.
//

import UIKit
import Kingfisher

class UrunDetayViewController: UIViewController {

    var urun: Urun!
    let kullaniciAdi = "sevval"
    var viewModel = UrunDetayViewModel()

    private let urunImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let urunAdiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let fiyatLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemIndigo
        label.textAlignment = .center
        return label
    }()

    private let adetLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }()

    private let azaltButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("−", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 8
        return button
    }()

    private let artirButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 8
        return button
    }()

    private let sepeteEkleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sepete Ekle", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 32, bottom: 12, right: 32)
        return button
    }()

    private var adet: Int = 1 {
        didSet {
            adetLabel.text = "\(adet)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = urun.ad
        setupUI()
        configureUrun()
    }

    private func setupUI() {
        azaltButton.addTarget(self, action: #selector(adetAzalt), for: .touchUpInside)
        artirButton.addTarget(self, action: #selector(adetArtir), for: .touchUpInside)
        sepeteEkleButton.addTarget(self, action: #selector(sepeteEkleTapped), for: .touchUpInside)

        let adetStack = UIStackView(arrangedSubviews: [azaltButton, adetLabel, artirButton])
        adetStack.axis = .horizontal
        adetStack.spacing = 12
        adetStack.alignment = .center

        let stack = UIStackView(arrangedSubviews: [urunImageView, urunAdiLabel, fiyatLabel, adetStack, sepeteEkleButton])
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            urunImageView.widthAnchor.constraint(equalToConstant: 200),
            urunImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func configureUrun() {
        if let resimAdi = urun.resim {
            let urlString = "http://kasimadalan.pe.hu/urunler/resimler/\(resimAdi)"
            if let url = URL(string: urlString) {
                urunImageView.kf.setImage(with: url)
            }
        }

        urunAdiLabel.text = urun.ad
        fiyatLabel.text = "₺ \(urun.fiyat ?? 0)"
    }

    @objc private func adetAzalt() {
        if adet > 1 {
            adet -= 1
        }
    }

    @objc private func adetArtir() {
        if adet < 10 {
            adet += 1
        }
    }

    @objc private func sepeteEkleTapped() {
        viewModel.sepeteEkle(urun: urun, adet: adet, kullaniciAdi: kullaniciAdi)
        navigationController?.popViewController(animated: true)
    }
}
