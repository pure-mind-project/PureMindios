//
//  SingleCourseViewCell.swift
//  PureMind
//
//  Created by Клим on 16.01.2022.
//

import UIKit

class SingleCourseViewCell: UITableViewCell {
    static let identifier = "lessonsListCell"
    
    @IBOutlet weak var lessonsTableView: UITableView!
    
    var lessons = [ShortLessonInfo]()
    var courseIndex: Int!
    weak var parentVC: AllCoursesViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lessonsTableView.delegate = self
        lessonsTableView.dataSource = self
        lessonsTableView.separatorStyle = .none
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 253, green: 247, blue: 221).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension SingleCourseViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExcerciseViewCell.identifier) as! ExcerciseViewCell
        cell.excerciseNameLabel.text = lessons[indexPath.row].name
        cell.backgroundImageView.image = UIImage(named: "Rectangle 61")
        cell.emblemView.image = UIImage(named: "тик2")
        cell.layoutMargins = UIEdgeInsets.zero
        cell.showSeparator()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentVC?.lessonChosen(index: indexPath.row, courseIndex: courseIndex)
    }
}

