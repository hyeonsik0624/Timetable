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
    
    let classroomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "3-2"
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
        
//        addSubview(subjectLabel)
//        subjectLabel.centerX(withView: self)
//        subjectLabel.centerY(withView: self)
//        
//        addSubview(classroomLabel)
//        classroomLabel.anchor(top: subjectLabel.bottomAnchor)
//        classroomLabel.centerX(withView: subjectLabel)
        
        let stack = UIStackView(arrangedSubviews: [subjectLabel, classroomLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 0
        
        addSubview(stack)
        stack.centerX(withView: self)
        stack.centerY(withView: self)
    }
}
