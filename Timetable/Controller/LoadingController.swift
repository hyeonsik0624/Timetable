//
//  LoadingController.swift
//  Timetable
//
//  Created by 진현식 on 3/24/24.
//

import UIKit

class LoadingController: UIViewController {
    
    // MARK: - Properties
    
    private let activityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureIndicator()
        checkIfDataExists()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(activityIndicatorView)
    }
    
    func configureIndicator() {
        activityIndicatorView.style = .large
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
    }
    
    func checkIfDataExists() {
        if UserDefaults.standard.array(forKey: "classrooms:5") != nil {
            showController(TimetableController(collectionViewLayout: UICollectionViewFlowLayout()))
        } else {
            showController(SetupTimetableController())
        }
    }
    
    func showController(_ controller: UIViewController) {
        DispatchQueue.main.async {
            let controller = controller
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true)
        }
    }
}
