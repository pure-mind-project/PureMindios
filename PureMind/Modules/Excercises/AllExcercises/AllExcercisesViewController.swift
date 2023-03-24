//
//  AllExcercisesViewController.swift
//  PureMind
//
//  Created by Клим on 03.01.2022.
//

protocol AllExcerciseViewProtocol: UIViewController{
    func updateUI()
    func failedToLoad()
    func practicChosen(practiceID: String, exerciseNumber: Int)
}

import UIKit
import ExpyTableView

class AllExcercisesViewController: UIViewController {
    var presenter: AllExcercisePresenterProtocol!
    
    @IBOutlet weak var titleLbael: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backButtonShell: UIButton!
    @IBOutlet weak var practicsTableView: ExpyTableView!
    @IBOutlet weak var topView: UIView!
    
    var backHidden = false
    var imageView: UIImageView = {
            let imageView = UIImageView(frame: .zero)
            imageView.image = UIImage(named: "background14")
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
        prepareViews()
        if backHidden == true{
            backButtonShell.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imageView.isHidden = true
    }
    
    @objc func handleGesture(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.isHidden = false
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        practicsTableView.reloadData()
    }
    
    func prepareViews(){
        view.insertSubview(imageView, at: 0)
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: view.topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        descriptionLabel.textColor = newButtonLabelColor
        titleLbael.textColor = newButtonLabelColor
        topView.layer.cornerRadius = 20
        topView.backgroundColor = UIColor(patternImage: UIImage(named: "background14")!)
        topView.layer.borderColor = newButtonLabelColor.cgColor
        topView.layer.borderWidth = 1
        prepareTableView()
    }
    
    func prepareTableView(){
        practicsTableView.separatorStyle = .none
        practicsTableView.delegate = self
        practicsTableView.dataSource = self
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func alert(){
        let alert = UIAlertController(title: "Ошибка", message: "Проверьте ваше соединение с интернетом", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Oк", style: .cancel, handler: nil)
        alert.addAction(okButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue, sender: sender)
    }
    
}

extension AllExcercisesViewController: AllExcerciseViewProtocol{
    func updateUI() {
        practicsTableView?.reloadData()
    }
    
    func failedToLoad() {
        alert()
        navigationController?.popViewController(animated: true)
    }
    
    func practicChosen(practiceID: String, exerciseNumber: Int){
        performSegue(withIdentifier: "practicChosenSegue", sender: [practiceID, exerciseNumber.description])
    }
}

extension AllExcercisesViewController: ExpyTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.countData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        /*
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
         */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExcercisesViewCell.identifier) as! ExcercisesViewCell
        presenter.prepareCell(cell: cell, index: indexPath.section)
        cell.layoutMargins = UIEdgeInsets.zero
        cell.hideSeparator()
        return cell
    }
    
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpPracticViewCell.identifier) as! ExpPracticViewCell
        cell.titleLabel.text = presenter.getTitleText(index: section)
        cell.layoutMargins = UIEdgeInsets.zero
        cell.showSeparator()
        return cell
    }
}

extension AllExcercisesViewController: ExpyTableViewDelegate {
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
    
        switch state {
        case .willExpand:
            print("WILL EXPAND")
            
        case .willCollapse:
            print("WILL COLLAPSE")
            
        case .didExpand:
            print("DID EXPAND")
            
        case .didCollapse:
            print("DID COLLAPSE")
        }
    }
}

extension AllExcercisesViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
