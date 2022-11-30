//
//  UserDefaults+extansioms.swift
//  DZRacing
//
//  Created by алексей ганзицкий on 18.09.2022.
////
//
//import Foundation
//import UIKit
//
//extension UserDefaults {
//    
//    func set<T: Encodable>(encodeble: T, forKey key: String) {
//        if let data = try? JSONEncoder().encode(encodeble) {
//            set(data, forKey: key)
//        }
//    }
//    
//    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
//        if let data = object(forKey: key) as? Data,
//           let value = try? JSONDecoder().decode(type, from: data) {
//            return value
//        }
//        return nil
//    }
//}
//
//
//
//
