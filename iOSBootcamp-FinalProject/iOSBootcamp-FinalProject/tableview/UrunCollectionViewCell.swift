//
//  UrunCollectionViewCell.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 29.04.2025.
//

import UIKit
import Kingfisher

class UrunCollectionViewCell: UICollectionViewCell {

    let imageView = UIImageView()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let deliveryLabel = UILabel()
    let favoriteButton = UIButton(type: .system)
    let addButton = UIButton(type: .system)

    private var urunId: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with urun: Urun) {
        urunId = urun.id
        nameLabel.text = urun.ad
        priceLabel.text = "\(urun.fiyat ?? 0) ₺"

        if let resimAdi = urun.resim {
            let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(resimAdi)")
            imageView.kf.setImage(with: url)
        }

        updateFavoriteButton()
    }

    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.05
        contentView.layer.shadowRadius = 6
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.clipsToBounds = false

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10

        nameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 2

        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.textColor = .systemIndigo

        deliveryLabel.text = "Ücretsiz Gönderim"
        deliveryLabel.font = .systemFont(ofSize: 12)
        deliveryLabel.textColor = .systemGray

        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .systemRed
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

        [imageView, nameLabel, priceLabel, deliveryLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.55),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            deliveryLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            deliveryLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            deliveryLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }



    private func updateFavoriteButton() {
        guard let id = urunId else { return }

        if FavoritesManager.shared.isFavorite(id: id) {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    @objc private func favoriteButtonTapped() {
        guard let id = urunId else { return }

        FavoritesManager.shared.toggleFavorite(id: id)
        updateFavoriteButton()
    }

  

}
