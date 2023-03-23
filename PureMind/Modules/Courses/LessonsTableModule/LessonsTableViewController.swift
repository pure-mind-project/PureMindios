//
//  LessonsTableViewController.swift
//  PureMind
//
//  Created by Клим on 06.02.2022.
//

import UIKit
import SafariServices

protocol LessonsTableViewProtocol: UIViewController{
    func updateUI()
    func sendAlert(text: String)
}

struct LessonsTableViewControllerInitInfo {
    var presenter: LessonsTablePresenterProtocol
    var courseId: String
    var vcIndex: Int
    var previousReflexCount: Int
}

class LessonsTableViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var presenter: LessonsTablePresenterProtocol!
    var courseId = ""
    var vcIndex: Int!
    var lockImageView: UIImageView!
    var lockLabel: UILabel!
    var previousReflexCount: Int!
    var initInfo: LessonsTableViewControllerInitInfo? {
        didSet {
            presenter = initInfo?.presenter
            courseId = initInfo?.courseId ?? ""
            vcIndex = initInfo?.vcIndex
            previousReflexCount = initInfo?.previousReflexCount
        }
    }
    
    @IBOutlet weak var elementsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        elementsTableView.delegate = self
        elementsTableView.dataSource = self
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLessonComplition()
    }
    
    func checkLessonComplition() {
        if previousReflexCount != 0 {
            CachingService.shared.checkLessonCompletion(id: courseId, lessonId: vcIndex, reflexCount: previousReflexCount) {[weak self] (flag) in
                if flag! == true{
                    self?.hideShowLessonTable(hidden: false)
                }
                else{
                    self?.hideShowLessonTable(hidden: true)
                }
            }
        }
    }
    
    func openSafari(link: String){
        if link == ""{
            let alert = presenter.getAlert()
            present(alert, animated: true, completion: nil)
        }
        else{
            let safariVC = SFSafariViewController(url: URL(string: link)!)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    func hideShowLessonTable(hidden: Bool){
        lockImageView = UIImageView(frame: CGRect(x: 150, y: 200, width: 70, height: 70))
        lockImageView.image = UIImage(systemName: "lock")
        lockImageView.tintColor = newButtonLabelColor
        lockLabel = UILabel(frame: CGRect(x: 20, y: 300, width: 300, height: 100))
        lockLabel.text = "Выполните все рефликсивные вопросы в предыдущем уроке, чтобы открыть этот"
        lockLabel.font = UIFont(name: "Jost-Medium", size: 16)
        lockLabel.numberOfLines = 0
        lockLabel.textColor = newButtonLabelColor
        view.addSubview(lockLabel)
        view.addSubview(lockImageView)
        lockLabel.isHidden = !hidden
        lockImageView.isHidden = !hidden
        elementsTableView.isHidden = hidden
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue, sender: sender)
    }

}

extension LessonsTableViewController: LessonsTableViewProtocol{
    func updateUI() {
        elementsTableView.reloadData()
    }
    
    func sendAlert(text: String) {
        print(text)
    }
}

extension LessonsTableViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            openSafari(link: presenter.getVideoLink(index: indexPath.row))
        case 1, 2:
            performSegue(withIdentifier: "showReflexQuestion", sender: LessonsTableInfo(courseId: courseId, vcIndex: indexPath, lessonIndex: vcIndex))
        default:
            print("Book showcase")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = presenter.getTitleText(index: section)
        label.font = UIFont(name: "Jost-Medium", size: 18)
        label.textColor = newButtonLabelColor
            
        headerView.addSubview(label)
            
        return headerView
        }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width + 20, height: 15))
        footerView.layer.cornerRadius = 15
        footerView.backgroundColor = UIColor(red: 245, green: 245, blue: 245)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.countRows(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.countSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LessonElementTableViewCell.identifier) as! LessonElementTableViewCell
        presenter.prepareCell(cell: cell, index: indexPath)
        cell.layoutMargins = UIEdgeInsets.zero
        //cell.hideSeparator()
        return cell
    }
}
