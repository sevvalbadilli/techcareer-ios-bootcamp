//
//  AnasayfaViewController.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 29.04.2025.
//

import UIKit
import RxSwift

class AnasayfaViewController: UIViewController {

    let disposeBag = DisposeBag()
    let viewModel = AnasayfaViewModel()
 
    private let searchBar = UISearchBar()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 12

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.urunleriYukle()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Alışveriş"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Search Bar
        searchBar.placeholder = "Ürün ara"
        searchBar.searchBarStyle = .minimal
        navigationItem.titleView = searchBar
        
        // Collection View
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

        // Arama
        searchBar.delegate = self
    }

    private func setupBindings() {
        viewModel.urunlerListesi
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - CollectionView Delegate & DataSource

import UIKit
extension AnasayfaViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let urunler = try? viewModel.urunlerListesi.value()
        return urunler?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let urunler = try? viewModel.urunlerListesi.value()
        let urun = urunler?[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UrunHucre", for: indexPath) as! UrunCollectionViewCell
        if let urun = urun {
            cell.configure(with: urun)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 44) / 2
        return CGSize(width: width, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urunler = try? viewModel.urunlerListesi.value() else { return }
        let secilenUrun = urunler[indexPath.row]

        let detayVC = UrunDetayViewController()
        detayVC.urun = secilenUrun
        navigationController?.pushViewController(detayVC, animated: true)
    }
}

extension AnasayfaViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.ara(arananKelime: searchText)
    }
}
