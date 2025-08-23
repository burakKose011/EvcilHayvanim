//
//  AppointmentDetailViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class AppointmentDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let statusLabel = UILabel()
    private let dateLabel = UILabel()
    private let petNameLabel = UILabel()
    private let veterinarianLabel = UILabel()
    private let reasonLabel = UILabel()
    private let notesLabel = UILabel()
    
    private let editButton = UIButton()
    private let cancelButton = UIButton()
    private let deleteButton = UIButton()
    
    // MARK: - Properties
    var appointment: AppointmentModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadAppointmentData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Randevu Detayı"
        
        setupNavigationBar()
        setupScrollView()
        setupLabels()
        setupButtons()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(editTapped)
        )
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupLabels() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        petNameLabel.translatesAutoresizingMaskIntoConstraints = false
        veterinarianLabel.translatesAutoresizingMaskIntoConstraints = false
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 8
        
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = .secondaryLabel
        
        petNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        petNameLabel.textColor = .systemBlue
        
        veterinarianLabel.font = UIFont.systemFont(ofSize: 16)
        veterinarianLabel.textColor = .secondaryLabel
        
        reasonLabel.font = UIFont.systemFont(ofSize: 16)
        reasonLabel.textColor = .label
        reasonLabel.numberOfLines = 0
        
        notesLabel.font = UIFont.systemFont(ofSize: 16)
        notesLabel.textColor = .label
        notesLabel.numberOfLines = 0
        
        contentView.addSubview(statusLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(petNameLabel)
        contentView.addSubview(veterinarianLabel)
        contentView.addSubview(reasonLabel)
        contentView.addSubview(notesLabel)
    }
    
    private func setupButtons() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        editButton.setTitle("Düzenle", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        editButton.backgroundColor = .systemBlue
        editButton.layer.cornerRadius = 12
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        
        cancelButton.setTitle("İptal Et", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cancelButton.backgroundColor = .systemOrange
        cancelButton.layer.cornerRadius = 12
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        deleteButton.setTitle("Sil", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        deleteButton.backgroundColor = .systemRed
        deleteButton.layer.cornerRadius = 12
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        contentView.addSubview(editButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(deleteButton)
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
            
            // Labels
            statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusLabel.heightAnchor.constraint(equalToConstant: 40),
            
            dateLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            petNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            petNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            petNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            veterinarianLabel.topAnchor.constraint(equalTo: petNameLabel.bottomAnchor, constant: 8),
            veterinarianLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            veterinarianLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            reasonLabel.topAnchor.constraint(equalTo: veterinarianLabel.bottomAnchor, constant: 20),
            reasonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reasonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            notesLabel.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: 20),
            notesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            notesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Buttons
            editButton.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 30),
            editButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 12),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Loading
    private func loadAppointmentData() {
        guard let appointment = appointment else { return }
        
        // Set status
        switch appointment.status {
        case .scheduled:
            statusLabel.text = "Planlandı"
            statusLabel.backgroundColor = .systemBlue.withAlphaComponent(0.1)
            statusLabel.textColor = .systemBlue
            cancelButton.isHidden = false
        case .completed:
            statusLabel.text = "Tamamlandı"
            statusLabel.backgroundColor = .systemGreen.withAlphaComponent(0.1)
            statusLabel.textColor = .systemGreen
            cancelButton.isHidden = true
        case .cancelled:
            statusLabel.text = "İptal"
            statusLabel.backgroundColor = .systemRed.withAlphaComponent(0.1)
            statusLabel.textColor = .systemRed
            cancelButton.isHidden = true
        }
        
        // Set date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy, HH:mm"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateLabel.text = dateFormatter.string(from: appointment.appointmentDate)
        
        petNameLabel.text = appointment.petName
        veterinarianLabel.text = "Veteriner: \(appointment.veterinarian)"
        reasonLabel.text = "Sebep: \(appointment.reason)"
        
        if let notes = appointment.notes {
            notesLabel.text = "Notlar: \(notes)"
        } else {
            notesLabel.text = "Not yok"
        }
    }
    
    // MARK: - Actions
    @objc private func editTapped() {
        let appointmentFormVC = AppointmentFormViewController()
        appointmentFormVC.appointment = appointment
        let navController = UINavigationController(rootViewController: appointmentFormVC)
        present(navController, animated: true)
    }
    
    @objc private func cancelTapped() {
        let alert = UIAlertController(title: "Randevuyu İptal Et", message: "Bu randevuyu iptal etmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "İptal Et", style: .destructive) { [weak self] _ in
            self?.cancelAppointment()
        })
        
        present(alert, animated: true)
    }
    
    @objc private func deleteTapped() {
        let alert = UIAlertController(title: "Randevuyu Sil", message: "Bu randevuyu silmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
            self?.deleteAppointment()
        })
        
        present(alert, animated: true)
    }
    
    private func cancelAppointment() {
        // TODO: Update in Core Data
        print("Appointment cancelled: \(appointment?.reason ?? "")")
        
        let alert = UIAlertController(title: "Başarılı", message: "Randevu iptal edildi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    private func deleteAppointment() {
        // TODO: Delete from Core Data
        print("Appointment deleted: \(appointment?.reason ?? "")")
        
        let alert = UIAlertController(title: "Başarılı", message: "Randevu silindi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
} 
