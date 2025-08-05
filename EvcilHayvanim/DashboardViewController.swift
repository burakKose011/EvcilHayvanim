//
//  DashboardViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let welcomeLabel = UILabel()
    private let todayDateLabel = UILabel()
    
    private let healthSummaryCard = UIView()
    private let healthSummaryTitle = UILabel()
    private let healthSummaryContent = UILabel()
    
    private let upcomingAppointmentsCard = UIView()
    private let appointmentsTitle = UILabel()
    private let appointmentsTableView = UITableView()
    
    private let quickActionsCard = UIView()
    private let quickActionsTitle = UILabel()
    private let addPetButton = UIButton()
    private let addHealthRecordButton = UIButton()
    private let addAppointmentButton = UIButton()
    
    private let remindersCard = UIView()
    private let remindersTitle = UILabel()
    private let remindersTableView = UITableView()
    
    // MARK: - Properties
    private var upcomingAppointments: [Appointment] = []
    private var reminders: [Reminder] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadDashboardData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshDashboard()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Ana Sayfa"
        
        setupScrollView()
        setupWelcomeSection()
        setupHealthSummaryCard()
        setupUpcomingAppointmentsCard()
        setupQuickActionsCard()
        setupRemindersCard()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupWelcomeSection() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        todayDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        welcomeLabel.text = "Hoş Geldiniz!"
        welcomeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        welcomeLabel.textColor = .label
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        todayDateLabel.text = dateFormatter.string(from: Date())
        todayDateLabel.font = UIFont.systemFont(ofSize: 16)
        todayDateLabel.textColor = .secondaryLabel
        
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(todayDateLabel)
    }
    
    private func setupHealthSummaryCard() {
        healthSummaryCard.translatesAutoresizingMaskIntoConstraints = false
        healthSummaryTitle.translatesAutoresizingMaskIntoConstraints = false
        healthSummaryContent.translatesAutoresizingMaskIntoConstraints = false
        
        healthSummaryCard.backgroundColor = .systemBlue
        healthSummaryCard.layer.cornerRadius = 12
        
        healthSummaryTitle.text = "Sağlık Özeti"
        healthSummaryTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        healthSummaryTitle.textColor = .white
        
        healthSummaryContent.text = "Bugün 2 evcil hayvanınız için sağlık kontrolü var"
        healthSummaryContent.font = UIFont.systemFont(ofSize: 14)
        healthSummaryContent.textColor = .white
        healthSummaryContent.numberOfLines = 0
        
        contentView.addSubview(healthSummaryCard)
        healthSummaryCard.addSubview(healthSummaryTitle)
        healthSummaryCard.addSubview(healthSummaryContent)
    }
    
    private func setupUpcomingAppointmentsCard() {
        upcomingAppointmentsCard.translatesAutoresizingMaskIntoConstraints = false
        appointmentsTitle.translatesAutoresizingMaskIntoConstraints = false
        appointmentsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        upcomingAppointmentsCard.backgroundColor = .systemBackground
        upcomingAppointmentsCard.layer.cornerRadius = 12
        upcomingAppointmentsCard.layer.borderWidth = 1
        upcomingAppointmentsCard.layer.borderColor = UIColor.systemGray4.cgColor
        
        appointmentsTitle.text = "Yaklaşan Randevular"
        appointmentsTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        appointmentsTitle.textColor = .label
        
        appointmentsTableView.delegate = self
        appointmentsTableView.dataSource = self
        appointmentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AppointmentCell")
        appointmentsTableView.isScrollEnabled = false
        appointmentsTableView.backgroundColor = .clear
        
        contentView.addSubview(upcomingAppointmentsCard)
        upcomingAppointmentsCard.addSubview(appointmentsTitle)
        upcomingAppointmentsCard.addSubview(appointmentsTableView)
    }
    
    private func setupQuickActionsCard() {
        quickActionsCard.translatesAutoresizingMaskIntoConstraints = false
        quickActionsTitle.translatesAutoresizingMaskIntoConstraints = false
        addPetButton.translatesAutoresizingMaskIntoConstraints = false
        addHealthRecordButton.translatesAutoresizingMaskIntoConstraints = false
        addAppointmentButton.translatesAutoresizingMaskIntoConstraints = false
        
        quickActionsCard.backgroundColor = .systemBackground
        quickActionsCard.layer.cornerRadius = 12
        quickActionsCard.layer.borderWidth = 1
        quickActionsCard.layer.borderColor = UIColor.systemGray4.cgColor
        
        quickActionsTitle.text = "Hızlı İşlemler"
        quickActionsTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        quickActionsTitle.textColor = .label
        
        setupQuickActionButton(addPetButton, title: "Evcil Hayvan Ekle", icon: "plus.circle")
        setupQuickActionButton(addHealthRecordButton, title: "Sağlık Kaydı", icon: "heart")
        setupQuickActionButton(addAppointmentButton, title: "Randevu Ekle", icon: "calendar")
        
        contentView.addSubview(quickActionsCard)
        quickActionsCard.addSubview(quickActionsTitle)
        quickActionsCard.addSubview(addPetButton)
        quickActionsCard.addSubview(addHealthRecordButton)
        quickActionsCard.addSubview(addAppointmentButton)
    }
    
    private func setupQuickActionButton(_ button: UIButton, title: String, icon: String) {
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(systemName: icon), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        button.layer.cornerRadius = 8
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        
        button.addTarget(self, action: #selector(quickActionTapped(_:)), for: .touchUpInside)
    }
    
    private func setupRemindersCard() {
        remindersCard.translatesAutoresizingMaskIntoConstraints = false
        remindersTitle.translatesAutoresizingMaskIntoConstraints = false
        remindersTableView.translatesAutoresizingMaskIntoConstraints = false
        
        remindersCard.backgroundColor = .systemBackground
        remindersCard.layer.cornerRadius = 12
        remindersCard.layer.borderWidth = 1
        remindersCard.layer.borderColor = UIColor.systemGray4.cgColor
        
        remindersTitle.text = "Hatırlatmalar"
        remindersTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        remindersTitle.textColor = .label
        
        remindersTableView.delegate = self
        remindersTableView.dataSource = self
        remindersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReminderCell")
        remindersTableView.isScrollEnabled = false
        remindersTableView.backgroundColor = .clear
        
        contentView.addSubview(remindersCard)
        remindersCard.addSubview(remindersTitle)
        remindersCard.addSubview(remindersTableView)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Welcome Section
            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            todayDateLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 4),
            todayDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            todayDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Health Summary Card
            healthSummaryCard.topAnchor.constraint(equalTo: todayDateLabel.bottomAnchor, constant: 20),
            healthSummaryCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            healthSummaryCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            healthSummaryCard.heightAnchor.constraint(equalToConstant: 100),
            
            healthSummaryTitle.topAnchor.constraint(equalTo: healthSummaryCard.topAnchor, constant: 16),
            healthSummaryTitle.leadingAnchor.constraint(equalTo: healthSummaryCard.leadingAnchor, constant: 16),
            healthSummaryTitle.trailingAnchor.constraint(equalTo: healthSummaryCard.trailingAnchor, constant: -16),
            
            healthSummaryContent.topAnchor.constraint(equalTo: healthSummaryTitle.bottomAnchor, constant: 8),
            healthSummaryContent.leadingAnchor.constraint(equalTo: healthSummaryCard.leadingAnchor, constant: 16),
            healthSummaryContent.trailingAnchor.constraint(equalTo: healthSummaryCard.trailingAnchor, constant: -16),
            healthSummaryContent.bottomAnchor.constraint(equalTo: healthSummaryCard.bottomAnchor, constant: -16),
            
            // Upcoming Appointments Card
            upcomingAppointmentsCard.topAnchor.constraint(equalTo: healthSummaryCard.bottomAnchor, constant: 20),
            upcomingAppointmentsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            upcomingAppointmentsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            upcomingAppointmentsCard.heightAnchor.constraint(equalToConstant: 200),
            
            appointmentsTitle.topAnchor.constraint(equalTo: upcomingAppointmentsCard.topAnchor, constant: 16),
            appointmentsTitle.leadingAnchor.constraint(equalTo: upcomingAppointmentsCard.leadingAnchor, constant: 16),
            appointmentsTitle.trailingAnchor.constraint(equalTo: upcomingAppointmentsCard.trailingAnchor, constant: -16),
            
            appointmentsTableView.topAnchor.constraint(equalTo: appointmentsTitle.bottomAnchor, constant: 12),
            appointmentsTableView.leadingAnchor.constraint(equalTo: upcomingAppointmentsCard.leadingAnchor, constant: 16),
            appointmentsTableView.trailingAnchor.constraint(equalTo: upcomingAppointmentsCard.trailingAnchor, constant: -16),
            appointmentsTableView.bottomAnchor.constraint(equalTo: upcomingAppointmentsCard.bottomAnchor, constant: -16),
            
            // Quick Actions Card
            quickActionsCard.topAnchor.constraint(equalTo: upcomingAppointmentsCard.bottomAnchor, constant: 20),
            quickActionsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            quickActionsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            quickActionsCard.heightAnchor.constraint(equalToConstant: 180),
            
            quickActionsTitle.topAnchor.constraint(equalTo: quickActionsCard.topAnchor, constant: 16),
            quickActionsTitle.leadingAnchor.constraint(equalTo: quickActionsCard.leadingAnchor, constant: 16),
            quickActionsTitle.trailingAnchor.constraint(equalTo: quickActionsCard.trailingAnchor, constant: -16),
            
            addPetButton.topAnchor.constraint(equalTo: quickActionsTitle.bottomAnchor, constant: 12),
            addPetButton.leadingAnchor.constraint(equalTo: quickActionsCard.leadingAnchor, constant: 16),
            addPetButton.trailingAnchor.constraint(equalTo: quickActionsCard.trailingAnchor, constant: -16),
            addPetButton.heightAnchor.constraint(equalToConstant: 44),
            
            addHealthRecordButton.topAnchor.constraint(equalTo: addPetButton.bottomAnchor, constant: 8),
            addHealthRecordButton.leadingAnchor.constraint(equalTo: quickActionsCard.leadingAnchor, constant: 16),
            addHealthRecordButton.trailingAnchor.constraint(equalTo: quickActionsCard.trailingAnchor, constant: -16),
            addHealthRecordButton.heightAnchor.constraint(equalToConstant: 44),
            
            addAppointmentButton.topAnchor.constraint(equalTo: addHealthRecordButton.bottomAnchor, constant: 8),
            addAppointmentButton.leadingAnchor.constraint(equalTo: quickActionsCard.leadingAnchor, constant: 16),
            addAppointmentButton.trailingAnchor.constraint(equalTo: quickActionsCard.trailingAnchor, constant: -16),
            addAppointmentButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Reminders Card
            remindersCard.topAnchor.constraint(equalTo: quickActionsCard.bottomAnchor, constant: 20),
            remindersCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            remindersCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            remindersCard.heightAnchor.constraint(equalToConstant: 200),
            remindersCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            remindersTitle.topAnchor.constraint(equalTo: remindersCard.topAnchor, constant: 16),
            remindersTitle.leadingAnchor.constraint(equalTo: remindersCard.leadingAnchor, constant: 16),
            remindersTitle.trailingAnchor.constraint(equalTo: remindersCard.trailingAnchor, constant: -16),
            
            remindersTableView.topAnchor.constraint(equalTo: remindersTitle.bottomAnchor, constant: 12),
            remindersTableView.leadingAnchor.constraint(equalTo: remindersCard.leadingAnchor, constant: 16),
            remindersTableView.trailingAnchor.constraint(equalTo: remindersCard.trailingAnchor, constant: -16),
            remindersTableView.bottomAnchor.constraint(equalTo: remindersCard.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Data Loading
    private func loadDashboardData() {
        loadUpcomingAppointments()
        loadReminders()
    }
    
    private func loadUpcomingAppointments() {
        // TODO: Load from Core Data
        upcomingAppointments = []
        appointmentsTableView.reloadData()
    }
    
    private func loadReminders() {
        // TODO: Load from Core Data
        reminders = []
        remindersTableView.reloadData()
    }
    
    private func refreshDashboard() {
        loadDashboardData()
    }
    
    // MARK: - Actions
    @objc private func quickActionTapped(_ sender: UIButton) {
        switch sender {
        case addPetButton:
            let petFormVC = PetFormViewController()
            navigationController?.pushViewController(petFormVC, animated: true)
        case addHealthRecordButton:
            let healthRecordFormVC = HealthRecordFormViewController()
            navigationController?.pushViewController(healthRecordFormVC, animated: true)
        case addAppointmentButton:
            let appointmentFormVC = AppointmentFormViewController()
            navigationController?.pushViewController(appointmentFormVC, animated: true)
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == appointmentsTableView {
            return min(upcomingAppointments.count, 3)
        } else if tableView == remindersTableView {
            return min(reminders.count, 3)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableView == appointmentsTableView ? "AppointmentCell" : "ReminderCell", for: indexPath)
        
        if tableView == appointmentsTableView {
            if indexPath.row < upcomingAppointments.count {
                let appointment = upcomingAppointments[indexPath.row]
                        cell.textLabel?.text = "\(appointment.petName) - \(appointment.veterinarian)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, HH:mm"
        cell.detailTextLabel?.text = dateFormatter.string(from: appointment.date)
            }
        } else if tableView == remindersTableView {
            if indexPath.row < reminders.count {
                let reminder = reminders[indexPath.row]
                        cell.textLabel?.text = reminder.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, HH:mm"
        cell.detailTextLabel?.text = dateFormatter.string(from: reminder.date)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// Models are now defined in Models.swift 