//
//  TimetableController.swift
//  Timetable
//
//  Created by 진현식 on 3/23/24.
//

import UIKit

private let reuseIdentifier = "TimetableCell"

class TimetableController: UICollectionViewController {
    
    // MARK: - Properties

    private var subjects = [String]()
    
    private var classrooms = [String]() {
        didSet { collectionView.reloadData() }
    }
    
    private let numberOfDays: CGFloat = 5
    private let numberOfPeriods: CGFloat = 7
    
    private let cellWidth: CGFloat = 70
    private let cellHeigt: CGFloat = 70
    
    private lazy var daysHeaderStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [makeHeaderLabel("월"), makeHeaderLabel("화"), makeHeaderLabel("수"), makeHeaderLabel("목"), makeHeaderLabel("금")])
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    private lazy var periodHeaderStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [makeHeaderLabel("1"), makeHeaderLabel("2"), makeHeaderLabel("3"), makeHeaderLabel("4"), makeHeaderLabel("5"), makeHeaderLabel("6"), makeHeaderLabel("7")])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        loadTimetableData()
    }
    
    // MARK: - Helpers
    
    func loadTimetableData() {
        var subjects = [String]()
        var classrooms = [String]()
        
        for i in 1...5 {
            subjects.append(contentsOf: UserDefaults.appGroupUserDefaults?.array(forKey: "subjects:\(i)") as! [String])
            classrooms.append(contentsOf: UserDefaults.appGroupUserDefaults?.array(forKey: "classrooms:\(i)") as? [String] ?? [])
        }
        
        self.subjects = subjects
        self.classrooms = classrooms
    }
    
    func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(daysHeaderStack)
        daysHeaderStack.anchor(left: collectionView.leftAnchor, bottom: collectionView.topAnchor, right: collectionView.rightAnchor, paddingBottom: 5)
        
        view.addSubview(periodHeaderStack)
        periodHeaderStack.anchor(top: collectionView.topAnchor, left: view.leftAnchor, bottom: collectionView.bottomAnchor, paddingLeft: 4)
    }
    
    func configureCollectionView() {
        collectionView.register(TimetableCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let width = cellWidth * numberOfDays + numberOfDays
        let height = cellHeigt * numberOfPeriods + numberOfPeriods
        collectionView.setDimension(width: width, height: height)
        collectionView.centerX(withView: view)
        collectionView.centerY(withView: view)
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.scrollDirection = .horizontal
    }
    
    func makeHeaderLabel(_ day: String) -> UILabel {
        let label = UILabel()
        label.text = day
        label.textAlignment = .center
        return label
    }
}

// MARK: - CollectionViewDatasource / Delegate

extension TimetableController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(numberOfDays * numberOfPeriods)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimetableCell
        cell.subjectLabel.text = subjects[indexPath.row]
        cell.classroomLabel.text = classrooms[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let subject = subjects[indexPath.row]
        let classroom = classrooms[indexPath.row]
        
        let editVC = EditTimetableController(index: indexPath.row, subject: subject, classroom: classroom)
        let nav = UINavigationController(rootViewController: editVC)
        editVC.delegate = self
        present(nav, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TimetableController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: cellHeigt)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

// MARK: - EditTimetableControllerDelegate

extension TimetableController: EditTimetableControllerDelegate {
    func didFinishEditingTimetable(_ controller: EditTimetableController) {
        controller.dismiss(animated: true) {
            self.loadTimetableData()
            self.collectionView.reloadData()
        }
    }
}
