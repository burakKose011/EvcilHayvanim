//
//  AppointmentsViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class AppointmentsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let segmentedControl = UISegmentedControl(items: ["Yaklaşan", "Geçmiş"])
    private let tableView = UITableView()
    private let addButton = UIButton()
    
    // MARK: - Properties
    private var upcomingAppointments: [Appointment] = []
    private var pastAppointments: [Appointment] = []
    private var currentAppointments: [Appointment] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadAppointments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAppointments()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Randevular"
        
        setupNavigationBar()
        setupSegmentedControl()
        setupTableView()
        setupAddButton()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addAppointmentTapped)
        )
    }
    
    private func setupSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        view.addSubview(segmentedControl)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AppointmentTableViewCell.self, forCellReuseIdentifier: "AppointmentCell")
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
    }
    
    private func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("+ Yeni Randevu", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 12
        addButton.addTarget(self, action: #selector(addAppointmentTapped), for: .touchUpInside)
        
        view.addSubview(addButton)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Data Loading
    private func loadAppointments() {
        // TODO: Load from Core Data
        upcomingAppointments = [
            Appointment(id: UUID(), petId: UUID(), petName: "Boncuk", date: Date().addingTimeInterval(24*60*60), veterinarian: "Dr. Ahmet Yılmaz", reason: "Kontrol", notes: "Genel sağlık kontrolü", status: .scheduled),
            Appointment(id: UUID(), petId: UUID(), petName: "Karabaş", date: Date().addingTimeInterval(3*24*60*60), veterinarian: "Dr. Ayşe Demir", reason: "Aşı", notes: "Kuduz aşısı", status: .scheduled)
        ]
        
        pastAppointments = [
            Appointment(id: UUID(), petId: UUID(), petName: "Boncuk", date: Date().addingTimeInterval(-7*24*60*60), veterinarian: "Dr. Mehmet Kaya", reason: "Tedavi", notes: "Kulak enfeksiyonu tedavisi", status: .completed),
            Appointment(id: UUID(), petId: UUID(), petName: "Maviş", date: Date().addingTimeInterval(-14*24*60*60), veterinarian: "Dr. Fatma Öz", reason: "Kontrol", notes: "Genel kontrol", status: .completed)
        ]
        
        updateCurrentAppointments()
    }
    
    private func updateCurrentAppointments() {
        currentAppointments = segmentedControl.selectedSegmentIndex == 0 ? upcomingAppointments : pastAppointments
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func addAppointmentTapped() {
        let appointmentFormVC = AppointmentFormViewController()
        let navController = UINavigationController(rootViewController: appointmentFormVC)
        present(navController, animated: true)
    }
    
    @objc private func segmentChanged() {
        updateCurrentAppointments()
    }
}

// MARK: - UITableViewDataSource
extension AppointmentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAppointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentTableViewCell
        let appointment = currentAppointments[indexPath.row]
        cell.configure(with: appointment)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AppointmentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let appointment = currentAppointments[indexPath.row]
        let appointmentDetailVC = AppointmentDetailViewController()
        appointmentDetailVC.appointment = appointment
        navigationController?.pushViewController(appointmentDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let appointment = currentAppointments[indexPath.row]
        
        var actions: [UIContextualAction] = []
        
        if appointment.status == .scheduled {
            let editAction = UIContextualAction(style: .normal, title: "Düzenle") { [weak self] (action, view, completion) in
                let appointmentFormVC = AppointmentFormViewController()
                appointmentFormVC.appointment = appointment
                let navController = UINavigationController(rootViewController: appointmentFormVC)
                self?.present(navController, animated: true)
                completion(true)
            }
            editAction.backgroundColor = .systemBlue
            actions.append(editAction)
            
            let cancelAction = UIContextualAction(style: .destructive, title: "İptal") { [weak self] (action, view, completion) in
                self?.showCancelAlert(for: appointment)
                completion(true)
            }
            actions.append(cancelAction)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completion) in
            self?.showDeleteAlert(for: indexPath)
            completion(true)
        }
        actions.append(deleteAction)
        
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    private func showCancelAlert(for appointment: Appointment) {
        let alert = UIAlertController(title: "Randevuyu İptal Et", message: "Bu randevuyu iptal etmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "İptal Et", style: .destructive) { [weak self] _ in
            self?.cancelAppointment(appointment)
        })
        
        present(alert, animated: true)
    }
    
    private func showDeleteAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Randevuyu Sil", message: "Bu randevuyu silmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
            let appointment = self?.currentAppointments[indexPath.row]
            self?.deleteAppointment(appointment)
        })
        
        present(alert, animated: true)
    }
    
    private func cancelAppointment(_ appointment: Appointment) {
        // TODO: Update in Core Data
        print("Appointment cancelled: \(appointment.id)")
        
        let alert = UIAlertController(title: "Başarılı", message: "Randevu iptal edildi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func deleteAppointment(_ appointment: Appointment?) {
        guard let appointment = appointment else { return }
        
        // TODO: Delete from Core Data
        if let index = upcomingAppointments.firstIndex(where: { $0.id == appointment.id }) {
            upcomingAppointments.remove(at: index)
        }
        if let index = pastAppointments.firstIndex(where: { $0.id == appointment.id }) {
            pastAppointments.remove(at: index)
        }
        
        updateCurrentAppointments()
    }
}

// MARK: - AppointmentTableViewCell
class AppointmentTableViewCell: UITableViewCell {
    
    private let dateLabel = UILabel()
    private let petNameLabel = UILabel()
    private let veterinarianLabel = UILabel()
    private let reasonLabel = UILabel()
    private let statusLabel = UILabel()
    private let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        petNameLabel.translatesAutoresizingMaskIntoConstraints = false
        veterinarianLabel.translatesAutoresizingMaskIntoConstraints = false
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        dateLabel.textColor = .label
        
        petNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        petNameLabel.textColor = .systemBlue
        
        veterinarianLabel.font = UIFont.systemFont(ofSize: 14)
        veterinarianLabel.textColor = .secondaryLabel
        
        reasonLabel.font = UIFont.systemFont(ofSize: 14)
        reasonLabel.textColor = .label
        
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 8
        
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .tertiaryLabel
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(petNameLabel)
        contentView.addSubview(veterinarianLabel)
        contentView.addSubview(reasonLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            
            petNameLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            petNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            petNameLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            
            veterinarianLabel.topAnchor.constraint(equalTo: petNameLabel.bottomAnchor, constant: 2),
            veterinarianLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            veterinarianLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            
            reasonLabel.topAnchor.constraint(equalTo: veterinarianLabel.bottomAnchor, constant: 2),
            reasonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reasonLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            reasonLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusLabel.widthAnchor.constraint(equalToConstant: 80),
            statusLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with appointment: Appointment) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        dateLabel.text = dateFormatter.string(from: appointment.date)
        
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: appointment.date)
        
        petNameLabel.text = appointment.petName
        veterinarianLabel.text = appointment.veterinarian
        reasonLabel.text = appointment.reason
        
        switch appointment.status {
        case .scheduled:
            statusLabel.text = "Planlandı"
            statusLabel.backgroundColor = .systemBlue.withAlphaComponent(0.1)
            statusLabel.textColor = .systemBlue
        case .completed:
            statusLabel.text = "Tamamlandı"
            statusLabel.backgroundColor = .systemGreen.withAlphaComponent(0.1)
            statusLabel.textColor = .systemGreen
        case .cancelled:
            statusLabel.text = "İptal"
            statusLabel.backgroundColor = .systemRed.withAlphaComponent(0.1)
            statusLabel.textColor = .systemRed
        }
    }
}

// Models are now defined in Models.swift 