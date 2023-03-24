//
//  ExcercisesViewCell.swift
//  PureMind
//
//  Created by Клим on 04.01.2022.
//

import UIKit

class ExcercisesViewCell: UITableViewCell {
    static let identifier = "excercisesListCell"
    
    @IBOutlet weak var excercisesTableView: UITableView!
    
    var practiceID = ""
    var excercises = [String]()
    weak var parentVC: AllExcerciseViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        excercisesTableView.delegate = self
        excercisesTableView.dataSource = self
        excercisesTableView.separatorStyle = .none
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = newButtonLabelColor.cgColor
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ExcercisesViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        excercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExcerciseViewCell.identifier) as! ExcerciseViewCell
        cell.excerciseNameLabel.text = excercises[indexPath.row]
        cell.excerciseNameLabel.textColor = newButtonLabelColor
        cell.emblemView.image = UIImage(named: "tabBar4")
        cell.layoutMargins = UIEdgeInsets.zero
        cell.showSeparator()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentVC?.practicChosen(practiceID: practiceID, exerciseNumber: indexPath.row)
    }
}
