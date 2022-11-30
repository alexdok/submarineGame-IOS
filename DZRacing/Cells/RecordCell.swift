//
//  RecordCell.swift
//  DZRacing
//
//  Created by алексей ганзицкий on 18.09.2022.
//

import UIKit

class RecordCell: UITableViewCell {

    @IBOutlet weak var nameRacerLable: UILabel!
    
    @IBOutlet weak var countKillBoatLable: UILabel!
    @IBOutlet weak var dataRecord: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    func addConfig(name:String, count: String, date: String){
        nameRacerLable.text = name
        countKillBoatLable.text = count
        dataRecord.text = date
    }
}


