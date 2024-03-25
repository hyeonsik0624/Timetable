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
        let mon = makeHeaderLabel("월")
        let tue = makeHeaderLabel("화")
        let wed = makeHeaderLabel("수")
        let thu = makeHeaderLabel("목")
        let fri = makeHeaderLabel("금")
        
        let stack = UIStackView(arrangedSubviews: [mon, tue, wed, thu, fri])
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    private lazy var periodHeaderStack: UIStackView = {
        let first = makeHeaderLabel("1")
        let second = makeHeaderLabel("2")
        let third = makeHeaderLabel("3")
        let fourth = makeHeaderLabel("4")
        let fifth = makeHeaderLabel("5")
        let sixth = makeHeaderLabel("6")
        let seventh = makeHeaderLabel("7")
        
        let stack = UIStackView(arrangedSubviews: [first, second, third, fourth, fifth, sixth, seventh])
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
        self.subjects.append(contentsOf: UserDefaults.standard.array(forKey: "subjects:1") as! [String])
        self.subjects.append(contentsOf: UserDefaults.standard.array(forKey: "subjects:2") as! [String])
        self.subjects.append(contentsOf: UserDefaults.standard.array(forKey: "subjects:3") as! [String])
        self.subjects.append(contentsOf: UserDefaults.standard.array(forKey: "subjects:4") as! [String])
        self.subjects.append(contentsOf: UserDefaults.standard.array(forKey: "subjects:5") as! [String])
        
        self.classrooms.append(contentsOf: UserDefaults.standard.array(forKey: "classrooms:1") as! [String])
        self.classrooms.append(contentsOf: UserDefaults.standard.array(forKey: "classrooms:2") as! [String])
        self.classrooms.append(contentsOf: UserDefaults.standard.array(forKey: "classrooms:3") as! [String])
        self.classrooms.append(contentsOf: UserDefaults.standard.array(forKey: "classrooms:4") as! [String])
        self.classrooms.append(contentsOf: UserDefaults.standard.array(forKey: "classrooms:5") as! [String])
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
