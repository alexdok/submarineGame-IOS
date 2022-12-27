//
//  SettingsViewController.swift
//  DZRacing
//
//  Created by алексей ганзицкий on 26.04.2022.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var openSubmarineButtonPlaceHolder: UIButton!
    @IBOutlet weak var openBoatButtonPlaceHolder: UIButton!
    @IBOutlet weak var leftRightButton: UIButton!
    @IBOutlet weak var leftLeftButton: UIButton!
    @IBOutlet weak var pickerDifficulty: UIPickerView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightLeftButton: UIButton!
    @IBOutlet weak var rightRightButton: UIButton!
    
    let backButton = UIButton(frame: CGRect(x: 20, y: 40, width: 80, height: 40))
    let centerImageLeft = UIImageView()
    let leftImageLeft = UIImageView()
    let rightImageLeft = UIImageView()
    let centerImageRight = UIImageView()
    let leftImageRight = UIImageView()
    let rightImageRight = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButtonBack()
        pickerDifficulty.delegate = self
        pickerDifficulty.dataSource = self
        if Settings.shared.difficultArray.isEmpty { return }
        Settings.shared.difficultRow = Settings.shared.difficultArray.first!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createImages()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Settings.shared.difficultArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Settings.shared.difficultArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Settings.shared.difficultRow = Settings.shared.difficultArray[row]
    }
    
    func createImages() {
        createLeftViewObj()
        createRigtViewObj()
    }
    
    @IBAction func openSubmarineSelectorButton(_ sender: UIButton) {
        moveToRightRight()
        rightRightButton.isHidden = false
        rightLeftButton.isHidden = false
        openSubmarineButtonPlaceHolder.isHidden = true
        moveToRightLeft()
        leftLeftButton.isHidden = false
        leftRightButton.isHidden = false
        openBoatButtonPlaceHolder.isHidden = true
    }
    
    @IBAction func openBoatSelectorButton(_ sender: UIButton) {
        moveToRightLeft()
        leftLeftButton.isHidden = false
        leftRightButton.isHidden = false
        openBoatButtonPlaceHolder.isHidden = true
        moveToRightRight()
        rightRightButton.isHidden = false
        rightLeftButton.isHidden = false
        openSubmarineButtonPlaceHolder.isHidden = true
    }
    
    @IBAction func rightSwapSkinBoat(_ sender: UIButton) {
        moveToRightLeft()
    }
    
    @IBAction func leftSwapSkinBoat(_ sender: UIButton) {
        moveToLeftLeft()
    }
    
    @IBAction func rightSwapSkinSubmarine(_ sender: UIButton) {
        moveToRightRight()
    }
    
    @IBAction func leftSwapSkinSubmarine(_ sender: UIButton) {
        moveToLeftRight()
    }
    
    @IBAction func saveButtonPrassed(_ sender: UIButton) {
        guard let imageBoat = centerImageLeft.image  else { return }
        guard let imageSubmarine = centerImageRight.image else { return }
        let nameImageBoat = Settings.shared.saveImage(image: imageBoat)
        let nameImageSubmarine = Settings.shared.saveImage(image: imageSubmarine)
        UserDefaults.standard.set(nameImageBoat, forKey: "imageBoat")
        UserDefaults.standard.set(nameImageSubmarine, forKey: "imageSubmarine")
        showAlertSave()
    }
    
    func createRigtViewObj() {
        centerImageRight.image = nil
        centerImageRight.frame = CGRect(x: 0, y: 0, width: rightView.frame.width/3, height: rightView.frame.height/3)
        centerImageRight.frame.origin.x = rightView.frame.width/2 - centerImageRight.frame.width/2
        centerImageRight.frame.origin.y = 0
        rightView.addSubview(centerImageRight)
        rightImageRight.isHidden = true
        rightImageRight.frame = CGRect(x: centerImageRight.frame.origin.x + centerImageRight.frame.width, y: 0, width: centerImageRight.frame.width, height: centerImageRight.frame.height)
        rightView.addSubview(rightImageRight)
        leftImageRight.isHidden = true
        leftImageRight.frame = CGRect(x: centerImageRight.frame.origin.x - centerImageRight.frame.width, y: 0, width: centerImageRight.frame.width, height: centerImageRight.frame.height)
        rightView.addSubview(leftImageRight)
    }
    
    func createLeftViewObj() {
        centerImageLeft.image = nil
        centerImageLeft.frame = CGRect(x: 0, y: 0, width: leftView.frame.width/3, height: leftView.frame.height/3)
        centerImageLeft.frame.origin.x = leftView.frame.width/2 - centerImageLeft.frame.width/2
        centerImageLeft.frame.origin.y = 0
        leftView.addSubview(centerImageLeft)
        
        rightImageLeft.frame = CGRect(x:centerImageLeft.frame.origin.x + centerImageLeft.frame.width, y: 0, width: centerImageLeft.frame.width, height: centerImageLeft.frame.height)
        rightImageLeft.isHidden = true
        leftView.addSubview(rightImageLeft)
        
        
        leftImageLeft.frame = CGRect(x: centerImageLeft.frame.origin.x - centerImageLeft.frame.width, y: 0, width: centerImageLeft.frame.width, height: centerImageLeft.frame.height)
        leftImageLeft.isHidden = true
        leftView.addSubview(leftImageLeft)
        
    }
    
    func moveToRightLeft() {
        if centerImageLeft.image != nil {
            Settings.shared.arrayOfBoatSkins.append(centerImageLeft.image)
            moveRightAll()
        } else {
            moveRightAll()
        }
    }
    
    func moveRightAll() {
        if let image = Settings.shared.arrayOfBoatSkins.removeFirst() {
            rightImageLeft.image = image
            UIView.animate(withDuration: 0.3) {
                self.rightImageLeft.frame = self.centerImageLeft.frame
                self.rightImageLeft.isHidden = false
                self.centerImageLeft.frame = self.leftImageLeft.frame
                self.centerImageLeft.alpha = 0
            } completion: { _ in
                self.centerImageLeft.image = self.rightImageLeft.image
                self.centerImageLeft.frame = self.rightImageLeft.frame
                self.centerImageLeft.alpha = 1
                self.rightImageLeft.frame.origin.x = self.centerImageLeft.frame.origin.x + self.centerImageLeft.frame.width
                self.rightImageLeft.isHidden = true
                
                self.rightImageLeft.image = Settings.shared.arrayOfBoatSkins.first as? UIImage
                
            }
        }
    }
    
    func moveToLeftLeft() {
        Settings.shared.arrayOfBoatSkins.insert(centerImageLeft.image, at: 0)
        if let image = Settings.shared.arrayOfBoatSkins.removeLast() {
            leftImageLeft.image = image
            UIView.animate(withDuration: 0.3) {
                self.leftImageLeft.frame = self.centerImageLeft.frame
                self.leftImageLeft.isHidden = false
                self.centerImageLeft.frame = self.rightImageLeft.frame
                self.centerImageLeft.alpha = 0
            } completion: { _ in
                self.centerImageLeft.image = self.leftImageLeft.image
                self.centerImageLeft.frame = self.leftImageLeft.frame
                self.centerImageLeft.alpha = 1
                self.leftImageLeft.frame.origin.x = self.centerImageLeft.frame.origin.x - self.centerImageLeft.frame.width
                self.leftImageLeft.isHidden = true
                
                self.leftImageLeft.image = Settings.shared.arrayOfBoatSkins.last as? UIImage
            }
        }
    }
    
    func moveToRightRight() {
        if centerImageRight.image != nil {
            Settings.shared.arrayOfSubmarineImages.append(centerImageRight.image)
            moveRightRight()
        } else {
            moveRightRight()
        }
    }
    
    func moveRightRight() {
        if let image = Settings.shared.arrayOfSubmarineImages.removeFirst() {
            rightImageRight.image = image
            UIView.animate(withDuration: 0.3) {
                self.rightImageRight.frame = self.centerImageRight.frame
                self.rightImageRight.isHidden = false
                self.centerImageRight.frame = self.leftImageRight.frame
                self.centerImageRight.alpha = 0
            } completion: { _ in
                self.centerImageRight.image = self.rightImageRight.image
                self.centerImageRight.frame = self.rightImageRight.frame
                self.centerImageRight.alpha = 1
                self.rightImageRight.frame.origin.x = self.centerImageRight.frame.origin.x + self.centerImageRight.frame.width
                self.rightImageRight.isHidden = true
                
                self.rightImageRight.image = Settings.shared.arrayOfSubmarineImages.first as? UIImage
            }
        }
    }
    
    func moveToLeftRight() {
        Settings.shared.arrayOfSubmarineImages.insert(centerImageRight.image, at: 0)
        if let image = Settings.shared.arrayOfSubmarineImages.removeLast() {
            leftImageRight.image = image
            UIView.animate(withDuration: 0.3) {
                self.leftImageRight.frame = self.centerImageRight.frame
                self.leftImageRight.isHidden = false
                self.centerImageRight.frame = self.rightImageRight.frame
                self.centerImageRight.alpha = 0
            } completion: { _ in
                self.centerImageRight.image = self.leftImageRight.image
                self.centerImageRight.frame = self.leftImageRight.frame
                self.centerImageRight.alpha = 1
                self.leftImageRight.frame.origin.x = self.centerImageRight.frame.origin.x - self.centerImageRight.frame.width
                self.leftImageRight.isHidden = true
                
                self.leftImageRight.image = Settings.shared.arrayOfSubmarineImages.last as? UIImage
            }
        }
    }
    
    func createButtonBack() {
        self.backButton.backgroundColor = .red
        self.backButton.setTitle("back".localized(), for: .normal)
        self.backButton.tintColor = .green
        self.backButton.layer.cornerRadius = 20
        backButton.addTarget(self, action: #selector(backButtonTapt), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    
    @objc func backButtonTapt(sender: UIButton!) {
        UIView.animate(withDuration: 0.3, animations: {
            self.backButton.backgroundColor = .green }) { (_) in
                self.backButton.backgroundColor = .red
                self.navigationController?.popToRootViewController(animated: true)
            }
    }
    
    func showAlertSave() {
        let alert = UIAlertController(title: "Save".localized(), message: "save your settings".localized(), preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default) { _ in
            if let newName = alert.textFields?.first?.text {
                UserDefaults.standard.set(newName, forKey: "newName")
            }
            let newRacer = SaveClass(nameRacer: UserDefaults.standard.value(forKey: "newName") as? String  ?? "-", submarineSkin: UserDefaults.standard.value(forKey: "imageSubmarine") as? String ?? "0", boatSkin: UserDefaults.standard.value(forKey: "imageBoat") as? String ?? "0", dataRecord: "0")
            newRacer.record = Settings.shared.recordText as? Int ?? 0
            UserDefaults.standard.set(encodeble: newRacer, forKey: "newRacer")
            Settings.shared.arrayUsers.append(newRacer)
            print(Settings.shared.arrayUsers.count)
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addTextField { LoginTF in
            LoginTF.placeholder = "Name"
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

