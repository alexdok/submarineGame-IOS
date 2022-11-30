//
//  ViewController.swift
//  DZRacing
//
//  Created by алексей ганзицкий on 26.04.2022.
//

import UIKit
enum controllers {
    static let GameViewController = "GameViewController"
    static let SettingsViewController = "SettingsViewController"
    static let RecordsViewController = "RecordsViewController"

}


class ViewController: UIViewController {
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var recordsButton: UIButton!
    
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    @IBOutlet weak var testImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageOutlet.addParalaxEffect()
        
        for family: String in UIFont.familyNames {
                    print(family)
                    for names: String in UIFont.fontNames(forFamilyName: family) {
                        print("== \(names)")
                    }
                }
        let myFont = UIFont(name: "GreatVibes-Regular", size: 35)
        
        
        newGameButton.titleLabel?.font = myFont
        settingsButton.titleLabel?.font = myFont
        recordsButton.titleLabel?.font = myFont
        
//        let myString = "New Game"
//        let atributed: [NSAttributedString.Key : Any] = [
//            NSAttributedString.Key.foregroundColor : UIColor.black,
//            NSAttributedString.Key.font : myFont as Any
//        ]
//
//        let customString = NSAttributedString(string: myString, attributes: atributed)

//        newGameButton.titleLabel?.attributedText = customString
        newGameButton.addShadow()
        settingsButton.addShadow()
        recordsButton.addShadow()
        
        
        
    }
    


    
    @IBAction func newGameButton(_ sender: UIButton) {
      guard let controller = self.storyboard?.instantiateViewController(withIdentifier: controllers.GameViewController) as? GameViewController else {
          return
      }
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true)
        
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: controllers.SettingsViewController) as? SettingsViewController else {
            return
        }
         self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func recorddsButton(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: controllers.RecordsViewController) as? RecordsViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // фича с закгрузкой через кнопку ДОДЕЛАТЬ
    @IBAction func loadButtonPrassed(_ sender: UIButton) {
//        guard let save = UserDefaults.standard.value(SaveClass.self, forKey: "newRacer") else { return }
//        print( save.nameRacer, save.submarineSkin)
//
//        if let image = Settings.shared.loadImage(filename: save.submarineSkin) {
//            testImage.image = image
//        }
        Settings.shared.loadRecordsTable()
        
    }
    
}

