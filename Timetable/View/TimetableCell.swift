//
//  TimetableCell.swift
//  Timetable
//
//  Created by 진현식 on 3/23/24.
//

import UIKit

class TimetableCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .systemGray5
        
        addSubview(subjectLabel)
        subjectLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
}
