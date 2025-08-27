//
//  HealthRecordFormViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class HealthRecordFormViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerView = UIView()
    private let headerIconView = UIImageView()
    private let headerTitleLabel = UILabel()
    private let headerSubtitleLabel = UILabel()
    
    private let recordTypeCard = UIView()
    private let recordTypeButton = UIButton()
    private let recordTypeIconView = UIImageView()
    
    private let petSelectionCard = UIView()
    private let petSelectionButton = UIButton()
    private let petSelectionIconView = UIImageView()
    private let selectedPetLabel = UILabel()
    
    private let descriptionCard = UIView()
    private let descriptionTextField = UITextField()
    private let descriptionIconView = UIImageView()
    
    private let veterinarianCard = UIView()
    private let veterinarianTextField = UITextField()
    private let veterinarianIconView = UIImageView()
    
    private let dateCard = UIView()
    private let datePicker = UIDatePicker()
    private let dateIconView = UIImageView()
    private let dateTitleLabel = UILabel()
    
    private let notesCard = UIView()
    private let notesTextView = UITextView()
    private let notesIconView = UIImageView()
    private let notesTitleLabel = UILabel()
    
    private let saveButton = UIButton()
    
    // MARK: - Properties
    var pet: PetModel?
    var healthRecord: HealthRecordModel? // For editing existing records
    private var selectedRecordType: HealthRecordType = .checkup
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupData()
        setupAnimations()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.background
        title = healthRecord == nil ? "🏥 Yeni Sağlık Kaydı" : "✏️ Sağlık Kaydı Düzenle"
        
        setupNavigationBar()
        setupScrollView()
        setupHeaderView()
        setupFormCards()
        setupSaveButton()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = DesignSystem.Colors.textSecondary
        
        // Modern navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = DesignSystem.Colors.background
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerIconView.translatesAutoresizingMaskIntoConstraints = false
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Header styling
        headerView.backgroundColor = DesignSystem.Colors.primary.withAlphaComponent(0.1)
        headerView.layer.cornerRadius = 20
        
        // Header icon
        headerIconView.image = UIImage(systemName: "heart.text.square.fill")
        headerIconView.tintColor = DesignSystem.Colors.primary
        headerIconView.contentMode = .scaleAspectFit
        
        // Header labels
        headerTitleLabel.text = healthRecord == nil ? "Sağlık Kaydı Ekle" : "Sağlık Kaydı Düzenle"
        headerTitleLabel.font = DesignSystem.Typography.title2
        headerTitleLabel.textColor = DesignSystem.Colors.textPrimary
        
        headerSubtitleLabel.text = "Evcil hayvanınızın sağlık bilgilerini kaydedin"
        headerSubtitleLabel.font = DesignSystem.Typography.callout
        headerSubtitleLabel.textColor = DesignSystem.Colors.textSecondary
        headerSubtitleLabel.numberOfLines = 0
        
        contentView.addSubview(headerView)
        headerView.addSubview(headerIconView)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(headerSubtitleLabel)
    }
    
    private func setupFormCards() {
        setupRecordTypeCard()
        setupPetSelectionCard()
        setupDescriptionCard()
        setupVeterinarianCard()
        setupDateCard()
        setupNotesCard()
    }
    
    private func setupRecordTypeCard() {
        recordTypeCard.translatesAutoresizingMaskIntoConstraints = false
        recordTypeButton.translatesAutoresizingMaskIntoConstraints = false
        recordTypeIconView.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        recordTypeCard.backgroundColor = DesignSystem.Colors.cardBackground
        recordTypeCard.layer.cornerRadius = 16
        recordTypeCard.layer.shadowColor = UIColor.black.cgColor
        recordTypeCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        recordTypeCard.layer.shadowOpacity = 0.1
        recordTypeCard.layer.shadowRadius = 8
        
        // Icon
        recordTypeIconView.image = UIImage(systemName: "list.bullet.circle.fill")
        recordTypeIconView.tintColor = DesignSystem.Colors.primary
        recordTypeIconView.contentMode = .scaleAspectFit
        
        // Button
        recordTypeButton.setTitle("📋 Kayıt Türü: \(selectedRecordType.rawValue)", for: .normal)
        recordTypeButton.setTitleColor(DesignSystem.Colors.textPrimary, for: .normal)
        recordTypeButton.titleLabel?.font = DesignSystem.Typography.callout
        recordTypeButton.contentHorizontalAlignment = .left
        recordTypeButton.addTarget(self, action: #selector(recordTypeTapped), for: .touchUpInside)
        
        contentView.addSubview(recordTypeCard)
        recordTypeCard.addSubview(recordTypeIconView)
        recordTypeCard.addSubview(recordTypeButton)
    }
    
    private func setupPetSelectionCard() {
        petSelectionCard.translatesAutoresizingMaskIntoConstraints = false
        petSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        petSelectionIconView.translatesAutoresizingMaskIntoConstraints = false
        selectedPetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        petSelectionCard.backgroundColor = DesignSystem.Colors.cardBackground
        petSelectionCard.layer.cornerRadius = 16
        petSelectionCard.layer.shadowColor = UIColor.black.cgColor
        petSelectionCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        petSelectionCard.layer.shadowOpacity = 0.1
        petSelectionCard.layer.shadowRadius = 8
        
        // Add border for better visual feedback
        petSelectionCard.layer.borderWidth = 1
        petSelectionCard.layer.borderColor = DesignSystem.Colors.primary.withAlphaComponent(0.3).cgColor
        
        // Add shadow to card
        petSelectionCard.layer.shadowColor = UIColor.black.cgColor
        petSelectionCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        petSelectionCard.layer.shadowOpacity = 0.1
        petSelectionCard.layer.shadowRadius = 4
        
        // Add shadow to icon
        petSelectionIconView.layer.shadowColor = UIColor.black.cgColor
        petSelectionIconView.layer.shadowOffset = CGSize(width: 0, height: 2)
        petSelectionIconView.layer.shadowOpacity = 0.1
        petSelectionIconView.layer.shadowRadius = 4
        
        // Icon
        petSelectionIconView.image = UIImage(systemName: "pawprint.fill")
        petSelectionIconView.tintColor = DesignSystem.Colors.primary
        petSelectionIconView.contentMode = .scaleAspectFit
        petSelectionIconView.backgroundColor = DesignSystem.Colors.primary.withAlphaComponent(0.1)
        petSelectionIconView.layer.cornerRadius = 12
        
        // Add border to icon
        petSelectionIconView.layer.borderWidth = 1
        petSelectionIconView.layer.borderColor = DesignSystem.Colors.primary.withAlphaComponent(0.3).cgColor
        
        // Add shadow to icon
        petSelectionIconView.layer.shadowColor = UIColor.black.cgColor
        petSelectionIconView.layer.shadowOffset = CGSize(width: 0, height: 2)
        petSelectionIconView.layer.shadowOpacity = 0.1
        petSelectionIconView.layer.shadowRadius = 4
        
        // Button
        if let pet = pet {
            petSelectionButton.setTitle("\(getPetEmoji(for: pet.petType)) \(pet.name)", for: .normal)
            petSelectionButton.setTitleColor(DesignSystem.Colors.primary, for: .normal)
        } else {
            petSelectionButton.setTitle("🐾 Hayvan Seçin", for: .normal)
            petSelectionButton.setTitleColor(DesignSystem.Colors.textPrimary, for: .normal)
        }
        petSelectionButton.titleLabel?.font = DesignSystem.Typography.callout
        petSelectionButton.contentHorizontalAlignment = .left
        petSelectionButton.addTarget(self, action: #selector(petSelectionTapped), for: .touchUpInside)
        
        // Add shadow to button
        petSelectionButton.layer.shadowColor = UIColor.black.cgColor
        petSelectionButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        petSelectionButton.layer.shadowOpacity = 0.1
        petSelectionButton.layer.shadowRadius = 4
        
        // Selected pet label
        if let pet = pet {
            selectedPetLabel.text = "Seçili: \(pet.name) (\(pet.petType.rawValue))"
            selectedPetLabel.textColor = DesignSystem.Colors.success
        } else {
            selectedPetLabel.text = "Lütfen bir hayvan seçin"
            selectedPetLabel.textColor = DesignSystem.Colors.textSecondary
        }
        selectedPetLabel.font = DesignSystem.Typography.caption1
        
        // Update card background based on selection
        if pet?.name != nil {
            petSelectionCard.backgroundColor = DesignSystem.Colors.success.withAlphaComponent(0.1)
        }
        
        contentView.addSubview(petSelectionCard)
        petSelectionCard.addSubview(petSelectionIconView)
        petSelectionCard.addSubview(petSelectionButton)
        petSelectionCard.addSubview(selectedPetLabel)
    }
    
    private func setupDescriptionCard() {
        descriptionCard.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionIconView.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        descriptionCard.backgroundColor = DesignSystem.Colors.cardBackground
        descriptionCard.layer.cornerRadius = 16
        descriptionCard.layer.shadowColor = UIColor.black.cgColor
        descriptionCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        descriptionCard.layer.shadowOpacity = 0.1
        descriptionCard.layer.shadowRadius = 8
        
        // Icon
        descriptionIconView.image = UIImage(systemName: "text.alignleft")
        descriptionIconView.tintColor = DesignSystem.Colors.primary
        descriptionIconView.contentMode = .scaleAspectFit
        
        // Text field
        descriptionTextField.placeholder = "Kayıt açıklaması girin..."
        descriptionTextField.font = DesignSystem.Typography.callout
        descriptionTextField.textColor = DesignSystem.Colors.textPrimary
        descriptionTextField.borderStyle = .none
        
        contentView.addSubview(descriptionCard)
        descriptionCard.addSubview(descriptionIconView)
        descriptionCard.addSubview(descriptionTextField)
    }
    
    private func setupVeterinarianCard() {
        veterinarianCard.translatesAutoresizingMaskIntoConstraints = false
        veterinarianTextField.translatesAutoresizingMaskIntoConstraints = false
        veterinarianIconView.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        veterinarianCard.backgroundColor = DesignSystem.Colors.cardBackground
        veterinarianCard.layer.cornerRadius = 16
        veterinarianCard.layer.shadowColor = UIColor.black.cgColor
        veterinarianCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        veterinarianCard.layer.shadowOpacity = 0.1
        veterinarianCard.layer.shadowRadius = 8
        
        // Icon
        veterinarianIconView.image = UIImage(systemName: "person.fill.badge.plus")
        veterinarianIconView.tintColor = DesignSystem.Colors.primary
        veterinarianIconView.contentMode = .scaleAspectFit
        
        // Text field
        veterinarianTextField.placeholder = "Veteriner hekim (opsiyonel)"
        veterinarianTextField.font = DesignSystem.Typography.callout
        veterinarianTextField.textColor = DesignSystem.Colors.textPrimary
        veterinarianTextField.borderStyle = .none
        
        contentView.addSubview(veterinarianCard)
        veterinarianCard.addSubview(veterinarianIconView)
        veterinarianCard.addSubview(veterinarianTextField)
    }
    
    private func setupDateCard() {
        dateCard.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        dateIconView.translatesAutoresizingMaskIntoConstraints = false
        dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        dateCard.backgroundColor = DesignSystem.Colors.cardBackground
        dateCard.layer.cornerRadius = 16
        dateCard.layer.shadowColor = UIColor.black.cgColor
        dateCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        dateCard.layer.shadowOpacity = 0.1
        dateCard.layer.shadowRadius = 8
        
        // Icon
        dateIconView.image = UIImage(systemName: "calendar.circle.fill")
        dateIconView.tintColor = DesignSystem.Colors.primary
        dateIconView.contentMode = .scaleAspectFit
        
        // Title
        dateTitleLabel.text = "Tarih ve Saat"
        dateTitleLabel.font = DesignSystem.Typography.callout
        dateTitleLabel.textColor = DesignSystem.Colors.textPrimary
        
        // Date picker
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        datePicker.tintColor = DesignSystem.Colors.primary
        
        contentView.addSubview(dateCard)
        dateCard.addSubview(dateIconView)
        dateCard.addSubview(dateTitleLabel)
        dateCard.addSubview(datePicker)
    }
    
    private func setupNotesCard() {
        notesCard.translatesAutoresizingMaskIntoConstraints = false
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        notesIconView.translatesAutoresizingMaskIntoConstraints = false
        notesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        notesCard.backgroundColor = DesignSystem.Colors.cardBackground
        notesCard.layer.cornerRadius = 16
        notesCard.layer.shadowColor = UIColor.black.cgColor
        notesCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        notesCard.layer.shadowOpacity = 0.1
        notesCard.layer.shadowRadius = 8
        
        // Icon
        notesIconView.image = UIImage(systemName: "note.text")
        notesIconView.tintColor = DesignSystem.Colors.primary
        notesIconView.contentMode = .scaleAspectFit
        
        // Title
        notesTitleLabel.text = "Ek Notlar (Opsiyonel)"
        notesTitleLabel.font = DesignSystem.Typography.callout
        notesTitleLabel.textColor = DesignSystem.Colors.textPrimary
        
        // Text view
        notesTextView.font = DesignSystem.Typography.callout
        notesTextView.textColor = DesignSystem.Colors.textPrimary
        notesTextView.backgroundColor = .clear
        notesTextView.layer.cornerRadius = 8
        notesTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        contentView.addSubview(notesCard)
        notesCard.addSubview(notesIconView)
        notesCard.addSubview(notesTitleLabel)
        notesCard.addSubview(notesTextView)
    }
    
    private func setupSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("💾 Kaydet", for: .normal)
        saveButton.backgroundColor = DesignSystem.Colors.primary
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = DesignSystem.Typography.buttonTitle
        saveButton.layer.cornerRadius = 16
        saveButton.layer.shadowColor = DesignSystem.Colors.primary.cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        saveButton.layer.shadowOpacity = 0.3
        saveButton.layer.shadowRadius = 12
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        // Add press animation
        saveButton.addTarget(self, action: #selector(saveButtonTouchDown), for: .touchDown)
        saveButton.addTarget(self, action: #selector(saveButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        contentView.addSubview(saveButton)
    }
    
    // MARK: - Data Setup
    private func setupData() {
        // Set default pet if none selected
        if pet == nil && !DataManager.shared.fetchPets().isEmpty {
            pet = DataManager.shared.fetchPets().first
            selectedPetLabel.text = "Seçili: \(pet?.name ?? "") (\(pet?.petType.rawValue ?? ""))"
            selectedPetLabel.textColor = DesignSystem.Colors.success
            
            // Buton başlığını da güncelle
            if let pet = pet {
                petSelectionButton.setTitle("\(getPetEmoji(for: pet.petType)) \(pet.name)", for: .normal)
                petSelectionButton.setTitleColor(DesignSystem.Colors.primary, for: .normal)
            }
            
            // Update card background and border
            petSelectionCard.backgroundColor = DesignSystem.Colors.success.withAlphaComponent(0.1)
            petSelectionCard.layer.borderColor = DesignSystem.Colors.success.withAlphaComponent(0.5).cgColor
            petSelectionIconView.backgroundColor = DesignSystem.Colors.success.withAlphaComponent(0.2)
            petSelectionIconView.layer.borderColor = DesignSystem.Colors.success.withAlphaComponent(0.5).cgColor
            petSelectionIconView.tintColor = DesignSystem.Colors.success
        }
        
        if let healthRecord = healthRecord {
            // Editing mode - populate fields with existing data
            selectedRecordType = healthRecord.recordType
            recordTypeButton.setTitle("📋 Kayıt Türü: \(selectedRecordType.rawValue)", for: .normal)
            descriptionTextField.text = healthRecord.recordDescription
            veterinarianTextField.text = healthRecord.veterinarian
            datePicker.date = healthRecord.recordDate
            // Notes will be added in future updates
        }
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
            
            // Header View
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            headerIconView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headerIconView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerIconView.widthAnchor.constraint(equalToConstant: 40),
            headerIconView.heightAnchor.constraint(equalToConstant: 40),
            
            headerTitleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            headerTitleLabel.leadingAnchor.constraint(equalTo: headerIconView.trailingAnchor, constant: 16),
            headerTitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            headerSubtitleLabel.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 4),
            headerSubtitleLabel.leadingAnchor.constraint(equalTo: headerIconView.trailingAnchor, constant: 16),
            headerSubtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            headerSubtitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            
            // Record Type Card
            recordTypeCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            recordTypeCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recordTypeCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recordTypeCard.heightAnchor.constraint(equalToConstant: 60),
            
            recordTypeIconView.leadingAnchor.constraint(equalTo: recordTypeCard.leadingAnchor, constant: 16),
            recordTypeIconView.centerYAnchor.constraint(equalTo: recordTypeCard.centerYAnchor),
            recordTypeIconView.widthAnchor.constraint(equalToConstant: 24),
            recordTypeIconView.heightAnchor.constraint(equalToConstant: 24),
            
            recordTypeButton.topAnchor.constraint(equalTo: recordTypeCard.topAnchor),
            recordTypeButton.leadingAnchor.constraint(equalTo: recordTypeIconView.trailingAnchor, constant: 12),
            recordTypeButton.trailingAnchor.constraint(equalTo: recordTypeCard.trailingAnchor, constant: -16),
            recordTypeButton.bottomAnchor.constraint(equalTo: recordTypeCard.bottomAnchor),
            
            // Pet Selection Card
            petSelectionCard.topAnchor.constraint(equalTo: recordTypeCard.bottomAnchor, constant: 16),
            petSelectionCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            petSelectionCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            petSelectionCard.heightAnchor.constraint(equalToConstant: 60),
            
            petSelectionIconView.leadingAnchor.constraint(equalTo: petSelectionCard.leadingAnchor, constant: 16),
            petSelectionIconView.centerYAnchor.constraint(equalTo: petSelectionCard.centerYAnchor),
            petSelectionIconView.widthAnchor.constraint(equalToConstant: 24),
            petSelectionIconView.heightAnchor.constraint(equalToConstant: 24),
            
            petSelectionButton.topAnchor.constraint(equalTo: petSelectionCard.topAnchor),
            petSelectionButton.leadingAnchor.constraint(equalTo: petSelectionIconView.trailingAnchor, constant: 12),
            petSelectionButton.trailingAnchor.constraint(equalTo: petSelectionCard.trailingAnchor, constant: -16),
            petSelectionButton.bottomAnchor.constraint(equalTo: petSelectionCard.bottomAnchor),
            
            selectedPetLabel.topAnchor.constraint(equalTo: petSelectionButton.bottomAnchor, constant: 4),
            selectedPetLabel.leadingAnchor.constraint(equalTo: petSelectionIconView.trailingAnchor, constant: 12),
            selectedPetLabel.trailingAnchor.constraint(equalTo: petSelectionCard.trailingAnchor, constant: -16),
            selectedPetLabel.bottomAnchor.constraint(equalTo: petSelectionCard.bottomAnchor),
            
            // Description Card
            descriptionCard.topAnchor.constraint(equalTo: petSelectionCard.bottomAnchor, constant: 16),
            descriptionCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionCard.heightAnchor.constraint(equalToConstant: 60),
            
            descriptionIconView.leadingAnchor.constraint(equalTo: descriptionCard.leadingAnchor, constant: 16),
            descriptionIconView.centerYAnchor.constraint(equalTo: descriptionCard.centerYAnchor),
            descriptionIconView.widthAnchor.constraint(equalToConstant: 24),
            descriptionIconView.heightAnchor.constraint(equalToConstant: 24),
            
            descriptionTextField.topAnchor.constraint(equalTo: descriptionCard.topAnchor),
            descriptionTextField.leadingAnchor.constraint(equalTo: descriptionIconView.trailingAnchor, constant: 12),
            descriptionTextField.trailingAnchor.constraint(equalTo: descriptionCard.trailingAnchor, constant: -16),
            descriptionTextField.bottomAnchor.constraint(equalTo: descriptionCard.bottomAnchor),
            
            // Veterinarian Card
            veterinarianCard.topAnchor.constraint(equalTo: descriptionCard.bottomAnchor, constant: 16),
            veterinarianCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            veterinarianCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            veterinarianCard.heightAnchor.constraint(equalToConstant: 60),
            
            veterinarianIconView.leadingAnchor.constraint(equalTo: veterinarianCard.leadingAnchor, constant: 16),
            veterinarianIconView.centerYAnchor.constraint(equalTo: veterinarianCard.centerYAnchor),
            veterinarianIconView.widthAnchor.constraint(equalToConstant: 24),
            veterinarianIconView.heightAnchor.constraint(equalToConstant: 24),
            
            veterinarianTextField.topAnchor.constraint(equalTo: veterinarianCard.topAnchor),
            veterinarianTextField.leadingAnchor.constraint(equalTo: veterinarianIconView.trailingAnchor, constant: 12),
            veterinarianTextField.trailingAnchor.constraint(equalTo: veterinarianCard.trailingAnchor, constant: -16),
            veterinarianTextField.bottomAnchor.constraint(equalTo: veterinarianCard.bottomAnchor),
            
            // Date Card
            dateCard.topAnchor.constraint(equalTo: veterinarianCard.bottomAnchor, constant: 16),
            dateCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateCard.heightAnchor.constraint(equalToConstant: 60),
            
            dateIconView.leadingAnchor.constraint(equalTo: dateCard.leadingAnchor, constant: 16),
            dateIconView.centerYAnchor.constraint(equalTo: dateCard.centerYAnchor),
            dateIconView.widthAnchor.constraint(equalToConstant: 24),
            dateIconView.heightAnchor.constraint(equalToConstant: 24),
            
            dateTitleLabel.leadingAnchor.constraint(equalTo: dateIconView.trailingAnchor, constant: 12),
            dateTitleLabel.centerYAnchor.constraint(equalTo: dateCard.centerYAnchor),
            
            datePicker.trailingAnchor.constraint(equalTo: dateCard.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: dateCard.centerYAnchor),
            
            // Notes Card
            notesCard.topAnchor.constraint(equalTo: dateCard.bottomAnchor, constant: 16),
            notesCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            notesCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            notesCard.heightAnchor.constraint(equalToConstant: 120),
            
            notesIconView.leadingAnchor.constraint(equalTo: notesCard.leadingAnchor, constant: 16),
            notesIconView.topAnchor.constraint(equalTo: notesCard.topAnchor, constant: 16),
            notesIconView.widthAnchor.constraint(equalToConstant: 24),
            notesIconView.heightAnchor.constraint(equalToConstant: 24),
            
            notesTitleLabel.leadingAnchor.constraint(equalTo: notesIconView.trailingAnchor, constant: 12),
            notesTitleLabel.topAnchor.constraint(equalTo: notesCard.topAnchor, constant: 16),
            notesTitleLabel.trailingAnchor.constraint(equalTo: notesCard.trailingAnchor, constant: -16),
            
            notesTextView.topAnchor.constraint(equalTo: notesTitleLabel.bottomAnchor, constant: 8),
            notesTextView.leadingAnchor.constraint(equalTo: notesIconView.trailingAnchor, constant: 4),
            notesTextView.trailingAnchor.constraint(equalTo: notesCard.trailingAnchor, constant: -16),
            notesTextView.bottomAnchor.constraint(equalTo: notesCard.bottomAnchor, constant: -16),
            
            // Save Button
            saveButton.topAnchor.constraint(equalTo: notesCard.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - Animations
    private func setupAnimations() {
        let cards = [headerView, recordTypeCard, petSelectionCard, descriptionCard, veterinarianCard, dateCard, notesCard, saveButton]
        
        for (index, card) in cards.enumerated() {
            card.alpha = 0
            card.transform = CGAffineTransform(translationX: 0, y: 30)
            
            UIView.animate(withDuration: 0.5, delay: Double(index) * 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                card.alpha = 1.0
                card.transform = .identity
            })
        }
    }
    
    // MARK: - Actions
    @objc private func recordTypeTapped() {
        let alert = UIAlertController(title: "🏥 Kayıt Türü Seçin", message: "Hangi tür sağlık kaydı eklemek istiyorsunuz?", preferredStyle: .actionSheet)
        
        for recordType in HealthRecordType.allCases {
            let emoji = getEmojiForRecordType(recordType)
            let action = UIAlertAction(title: "\(emoji) \(recordType.rawValue)", style: .default) { [weak self] _ in
                self?.selectedRecordType = recordType
                self?.recordTypeButton.setTitle("📋 Kayıt Türü: \(recordType.rawValue)", for: .normal)
                
                // Haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = recordTypeButton
            popover.sourceRect = recordTypeButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    @objc private func petSelectionTapped() {
        let alert = UIAlertController(title: "🐾 Hayvan Seçin", message: "Hangisini sağlık kaydı yapmak istiyorsunuz?", preferredStyle: .actionSheet)
        
        for pet in DataManager.shared.fetchPets() {
            let action = UIAlertAction(title: "\(getPetEmoji(for: pet.petType)) \(pet.name) (\(pet.petType.rawValue))", style: .default) { [weak self] _ in
                self?.pet = pet
                
                // Buton başlığını güncelle - seçilen hayvanı göster
                self?.petSelectionButton.setTitle("\(self?.getPetEmoji(for: pet.petType) ?? "🐾") \(pet.name)", for: .normal)
                self?.petSelectionButton.setTitleColor(DesignSystem.Colors.primary, for: .normal)
                
                // Alt etiketi güncelle
                self?.selectedPetLabel.text = "Seçili: \(pet.name) (\(pet.petType.rawValue))"
                self?.selectedPetLabel.textColor = DesignSystem.Colors.success
                
                // Kart arka planını ve kenarlığını güncelle
                UIView.animate(withDuration: 0.3) {
                    self?.petSelectionCard.backgroundColor = DesignSystem.Colors.success.withAlphaComponent(0.1)
                    self?.petSelectionCard.layer.borderColor = DesignSystem.Colors.success.withAlphaComponent(0.5).cgColor
                    self?.petSelectionIconView.backgroundColor = DesignSystem.Colors.success.withAlphaComponent(0.2)
                    self?.petSelectionIconView.layer.borderColor = DesignSystem.Colors.success.withAlphaComponent(0.5).cgColor
                    self?.petSelectionIconView.tintColor = DesignSystem.Colors.success
                }
                
                // Haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = petSelectionButton
            popover.sourceRect = petSelectionButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func getPetEmoji(for petType: PetType) -> String {
        switch petType {
        case .dog: return "🐕"
        case .cat: return "🐱"
        case .bird: return "🐦"
        case .fish: return "🐠"
        case .rabbit: return "🐰"
        case .hamster: return "🐹"
        case .other: return "🐾"
        }
    }
    
    private func getEmojiForRecordType(_ recordType: HealthRecordType) -> String {
        switch recordType {
        case .vaccination: return "💉"
        case .checkup: return "🩺"
        case .treatment: return "💊"
        case .surgery: return "🏥"
        case .emergency: return "🚨"
        case .grooming: return "✂️"
        case .medication: return "💊"
        case .other: return "📝"
        }
    }
    
    @objc private func saveTapped() {
        guard validateForm() else { return }
        
        let newHealthRecord = HealthRecordModel(
            identifier: healthRecord?.identifier ?? UUID(),
            petId: pet?.identifier ?? healthRecord?.petId ?? UUID(),
            recordDate: datePicker.date,
            recordType: selectedRecordType,
            recordDescription: descriptionTextField.text ?? "",
            veterinarian: veterinarianTextField.text?.isEmpty == false ? veterinarianTextField.text : nil,
            attachments: healthRecord?.attachments ?? []
        )
        
        // Save to data manager
        DataManager.shared.saveHealthRecord(newHealthRecord)
        
        // Show success feedback
        showSuccessAlert()
    }
    
    @objc private func cancelTapped() {
        let alert = UIAlertController(title: "Değişiklikleri Kaydetmedin", message: "Çıkmak istediğinden emin misin?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Devam Et", style: .cancel))
        alert.addAction(UIAlertAction(title: "Çık", style: .destructive) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    @objc private func saveButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.saveButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func saveButtonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.saveButton.transform = .identity
        }
    }
    
    // MARK: - Validation
    private func validateForm() -> Bool {
        guard pet != nil else {
            showValidationAlert(message: "Lütfen bir hayvan seçin 🐾")
            return false
        }
        
        guard let description = descriptionTextField.text, !description.isEmpty else {
            showValidationAlert(message: "Kayıt açıklaması gereklidir 📝")
            return false
        }
        
        if description.count < 3 {
            showValidationAlert(message: "Kayıt açıklaması en az 3 karakter olmalıdir 📏")
            return false
        }
        
        return true
    }
    
    private func showValidationAlert(message: String) {
        let alert = UIAlertController(title: "⚠️ Eksik Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "✅ Başarılı!", message: "Sağlık kaydı başarıyla kaydedildi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
        
        // Haptic feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
} 