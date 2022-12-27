//
//  RecordsViewController.swift
//  DZRacing
//
//  Created by алексей ганзицкий on 26.04.2022.
//

import UIKit

class RecordsViewController: UIViewController {

    let backButton = UIButton()
    
    @IBOutlet weak var tableViewRecord: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Settings.shared.arrayUsers.sort {
            $0.record > $1.record
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.backButton.backgroundColor = .red
        self.backButton.setTitle("back".localized(), for: .normal)
        self.backButton.tintColor = .green
        self.backButton.layer.cornerRadius = 20
        self.backButton.addTarget(self, action: #selector(backButtonTapt), for: .touchUpInside)
        self.backButton.frame = CGRect(x: 20, y: self.view.bounds.height - 60, width: 80, height: 40)
        self.view.addSubview(backButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
    }
    
    @IBOutlet weak var tableView: UITableView!

    @objc func backButtonTapt(sender: UIButton!) {
        UIView.animate(withDuration: 0.3, animations: {self.backButton.backgroundColor = .green}) { (_) in
            self.backButton.backgroundColor = .red
            self.navigationController?.popViewController(animated: true)
        }  
    }
}
