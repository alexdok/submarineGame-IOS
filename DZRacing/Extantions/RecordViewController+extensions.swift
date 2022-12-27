
import Foundation
import UIKit

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.shared.arrayUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as? RecordCell else {return UITableViewCell()}
        cell.addConfig(name: Settings.shared.arrayUsers[indexPath.row].nameRacer, count: "\(Settings.shared.arrayUsers[indexPath.row].record)" , date: Settings.shared.arrayUsers[indexPath.row].dataRecord)
        return cell
    }
}
