//
//  File.swift
//  Calculator
//
//  Created by 岩渕優児 on 2021/07/16.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    override var isHighlighted: Bool{
        didSet {
            if isHighlighted {
                self.numberlabel.alpha = 0.4
            }else{
                self.numberlabel.alpha = 1
            }
        }
    }
    
    
    let numberlabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "1"
        label.font = .boldSystemFont(ofSize: 32)
        label.clipsToBounds = true
        label.backgroundColor = .systemGreen
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(numberlabel)
        numberlabel.frame.size = self.frame.size
        numberlabel.layer.cornerRadius = self.frame.height / 20
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
