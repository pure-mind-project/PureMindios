//
//  FirstQuestionsViewController.swift
//  PureMind
//
//  Created by Клим on 16.08.2021.
//

import UIKit

protocol FirstQuestionsViewProtocol: UIViewController{
    func updateUI()
    func setBackgroundColor(color: UIColor)
    func loadMood(mood: String)
    func loadQuestion(mood: String, questionTitle: String, questionDesc: String)
}

class FirstQuestionsViewController: UIViewController {
    var presenter: FirstQuestionsPresenterProtocol!
    var vcIndex: Int!
    
    @IBOutlet weak var moodTitleLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var questionDescLabel: UILabel!
    @IBOutlet weak var answersCollectionView: UICollectionView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backButtonShell: UIButton!
    var moodColor = UIColor(red: 0, green: 0, blue: 0)
    var totalScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        checkVCindex()
        prepareLabels()
        presenter.prepareView()
        vcIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func prepareLabels(){
        topView.layer.cornerRadius = 20
        moodTitleLabel.textColor = newButtonLabelColor
        questionTitleLabel.textColor = newButtonLabelColor
        questionDescLabel.textColor = newButtonLabelColor
        backButtonShell.tintColor = newButtonLabelColor
    }
    
    func checkVCindex(){
        if vcIndex > 0 {
            backButtonShell.isHidden = false
        }
    }
    
    func prepareCollectionView(){
        answersCollectionView.delegate = self
        answersCollectionView.dataSource = self
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue, sender: sender)
    }
    
    func inputOwnAnswer(index: IndexPath){
        let alert = UIAlertController(title: "Ваш ответ:", message: "", preferredStyle: .alert)
        
        let addlButton = UIAlertAction(title: "Добавить", style: .default){[weak self] (action) in
            let answer = alert.textFields![0].text!
            self?.presenter.manageCustomAnswer(answer: answer, index: index)
            let vc = ModuleBuilder().createMoodModuleOne(mood: (self?.presenter.currMood!)!, vcIndex: (self?.vcIndex)! + 1) as? FirstQuestionsViewController
            vc!.totalScore += 3
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addTextField{(field) in field.placeholder = "..."}
        alert.addAction(addlButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
}


extension FirstQuestionsViewController: FirstQuestionsViewProtocol{
    func loadQuestion(mood: String, questionTitle: String, questionDesc: String) {
        self.moodTitleLabel.text = mood
        self.questionTitleLabel.text = "Вопрос №\(vcIndex + 1)"
    }
    
    func loadMood(mood: String){
        moodTitleLabel.text = mood
    }
    
    func setBackgroundColor(color: UIColor){
        self.moodColor = color
        self.topView.backgroundColor = moodColor
    }
    
    func updateUI() {
        answersCollectionView.reloadData()
    }
}

extension FirstQuestionsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= presenter.getNumberOfItems(section: indexPath.section) - 1{
            inputOwnAnswer(index: indexPath)
        }
        else{
        guard let cell = answersCollectionView.dequeueReusableCell(withReuseIdentifier: AnswerViewCell.identifier, for: indexPath) as? AnswerViewCell
        else {fatalError("Invalid Cell kind")}
        cell.answerNotChosen = !cell.answerNotChosen
        cell.backgroundColor = moodColor
        presenter.manageAnswer(index: indexPath)
            if vcIndex < 2 {
                let vc = ModuleBuilder().createMoodModuleOne(mood: presenter.currMood!, vcIndex: vcIndex + 1) as? FirstQuestionsViewController
                vc?.totalScore = self.totalScore + presenter.calculateScore(index: indexPath)
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
            else{
                presenter.cacheCurrMood(moodScore: totalScore + presenter.calculateScore(index: indexPath))
                performSegue(withIdentifier: "moodSecondSegue", sender: presenter.currMood)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewTitle.identifier, for: indexPath) as? CollectionViewTitle{
            sectionHeader.titleLabel.text = ""
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter.getNumberOfSections()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getNumberOfItems(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = answersCollectionView.dequeueReusableCell(withReuseIdentifier: AnswerViewCell.identifier, for: indexPath) as? AnswerViewCell
        else {fatalError("Invalid Cell kind")}
        presenter.prepareCell(cell: cell, index: indexPath)
        return cell
    }
    
    
}
