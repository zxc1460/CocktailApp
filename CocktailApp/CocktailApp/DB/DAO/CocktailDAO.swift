//
//  CocktailDAO.swift
//  CocktailApp
//
//

import Foundation
import RealmSwift

struct CocktailDAO {
    
    // MARK: - Read
    
    func read() -> Results<CocktailData> {
        return RealmManager.read(CocktailData.self)
    }
    
    func read(id: String) -> Results<CocktailData> {
        return read().filter([.equal], \CocktailData.id, id)
    }

    func read(id: String) -> CocktailData? {
        return read().filter([.equal], \CocktailData.id, id).first?.freeze()
    }
    
    // MARK: - Write
    
    func insert(data: CocktailData) {
        RealmManager.add(data)
    }
    
    func update(data: CocktailData) {
        RealmManager.add(data, policy: .all)
    }
    
    // MARK: - Delete
    
    func delete(id: String) {
        if let data = read(id: id) {
            RealmManager.delete(data)
        }
    }
}
