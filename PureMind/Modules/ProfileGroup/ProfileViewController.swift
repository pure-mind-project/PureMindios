//
//  ProfileViewController.swift
//  PureMind
//
//  Created by Клим on 17.08.2021.
//

import UIKit

protocol ProfileViewProtocol: UIViewController{
    func updateUI()
}

class ProfileViewController: UIViewController {
    var presenter: ProfilePresenterProtocol!
    
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var topView: UIView!
    var imageView: UIImageView = {
            let imageView = UIImageView(frame: .zero)
            imageView.image = UIImage(named: "background12")
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func prepareTableView(){
        view.insertSubview(imageView, at: 0)
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: view.topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        personLabel.textColor = newButtonLabelColor
        topView.backgroundColor = .white
        topView.layer.cornerRadius = 20
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.tableFooterView = UIView()
    }
    
    func itsRewindTime(){
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(ModuleBuilder().createWelcomeModuleReturnee(), animated: true)
    }
    
    func alert(text: String){
        let alert = UIAlertController(title: "Внимание", message: text, preferredStyle: .alert)
        
        let noButton = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let okButton = UIAlertAction(title: "Да", style: .default){_ in
            CachingService.shared.getInfo {[weak self] (result) in
                CachingService.shared.deleteUserInfo()
                self?.itsRewindTime()
            }
        }
        
        if text == "Вы уверены, что хотите удалить учетную запись? Ваши данные будут безвозвратно потеряны"{
            NetworkService.shared.deleteAccount {(result) in
                print("ACCOUNT WAS DELETED")
            }
        }
        
        alert.addAction(okButton)
        alert.addAction(noButton)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue, sender: sender)
    }

}

extension ProfileViewController: ProfileViewProtocol{
    func updateUI() {
        optionsTableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showPortraitSegue", sender: nil)
        case 1:
            performSegue(withIdentifier: "showAlertContacts", sender: nil)
        case 2:
            performSegue(withIdentifier: "showContactsSegue", sender: nil)
        case 3:
            performSegue(withIdentifier: "policiesShortSegueSecond", sender: nil)
        case 4:
            performSegue(withIdentifier: "showCreatorsSegue", sender: nil)
        case 5:
            performSegue(withIdentifier: "showShareSegue", sender: nil)
        case 6:
           alert(text: "Вы уверены, что хотите выйти из учетной записи?")
        case 7:
            alert(text: "Вы уверены, что хотите удалить учетную запись? Ваши данные будут безвозвратно потеряны")
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.optionsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewCell.identifier) as? ProfileViewCell
        else { fatalError("invalid cell kind")}
        presenter.prepareCell(cell: cell, index: indexPath.row)
        return cell
    }
}
