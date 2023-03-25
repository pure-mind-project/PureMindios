//
//  DiaryPresenter.swift
//  PureMind
//
//  Created by Клим on 11.07.2022.
//

import UIKit

protocol DiaryPresenterProtocol{
    init(view: DiaryViewProtocol, eveningDiaryService: EveningDiaryServiceManagerProtocol, morningDiaryService: MorningDiaryServiceManagerProtocol)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func prepareCell(cell: DiaryNoteCollectionViewCell, index: Int)
    func getData()
    func notesCount() -> Int
}

class DiaryPresenter: DiaryPresenterProtocol{
    weak var view: DiaryViewProtocol?
    var eveningDiaryService: EveningDiaryServiceManagerProtocol
    var morningDiaryService: MorningDiaryServiceManagerProtocol

    var notes = [DiaryNote]()
    let dateFormatter = DateFormatter()
    
    required init(view: DiaryViewProtocol, eveningDiaryService: EveningDiaryServiceManagerProtocol, morningDiaryService: MorningDiaryServiceManagerProtocol) {
        self.view = view
        self.morningDiaryService = morningDiaryService
        self.eveningDiaryService = eveningDiaryService
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showMultipleDiarySegue":
            guard let vc = segue.destination as? MultipleChoiceDiaryViewController
            else {fatalError("invalid data passed")}
            vc.presenter = MultipleChoiceDiaryPresenter(view: vc, vcIndex: 0, eveningDiaryService: eveningDiaryService, morningDiaryService: morningDiaryService)
        default:
            break
        }
    }
    
    func prepareCell(cell: DiaryNoteCollectionViewCell, index: Int) {
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let note = notes[index]
        let date = NSDate(timeIntervalSince1970: TimeInterval(note.date))
        let stringDate = dateFormatter.string(from: date as Date)
        cell.dateLabel.text = stringDate
        cell.textLabel.text = note.text
        cell.titleLabel.text = note.theme
        cell.backgroundColor = UIColor(red: 248, green: 232, blue: 187)
        cell.dateLabel.textColor = grayTextColor.withAlphaComponent(0.46)
        cell.textLabel.textColor = newButtonLabelColor
        cell.titleLabel.textColor = newButtonLabelColor
        cell.layer.cornerRadius = 20
    }
    
    func notesCount() -> Int {
        return notes.count
    }
    
    func getData() {
        CachingService.shared.getAllDiaryNotes { [weak self] (result) in
            self?.notes = result
            self?.view?.updateUI()
        }
    }
    
    
}
