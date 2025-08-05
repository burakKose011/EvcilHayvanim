//
//  HealthRecordDetailViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class HealthRecordDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let typeLabel = UILabel()
    private let dateLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let veterinarianLabel = UILabel()
    private let notesLabel = UILabel()
    
    private let editButton = UIButton()
    private let deleteButton = UIButton()
    
    // MARK: - Properties
    var healthRecord: HealthRecord?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadHealthRecordData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Sağlık Kaydı Detayı"
        
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
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        veterinarianLabel.translatesAutoresizingMaskIntoConstraints = false
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        typeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        typeLabel.textColor = .label
        
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = .secondaryLabel
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 0
        
        veterinarianLabel.font = UIFont.systemFont(ofSize: 16)
        veterinarianLabel.textColor = .secondaryLabel
        
        notesLabel.font = UIFont.systemFont(ofSize: 16)
        notesLabel.textColor = .label
        notesLabel.numberOfLines = 0
        
        contentView.addSubview(typeLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(veterinarianLabel)
        contentView.addSubview(notesLabel)
    }
    
    private func setupButtons() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        editButton.setTitle("Düzenle", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        editButton.backgroundColor = .systemBlue
        editButton.layer.cornerRadius = 12
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        
        deleteButton.setTitle("Sil", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        deleteButton.backgroundColor = .systemRed
        deleteButton.layer.cornerRadius = 12
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        contentView.addSubview(editButton)
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
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            veterinarianLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            veterinarianLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            veterinarianLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            notesLabel.topAnchor.constraint(equalTo: veterinarianLabel.bottomAnchor, constant: 20),
            notesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            notesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Buttons
            editButton.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 30),
            editButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 12),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Loading
    private func loadHealthRecordData() {
        guard let healthRecord = healthRecord else { return }
        
        typeLabel.text = healthRecord.type.rawValue
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy, HH:mm"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateLabel.text = dateFormatter.string(from: healthRecord.date)
        
        descriptionLabel.text = healthRecord.description
        
        if let veterinarian = healthRecord.veterinarian {
            veterinarianLabel.text = "Veteriner: \(veterinarian)"
        } else {
            veterinarianLabel.text = "Veteriner: Belirtilmemiş"
        }
        
        if !healthRecord.attachments.isEmpty {
            notesLabel.text = "Ekler: \(healthRecord.attachments.count) dosya"
        } else {
            notesLabel.text = "Ek dosya yok"
        }
    }
    
    // MARK: - Actions
    @objc private func editTapped() {
        let healthRecordFormVC = HealthRecordFormViewController()
        healthRecordFormVC.healthRecord = healthRecord
        let navController = UINavigationController(rootViewController: healthRecordFormVC)
        present(navController, animated: true)
    }
    
    @objc private func deleteTapped() {
        let alert = UIAlertController(title: "Sağlık Kaydını Sil", message: "Bu sağlık kaydını silmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
            self?.deleteHealthRecord()
        })
        
        present(alert, animated: true)
    }
    
    private func deleteHealthRecord() {
        // TODO: Delete from Core Data
        print("Health record deleted: \(healthRecord?.description ?? "")")
        
        let alert = UIAlertController(title: "Başarılı", message: "Sağlık kaydı silindi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
} 