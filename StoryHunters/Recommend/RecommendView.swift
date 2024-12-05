//
//  RecommendView.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/3/24.
//

import UIKit

class RecommendView: UIView {
    var segmentedControl: UISegmentedControl!
    var tableView: UITableView!
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSegmentedControl()
        setupRecommendationsTable()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: ["Outgoing", "Incoming"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(segmentedControl)
        
        let font = UIFont.systemFont(ofSize: 14)
        segmentedControl.setTitleTextAttributes([.font: font], for: .normal)
    }
    
    func setupRecommendationsTable() {
        tableView = UITableView()
        tableView.register(RecommendationsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewRecsID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
    }
    
    func initConstraints() {
        
        NSLayoutConstraint.activate([
            // Adjusted constraints for the segmented control
            segmentedControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
            segmentedControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),  
            segmentedControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            // Table view constraints
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
