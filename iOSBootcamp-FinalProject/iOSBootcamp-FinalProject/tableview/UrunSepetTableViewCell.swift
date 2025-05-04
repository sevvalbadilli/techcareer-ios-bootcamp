//
//  UrunSepetTableViewCell.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 1.05.2025.
//

import UIKit
import Kingfisher

class UrunSepetTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UrunSepetCell"

    private let cardView = UIView()
    let urunImageView = UIImageView()
    let nameLabel = UILabel()
    let priceLabel = UILabel()

    private let quantityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.widthAnchor.constraint(equalToConstant: 30).isActive = true // Sabit genişlik
        return label
    }()

    let increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()

    let decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("−", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()

    let totalPriceLabel = UILabel()
    var onQuantityChanged: ((Int) -> Void)?
    var onDelete: (() -> Void)?
    private var currentQuantity: Int = 1

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        urunImageView.contentMode = .scaleAspectFill
        urunImageView.clipsToBounds = true
        urunImageView.layer.cornerRadius = 8
        urunImageView.translatesAutoresizingMaskIntoConstraints = false

        [nameLabel, priceLabel, totalPriceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .left
        }

        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = UIColor.systemIndigo

        priceLabel.font = .systemFont(ofSize: 14)
        priceLabel.textColor = UIColor.systemBlue

        totalPriceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        totalPriceLabel.textColor = UIColor.systemIndigo
        totalPriceLabel.textAlignment = .right

 
        quantityStackView.addArrangedSubview(decreaseButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(increaseButton)
 
  
        increaseButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        decreaseButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)

        [urunImageView, nameLabel, priceLabel, quantityStackView, totalPriceLabel].forEach {
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            urunImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            urunImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            urunImageView.widthAnchor.constraint(equalToConstant: 80),
            urunImageView.heightAnchor.constraint(equalToConstant: 80),

            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: urunImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            quantityStackView.leadingAnchor.constraint(equalTo: urunImageView.trailingAnchor, constant: 12),
            quantityStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),

            totalPriceLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            totalPriceLabel.centerYAnchor.constraint(equalTo: quantityStackView.centerYAnchor),
            totalPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: quantityStackView.trailingAnchor, constant: 8), // Çakışmayı önler
            totalPriceLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -12),
            urunImageView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -12),
        ])
    }

    func configure(with urun: SepetUrun) {
        if let imageName = urun.resim {
            let urlString = "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)"
            urunImageView.kf.setImage(with: URL(string: urlString), placeholder: UIImage(systemName: "photo"))
        }

        nameLabel.text = urun.ad
        priceLabel.text = "Fiyat: \(urun.fiyat ?? 0) ₺"
        currentQuantity = urun.siparisAdeti ?? 1
        quantityLabel.text = "\(currentQuantity)"

        let toplam = Double(urun.fiyat ?? 0) * Double(currentQuantity)
        totalPriceLabel.text = "\(String(format: "%.2f", toplam)) ₺"
    }

    @objc private func increaseQuantity() {
        currentQuantity += 1
        updateQuantity()
    }

    @objc private func decreaseQuantity() {
        if currentQuantity > 1 {
            currentQuantity -= 1
            updateQuantity()
        } else if currentQuantity == 1 {
            // Adet 1  silme işlemi yapılacak
            onDelete?()
        }
    }


    private func updateQuantity() {
        quantityLabel.text = "\(currentQuantity)"
        if let price = Double(priceLabel.text?.replacingOccurrences(of: "Fiyat: ", with: "").replacingOccurrences(of: " ₺", with: "") ?? "0") {
            let total = price * Double(currentQuantity)
            totalPriceLabel.text = "\(String(format: "%.2f", total)) ₺"
            onQuantityChanged?(currentQuantity) 
        }
    }
}
