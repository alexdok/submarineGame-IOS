//
//  Settings.swift
//  DZRacing
//
//  Created by алексей ганзицкий on 29.07.2022.
//

import Foundation
import UIKit

enum Difficult: String {
    case normal = "normal"
    case ease = "ease"
    case hard = "hard"
}

class Settings {
    
    static var shared = Settings()
    
    var difficult: Difficult = .normal
    let difficultArray = ["hard","normal","easy"]
    var difficultRow = "normal" {
        didSet {
            changeDifficult(difficultFunk: difficultRow)
        }
    }
    var recordText = UserDefaults.standard.value(forKey: "newRecord")
    var intervalTimer = 0.1
    var nameRacer = " "
    var arrayOfSubmarineImages:[UIImage?] = [UIImage(named: "субмарин3"), UIImage(named: "субмарин4"),UIImage(named: "субмарин5"),UIImage(named: "субмарин")]
    var arrayOfBoatSkins: [UIImage?] = [UIImage(named: "корабль4"), UIImage(named: "корабль3"),UIImage(named: "корабль2"),UIImage(named: "корабль1")]
    var arrayUsers:[SaveClass] = []
    var arrayOfKeysForUsers: [String] = []
    var loadUserdArray:[SaveClass] = []
    
    func createDefaultUser() {
        let user = SaveClass(nameRacer: "nonameUser", submarineSkin: "default", boatSkin: "default", dataRecord: "no save")
        arrayUsers.append(user)
    }
    
    func changeDifficult(difficultFunk: String) {
        switch difficultRow {
        case "normal" :
            difficult = .normal
            self.intervalTimer = 0.1
        case "hard" :
            difficult = .hard
            self.intervalTimer = 0.05
        case "easy" :
            difficult = .ease
            self.intervalTimer = 0.17
        default : break
        }
        UserDefaults.standard.set(self.intervalTimer, forKey: "saveDifficult")
    }
    
    func loadRecord() -> Int {
        guard let loadRecord = UserDefaults.standard.value(forKey: "newRecord") as? Int else { return 0}
        return loadRecord
    }
    
    func loadDifficult() -> Double {
        guard let loadTimer = UserDefaults.standard.value(forKey: "saveDifficult") as? Double else { return 0.1}
        return loadTimer
    }
    
    func saveImage( image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }  // путь к папке приложения
        let fileName = UUID().uuidString // создаёт уникальную строку(в будущем имя файла)
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.pngData() else { return nil }
        // check if file exists, removes it if so. Прверяем есть ли файл по данному пути/ удалили
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("remove old image")
            } catch let error {
                print("could't remove file at path", error)
            }
        }
        // записали файл по пути fileUrl вернули имя fileName
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    func loadImage( filename: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentsDirectory.appendingPathComponent(filename)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    func saveRecordsTable() {
        for user in arrayUsers {
            UserDefaults.standard.set(encodeble: user, forKey: user.nameRacer)
            arrayOfKeysForUsers.append(user.nameRacer)
        }
        UserDefaults.standard.set(arrayOfKeysForUsers, forKey: "arrayOfKeysForUsers")
        arrayOfKeysForUsers.removeAll()
    }
    
    func loadRecordsTable() {
        guard  let arrayOfKeys = UserDefaults.standard.value(forKey: "arrayOfKeysForUsers") as? [String] else {return}
        for key in arrayOfKeys {
            guard let user = UserDefaults.standard.value(SaveClass.self, forKey: key) else { return }
            loadUserdArray.append(user)
        }
        arrayUsers = loadUserdArray
        loadUserdArray.removeAll()
    }
}
