//
//  SingleTestViewCell.swift
//  PureMind
//
//  Created by Клим on 02.02.2022.
//

import UIKit

class SingleTestViewCell: UITableViewCell {
    
    static let identifier = "singleTestCell"
    var urlString = ""
    var testIndex: Int!
    weak var parentVc: PortraitViewController?

    @IBOutlet weak var linkButtonShell: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = newButtonLabelColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
        linkButtonShell.backgroundColor = newButtonLabelColor
        linkButtonShell.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func linkButtonPressed(_ sender: Any) {
        if testIndex < 7{
            parentVc?.performSegue(withIdentifier: "customTestSegue", sender: testIndex)
        }
        else{
            parentVc?.openSafari(link: urlString)
        }
    }
    

}
