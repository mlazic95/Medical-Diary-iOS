//
//  StatsTableViewCell.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-07.
//

import UIKit

class StatsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    var delegate: StatsCellDelegate?
    var dataType: Data?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func cellTapped() {
        delegate?.cellPressed(dataType: dataType!, label: self.title.text!)
    }
    
}
