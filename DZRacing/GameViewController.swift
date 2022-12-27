

import UIKit
import CoreMotion

//MARK: enum Movement
enum Movement {
    case up
    case down
    case mid
}

class GameViewController: UIViewController {
    
    //MARK: let/var
    let motionManager = CMMotionManager()
    let backButton = UIButton(frame: CGRect(x: 10, y: 10, width: 70, height: 30))
    let actionButton = UIButton()
    var missilesCount = 10
    let obstruction = UIView()
    let obstructionImageRock = UIImageView()
    let obstructionImageShip = UIImageView()
    let obstructionImageFish = UIImageView()
    let bonusView = UIImageView()
    let missilesView = UIImageView()
    let submarineAnimationImage = UIImageView()
    var crushBoats = 0
    let oxygenTimer = OxyTimer()
    var timer = Timer()
    
    //MARK: outlets
    @IBOutlet weak var backgroundOutlet: UIImageView!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var gameZoneView: UIView!
    @IBOutlet weak var oxyLable: UILabel!
    @IBOutlet weak var finishLable: UILabel!
    @IBOutlet weak var missilesCountLable: UILabel!
    
    //MARK: LiveCircle View
    override func viewDidLoad() {
        super.viewDidLoad()
        if Settings.shared.arrayUsers.isEmpty {
            Settings.shared.createDefaultUser()
        }
        backgroundOutlet.addParalaxEffect()
        moveFromMotionMbager()
        upButton.addShadow()
        backButton.addShadow()
        actionButton.addShadow()
        downButton.addShadow()
        createSubmarine()
        oxygenTimer.oxygenTimer()
        createActionButton()
        // load settings
        loadImageBoat()
        loadImageSubmarine()
        missilesView.removeFromSuperview()
        //
        self.backButton.backgroundColor = .red
        self.backButton.setTitle("back".localized(), for: .normal)
        self.backButton.tintColor = .green
        self.backButton.layer.cornerRadius = backButton.frame.height / 2
        backButton.addTarget(self, action: #selector(backButtonTapt), for: .touchUpInside)
        self.view.addSubview(backButton)
        self.missilesCountLable.textColor = .blue
        timer = Timer.scheduledTimer(withTimeInterval: Settings.shared.loadDifficult(), repeats: true, block: { _ in
            self.moveToleftObstructions(image: self.obstructionImageRock)
            self.moveToleftObstructions(image: self.obstructionImageShip)
            self.moveToleftObstructions(image: self.obstructionImageFish)
            self.moveToleftObstructions(image: self.bonusView)
            self.moveToleftObstructions(image: self.missilesView)
            self.submarineTrouble()
            self.submarineBonusUp()
            self.crushObstraction()
            self.missilesCountLable.text = "missiles: \(self.missilesCount)"
            self.oxyLable.text = "O2: \(self.oxygenTimer.oxygen) %"
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        creatObstractionShip()
        creatObstractionFish()
        createBonus()
        creatObstractionRock()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Settings.shared.saveRecordsTable()
    }
    
    //MARK: IBactions
    @IBAction func pressedButtonUp(_ sender: UIButton) {
        moveUp()
    }
    
    @IBAction func pressedButtonDown(_ sender: UIButton) {
        moveDown()
    }

    //MARK: movemnt & animation func
    //    func animationMove(ico: Movement){
    //        switch ico {
    //        case .down:
    //            self.submarineAnimationImage.image = UIImage(named: "субмарин2")
    //        case .up:
    //            self.submarineAnimationImage.image = settings.submarineSkin
    //        case .mid:
    //            self.submarineAnimationImage.image = UIImage(named: "субмарин")
    //        }
    //    }
    
    func moveFromMotionMbager() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data: CMAccelerometerData?, error: Error?) in
                if let acceleration = data?.acceleration {
                    if acceleration.y >= 0.15 {
                        self?.moveUp()
                    }
                    if acceleration.y <= -0.15 {
                        self?.moveDown()
                    }
                    print("x = " + "\(acceleration.x)")
                    print("y = " + "\(acceleration.y)")
                    print("z = " +  "\(acceleration.z)")
                }
            }
        }
    }
    
    func moveDown() {
        if self.submarineAnimationImage.frame.origin.y > self.gameZoneView.bounds.height - self.submarineAnimationImage.bounds.height {
            submarineCrush()
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.submarineAnimationImage.frame.origin.y += 20
        }
    }
    
    func moveUp() {
        if self.submarineAnimationImage.frame.origin.y < self.gameZoneView.frame.origin.y - self.submarineAnimationImage.bounds.width * 2.5 {
            self.oxygenTimer.oxygen = 100
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.submarineAnimationImage.frame.origin.y -= 20
        }
    }
    
    func loadImageBoat() {
        obstructionImageShip.image = UIImage(named: "корабль1")
        guard let save = UserDefaults.standard.value(SaveClass.self, forKey: "newRacer") else { return }
        if let nowImageBoat = Settings.shared.loadImage(filename: save.boatSkin) {
            obstructionImageShip.image = nowImageBoat
        }
    }
    
    func loadImageSubmarine() {
        if submarineAnimationImage.image == nil {
            submarineAnimationImage.image = UIImage(named: "субмарин")
        }
        guard let save = UserDefaults.standard.value(SaveClass.self, forKey: "newRacer") else { return }
        if let nowImageSubmarine = Settings.shared.loadImage(filename: save.submarineSkin) {
            submarineAnimationImage.image = nowImageSubmarine
        }
    }
    
    func moveToleftObstructions(image: UIImageView) {
        switch image {
        case obstructionImageRock:
            if image.frame.origin.x > self.gameZoneView.frame.origin.x - image.bounds.width  {
                UIView.animate(withDuration: 0.3) {
                    image.frame.origin.x -= 2
                }
            } else {
                image.frame.origin.x = self.view.bounds.width
            }
        case obstructionImageShip:
            if image.frame.origin.x > self.gameZoneView.frame.origin.x - image.bounds.width  {
                UIView.animate(withDuration: 0.3) {
                    image.frame.origin.x -= 12
                }
            } else {
                image.frame.origin.x = self.view.bounds.width + 100
                
            }
        case obstructionImageFish:
            if image.frame.origin.x > self.gameZoneView.frame.origin.x - image.bounds.width  {
                UIView.animate(withDuration: 0.3) {
                    image.frame.origin.x -= CGFloat.random(in: 2...8)
                }
            } else {
                image.frame.origin.x = self.view.bounds.width
            }
        case missilesView:
            if image.frame.origin.x < self.gameZoneView.frame.width {
                UIView.animate(withDuration: 0.3) {
                    image.frame.origin.x += 20
                }
            } else {
                missilesView.removeFromSuperview()
            }
        case bonusView:
            if self.submarineAnimationImage.frame.intersects(self.bonusView.frame) {
                image.removeFromSuperview()
                createBonus()
            } else if image.frame.origin.x > self.gameZoneView.frame.origin.x - image.bounds.width {
                UIView.animate(withDuration: 0.3) {
                    image.frame.origin.x -= CGFloat.random(in: 0...20)
                }
            } else {
                image.frame.origin.x = self.view.bounds.width
                image.frame.origin.y = self.gameZoneView.frame.origin.y / CGFloat.random(in: 1...4)
            }
        default: return
        }
    }
    
    //MARK: objects
    func createSubmarine() {
        let x = self.gameZoneView.frame.origin.x
        let y = self.gameZoneView.frame.origin.y/2
        submarineAnimationImage.frame = CGRect(x: x, y: y, width: 66, height: 40)
        submarineAnimationImage.contentMode = .scaleAspectFit
        self.gameZoneView.addSubview(submarineAnimationImage)
    }
    
    func creatObstractionRock() {
        let endViewX = self.gameZoneView.bounds.width
        let endVIewY = self.gameZoneView.bounds.height - 60
        obstructionImageRock.frame = CGRect(x: endViewX, y: endVIewY, width: 120, height: self.gameZoneView.bounds.height/3)
        obstructionImageRock.image = UIImage(named: "камень")
        self.gameZoneView.addSubview(obstructionImageRock)
    }
    
    func creatObstractionShip() {
        let endViewX = self.view.bounds.width + 300
        let endVIewY = -self.gameZoneView.frame.origin.y + self.gameZoneView.bounds.height/3
        obstructionImageShip.frame = CGRect(x: endViewX, y: endVIewY, width: 120, height: self.gameZoneView.bounds.height/3)
        self.gameZoneView.addSubview(obstructionImageShip)
    }
    
    func creatObstractionFish() {
        let endViewX = self.gameZoneView.bounds.width + 150
        let endVIewY = self.gameZoneView.bounds.height / 2 / 2
        obstructionImageFish.frame = CGRect(x: endViewX, y: endVIewY, width: 120, height: self.gameZoneView.bounds.height/3)
        obstructionImageFish.image = UIImage(named: "рыба")
        obstructionImageFish.contentMode = .scaleAspectFill
        self.gameZoneView.addSubview(obstructionImageFish)
    }
    
    func createBonus() {
        let originYMax = self.gameZoneView.frame.origin.y + self.gameZoneView.frame.height - 40
        let endViewX = self.view.bounds.width * 2
        let endVIewY = CGFloat.random(in: 1...originYMax)
        bonusView.frame = CGRect(x: endViewX, y: endVIewY, width: 40, height: 40)
        bonusView.image = UIImage(named: "bonus")
        self.gameZoneView.addSubview(bonusView)
    }
    
    func createMissiles() {
        let endViewX = self.submarineAnimationImage.frame.origin.x + self.submarineAnimationImage.bounds.width
        let endVIewY = self.submarineAnimationImage.frame.origin.y + self.submarineAnimationImage.bounds.height
        missilesView.frame = CGRect(x: endViewX, y: endVIewY, width: 15, height: 15)
        missilesView.image = UIImage(named: "missiles")
        self.gameZoneView.addSubview(missilesView)
    }
    
    //MARK: events
    func crushObstraction() {
        if self.missilesView.frame.intersects(self.obstructionImageRock.frame) {
            UIView.animate(withDuration: 0.5) {
                self.missilesView.removeFromSuperview()
                self.missilesView.frame.origin.x += self.gameZoneView.bounds.width
                self.obstructionImageRock.image = UIImage(named: "badabum")
                self.obstructionImageRock.frame.origin.x += 5
            } completion: { _ in
                self.obstructionImageRock.frame.origin.x = self.view.bounds.width
                self.obstructionImageRock.image = UIImage(named: "камень")
            }
        } else if self.missilesView.frame.intersects(self.obstructionImageFish.frame) {
            UIView.animate(withDuration: 0.9) {
                self.missilesView.removeFromSuperview()
                self.missilesView.frame.origin.x += self.gameZoneView.bounds.width
                self.obstructionImageFish.image = UIImage(named: "badabum")
                self.obstructionImageFish.frame.origin.x += 5
            } completion: { _ in
                self.obstructionImageFish.frame.origin.x = self.view.bounds.width
                self.obstructionImageFish.image = UIImage(named: "рыба")
            }
        } else if self.missilesView.frame.intersects(self.obstructionImageShip.frame) {
            self.missilesView.frame.origin.x = 1500
            self.crushBoats += 1
            UIView.animate(withDuration: 0.5) {
                self.missilesView.removeFromSuperview()
                self.missilesView.frame.origin.x += self.gameZoneView.bounds.width
                self.obstructionImageShip.image = UIImage(named: "badabum")
                self.obstructionImageShip.frame.origin.x += 5
            } completion: { _ in
                self.obstructionImageShip.frame.origin.x = self.view.bounds.width
                self.loadImageBoat()
            }
        }
    }
    
    func submarineTrouble() {
        if self.submarineAnimationImage.frame.intersects(self.obstructionImageRock.frame) || self.submarineAnimationImage.frame.intersects(self.obstructionImageShip.frame) || self.submarineAnimationImage.frame.intersects(self.obstructionImageFish.frame) || self.oxygenTimer.oxygen == 0 {
            submarineCrush()
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    func submarineBonusUp() {
        if self.submarineAnimationImage.frame.intersects(self.bonusView.frame) {
            missilesCount += 1
        }
    }
    
    func saveRecord() {
        let racer = Settings.shared.arrayUsers.removeLast()
        //        guard let record = Settings.shared.recordText as? Int else { return }
        if racer.record < crushBoats { racer.record = crushBoats }
        //        guard let oldRecord = Settings.shared.recordText as? Int else { return }
        //        if crushBoats > oldRecord {
        //            Settings.shared.recordText = crushBoats
        //            UserDefaults.standard.set(crushBoats, forKey: "newRecord")
        let dateRecord = Date()
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm  dd / MMMM / yyyy"
        let dataRecordFormat = formater.string(from: dateRecord)
        UserDefaults.standard.set(dataRecordFormat, forKey: "dataRecord")
        //        }
        racer.dataRecord = dataRecordFormat
        Settings.shared.arrayUsers.append(racer)
    }
    
    func submarineCrush() {
        upButton.isHidden = true
        downButton.isHidden = true
        self.submarineAnimationImage.image = UIImage(named: "badabum")
        timer.invalidate()
        finishLable.isHidden = false
        saveRecord()
        motionManager.stopAccelerometerUpdates()
    }
    
    //MARK: Buttons
    func createActionButton() {
        actionButton.frame = CGRect(x: self.view.bounds.width - 80, y: self.view.frame.minY + 30, width: 60, height: 60)
        actionButton.layer.cornerRadius = actionButton.frame.height/2
        actionButton.backgroundColor = .cyan
        actionButton.setTitle("Fire".localized(), for: .normal)
        actionButton.setTitleColor(.black, for: .normal)
        
        self.view.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(actionButtonTapt), for: .touchUpInside)
    }
    
    @IBAction func actionButtonTapt(sendet: UIButton!) {
        UIView.animate(withDuration: 0.3, animations: { self.actionButton.backgroundColor = .green }) { (_) in
            self.actionButton.backgroundColor = .cyan
            if self.missilesCount > 0 {
                self.createMissiles()
                self.missilesCount -= 1
            }
        }
    }
    
    @objc func backButtonTapt(sender: UIButton!) {
        UIView.animate(withDuration: 0.3, animations: { self.backButton.backgroundColor = .green }) { (_) in
            self.backButton.backgroundColor = .red
            self.dismiss(animated: true)
        }
    }
}


