//
//  FavorilerViewController.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 30.04.2025.
//

import UIKit
import RxSwift

class FavorilerViewController: UIViewController {

    let disposeBag = DisposeBag()
    let viewModel = FavorilerViewModel() 

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Favoriler"

        collectionView.register(UrunCollectionViewCell.self, forCellWithReuseIdentifier: "UrunHucre")
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)

        // Layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupBindings() {
        // Favori ürünler listesi bağlanıyor
        viewModel.favoriUrunler
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView Delegate & DataSource

extension FavorilerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Favori ürünler listesine güvenli bir şekilde subscribe olunuyor
        var favoriler = [Urun]()
        viewModel.favoriUrunler
            .subscribe(onNext: { favorilerListesi in
                favoriler = favorilerListesi
            })
            .disposed(by: disposeBag)

        return favoriler.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var favoriler = [Urun]()
        viewModel.favoriUrunler
            .subscribe(onNext: { favorilerListesi in
                favoriler = favorilerListesi
            })
            .disposed(by: disposeBag)
        
        let urun = favoriler[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UrunHucre", for: indexPath) as! UrunCollectionViewCell
        cell.configure(with: urun)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 42) / 2
        return CGSize(width: width, height: 200)
    }
}
