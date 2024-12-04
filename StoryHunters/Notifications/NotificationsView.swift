//
//  NotificationsView.swift
//  StoryHunters
//
//  Created by Dimiar Ilev on 03.12.24.
//

import UIKit

class NotificationsView: UIView {
    let tableViewNotifications: UITableView

    override init(frame: CGRect) {
        tableViewNotifications = UITableView(frame: .zero, style: .plain)
        super.init(frame: frame)
        
        tableViewNotifications.register(NotificationCell.self, forCellReuseIdentifier: "notificationCell")
        tableViewNotifications.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tableViewNotifications)
        NSLayoutConstraint.activate([
            tableViewNotifications.topAnchor.constraint(equalTo: topAnchor),
            tableViewNotifications.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableViewNotifications.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableViewNotifications.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


