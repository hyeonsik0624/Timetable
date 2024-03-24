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

    private var timetable = [String]() {
        didSet { collectionView.reloadData() }
    }
    
    private let numberOfDays: CGFloat = 5
    private let numberOfClasses: CGFloat = 7
    
    private let cellWidth: CGFloat = 70
    private let cellHeigt: CGFloat = 70
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        loadTimetableData()
    }
    
    // MARK: - Helpers
    
    func loadTimetableData() {
        self.timetable.append(contentsOf: UserDefaults.standard.array(forKey: "1") as! [String])
        self.timetable.append(contentsOf: UserDefaults.standard.array(forKey: "2") as! [String])
        self.timetable.append(contentsOf: UserDefaults.standard.array(forKey: "3") as! [String])
        self.timetable.append(contentsOf: UserDefaults.standard.array(forKey: "4") as! [String])
        self.timetable.append(contentsOf: UserDefaults.standard.array(forKey: "5") as! [String])
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView.register(TimetableCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let width = cellWidth * numberOfDays + numberOfDays
        let height = cellHeigt * numberOfClasses + numberOfClasses
        collectionView.setDimension(width: width, height: height)
        collectionView.centerX(withView: view)
        collectionView.centerY(withView: view)
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.scrollDirection = .horizontal
    }
}

// MARK: - CollectionViewDatasource / Delegate

extension TimetableController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(numberOfDays * numberOfClasses)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimetableCell
        cell.subjectLabel.text = timetable[indexPath.row]
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
