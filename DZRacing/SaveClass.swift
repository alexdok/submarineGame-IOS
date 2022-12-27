//
//  SaveClass.swift
//  DZRacing
//
//  Created by алексей ганзицкий on 03.08.2022.
//

import Foundation
import UIKit

class SaveClass: Codable {
    
    var nameRacer: String
    var record = 0
    var submarineSkin: String
    var boatSkin: String
    var dataRecord: String
    
    init (nameRacer: String, submarineSkin: String, boatSkin: String, dataRecord: String) {
        self.nameRacer = nameRacer
        self.submarineSkin = submarineSkin
        self.boatSkin = boatSkin
        self.dataRecord = dataRecord
    }
    
    public enum CodingKeys: String, CodingKey { // делаем ключи
        case nameRacer, record, submarineSkin, boatSkin, dataRecord
    }
    
    required public init(from decoder: Decoder) throws {  //распаковываем
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nameRacer = try container.decode(String.self, forKey: .nameRacer) // контайнер достаньстроку по ключу name и запиши в self.name
        self.record = try container.decode(Int.self, forKey: .record)
        self.submarineSkin = try container.decode(String.self, forKey: .submarineSkin)
        self.boatSkin = try container.decode(String.self, forKey: .boatSkin)  // для опционалов decodeIfPresent
        self.dataRecord = try container.decode(String.self, forKey: .dataRecord)
    }
    
    public func encode(to encoder: Encoder) throws { //упаковываем все проперти в контейнер
        var container = encoder.container(keyedBy: CodingKeys.self) //создаём контэйнер
        try container.encode(self.nameRacer, forKey: .nameRacer) //отдельно свойство(проперти) упаковываем
        try container.encode(self.record, forKey: .record)
        try container.encode(self.submarineSkin, forKey: .submarineSkin)
        try container.encode(self.boatSkin, forKey: .boatSkin)
        try container.encode(self.dataRecord, forKey: .dataRecord)
    }
}    	
