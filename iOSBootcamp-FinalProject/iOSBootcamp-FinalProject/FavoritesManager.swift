//
//  FavoritesManager.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 29.04.2025.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "favoriUrunler"
    private var cachedFavorites: Set<Int>?

    private init() {
        cachedFavorites = Set(getFavorites())  // İlk başta veriyi yükle
    }

    // Favorileri UserDefaults'tan al
    func getFavorites() -> [Int] {
        return UserDefaults.standard.array(forKey: key) as? [Int] ?? []
    }

    // Favori ekleme/çıkarma durumunu kontrol et
    func isFavorite(id: Int) -> Bool {
        return cachedFavorites?.contains(id) ?? false
    }

    // Favorileri güncelle
    func toggleFavorite(id: Int) {
        if isFavorite(id: id) {
            removeFavorite(id: id)
        } else {
            addFavorite(id: id)
        }
    }

    // Favoriye ekle
    public func addFavorite(id: Int) {
        cachedFavorites?.insert(id)
        saveFavorites()
    }

    // Favoriden çıkar
    public func removeFavorite(id: Int) {
        cachedFavorites?.remove(id)
        saveFavorites()
    }

    // Güncellenmiş favori listesini UserDefaults'a kaydet
    private func saveFavorites() {
        guard let favorites = cachedFavorites else { return }
        UserDefaults.standard.setValue(Array(favorites), forKey: key)
    }

    // Favori listesi cache'ini güncelle
    func updateFavoritesCache() {
        cachedFavorites = Set(getFavorites())
    }
}
