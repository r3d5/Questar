//
//  QuestCell.swift
//  Mementar
//
//  Created by d3pr3ss3r on 09.09.2022.
//

import UIKit


class QuestStepCell: UICollectionViewCell {
    @IBOutlet weak var stepSequence: UILabel!
    @IBOutlet weak var stepDescription: UILabel!
    @IBOutlet weak var stepImageTarget: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Apply rounded corners
     
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 5.0
        layer.masksToBounds = false
    }
    
    func customize(with data: QuestStep) {
        stepSequence.text = String(data.sequenceNumber)
//        stepDescription.text = data.stepDescription
        stepImageTarget.image = data.stepImageTarget
    }
}
