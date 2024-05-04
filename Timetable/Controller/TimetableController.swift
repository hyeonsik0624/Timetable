//
//  TimetableController.swift
//  Timetable
//
//  Created by 진현식 on 3/23/24.
//

import UIKit
import TipKit

private let reuseIdentifier = "TimetableCell"

class TimetableController: UICollectionViewController {
    
    // MARK: - Properties

    private var viewModel = TimetableViewModel.shared
    
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
    
    private var editTimetableTip = EditTimetableTip()
    private var tipObservationTask: Task<Void, Never>?
    private weak var tipView: TipUIView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustUIForSmallDevices()
        configureCollectionView()
        configureUI()
        viewModel.loadTimetableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTip()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tipObservationTask?.cancel()
        tipObservationTask = nil
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(daysHeaderStack)
        daysHeaderStack.anchor(left: collectionView.leftAnchor, bottom: collectionView.topAnchor, right: collectionView.rightAnchor, paddingBottom: 5)
        
        view.addSubview(periodHeaderStack)
        periodHeaderStack.anchor(top: collectionView.topAnchor, bottom: collectionView.bottomAnchor, right: collectionView.leftAnchor, paddingRight: 3)
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
    
    func adjustUIForSmallDevices() {
        let screenHeight = UIScreen.main.bounds.size.height
        
        if screenHeight <= 667 {
            periodHeaderStack.isHidden = true
        }
    }
    
    func showTip() {
        do {
            try Tips.configure()
        } catch {
            return
        }
        
        tipObservationTask = tipObservationTask ?? Task { @MainActor in
            for await shouldDisplay in editTimetableTip.shouldDisplayUpdates {
                if shouldDisplay {
                    let tipHostingView = TipUIView(editTimetableTip)
                    tipHostingView.translatesAutoresizingMaskIntoConstraints = false
                    
                    view.addSubview(tipHostingView)
                    
                    tipHostingView.centerX(withView: view)
                    tipHostingView.anchor(bottom: daysHeaderStack.topAnchor, paddingBottom: 20)
                    tipHostingView.backgroundColor = .systemBackground
                    
                    tipView = tipHostingView
                }
                else {
                    tipView?.removeFromSuperview()
                    tipView = nil
                }
            }
        }
    }
}

// MARK: - CollectionViewDatasource / Delegate

extension TimetableController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(numberOfDays * numberOfPeriods)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let subjects = viewModel.getSubjects()
        let classrooms = viewModel.getClassrooms()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimetableCell
        cell.subjectLabel.text = subjects[indexPath.row]
        cell.classroomLabel.text = classrooms[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let subjects = viewModel.getSubjects()
        let classrooms = viewModel.getClassrooms()
        
        let editVC = EditTimetableController(index: indexPath.row, subject: subjects[indexPath.row], classroom: classrooms[indexPath.row])
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
            self.viewModel.loadTimetableData()
            self.collectionView.reloadData()
        }
    }
}
