//
//  RealmManager.swift
//  CocktailApp
//
//

import Foundation
import RealmSwift

class RealmManager {
    internal static let queueLabel  = "Realm"
    private static let schemaVersion: UInt64 = 1
    
    private static let config = Realm.Configuration(schemaVersion: schemaVersion)
    
    // MARK: - Private
    
    private static func backgroundWrite(_ block: @escaping ((Realm) -> Void)) {
        DispatchQueue(label: queueLabel, qos: .userInitiated).sync {
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: config)
                    try realm.write {
                        block(realm)
                    }
                } catch {
                    print("Realm write error : \(String(describing: block))")
                }
            }
        }
    }
    
    // MARK: - Public
    
    public static func add(_ object: Object, policy: Realm.UpdatePolicy = .all) {
        backgroundWrite { realm in
            realm.add(object, update: policy)
        }
    }
    
    public static func read<T>(_ type: T.Type) -> Results<T> where T: Object {
        return try! Realm(configuration: config).objects(type)
    }
    
    public static func update<T>(_ data: T, block: @escaping ((T) -> Void)) where T: Object {
        guard let realmObject = data.realm else { return }
        
        try? realmObject.write {
            block(data)
        }
    }
    
    public static func delete(_ object: Object) {
        guard let realmObject = object.realm else { return }
        
        try? realmObject.write {
            realmObject.delete(object)
        }
    }
    
    public static func clearAll() {
        backgroundWrite { realm in
            realm.deleteAll()
        }
    }
}

public extension Results where Element: ObjectBase {
    enum PredicateType: String {
        case equal = "%K == %@"
        case notEqual = "%K != %@"
        case and = "AND"
        case or = "OR"
        case not = "NOT"
        case lessThan = "%K < %@"
        case lessOrEqual = "%K <= %@"
        case greaterThan = "%K > %@"
        case greaterOrEqal = "%K >= %@"
        case `in` = "%K IN %@"
        case like = "%K LIKE %@"
    }
    
    func filter(_ formats: [PredicateType], _ args: Any...) -> Results<Element> {
        let format = formats.map(\.rawValue).joined(separator: " ")
        let predicate = NSPredicate(format: format, argumentArray: predicateArguments(args))
        
        return self.filter(predicate)
    }
    
    private func predicateArguments(_ args: [Any]) -> [Any] {
        return args.map { arg -> Any in
            if let keyPath = arg as? PartialKeyPath<Element> {
                return _name(for: keyPath)
            } else if let someArg = arg as Any? {
                return someArg
            }
            
            return NSNull()
        }
    }
}
