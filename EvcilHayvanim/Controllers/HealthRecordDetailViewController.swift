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
    
    private let headerCard = UIView()
    private let typeIconView = UIImageView()
    private let typeLabel = UILabel()
    private let titleLabel = UILabel()
    private let statusIndicator = UIView()
    
    private let dateCard = UIView()
    private let dateIconView = UIImageView()
    private let dateLabel = UILabel()
    private let dateTitleLabel = UILabel()
    
    private let veterinarianCard = UIView()
    private let veterinarianIconView = UIImageView()
    private let veterinarianLabel = UILabel()
    private let veterinarianTitleLabel = UILabel()
    
    private let descriptionCard = UIView()
    private let descriptionIconView = UIImageView()
    private let descriptionLabel = UILabel()
    private let descriptionTitleLabel = UILabel()
    
    private let attachmentsCard = UIView()
    private let attachmentsIconView = UIImageView()
    private let attachmentsLabel = UILabel()
    private let attachmentsTitleLabel = UILabel()
    
    private let actionButtonsStackView = UIStackView()
    private let editButton = UIButton()
    private let deleteButton = UIButton()
    private let shareButton = UIButton()
    
    // MARK: - Properties
    var healthRecord: HealthRecordModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadHealthRecordData()
        setupAnimations()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.background
        title = "🏥 Sağlık Kaydı"
        
        setupNavigationBar()
        setupScrollView()
        setupCards()
        setupActionButtons()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = DesignSystem.Colors.primary
        
        // Modern navigation bar
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupCards() {
        setupHeaderCard()
        setupDateCard()
        setupVeterinarianCard()
        setupDescriptionCard()
        setupAttachmentsCard()
    }
    
    private func setupHeaderCard() {
        headerCard.translatesAutoresizingMaskIntoConstraints = false
        typeIconView.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Header card styling
        headerCard.backgroundColor = DesignSystem.Colors.cardBackground
        headerCard.layer.cornerRadius = 20
        headerCard.layer.shadowColor = UIColor.black.cgColor
        headerCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        headerCard.layer.shadowOpacity = 0.1
        headerCard.layer.shadowRadius = 12
        
        // Type icon
        typeIconView.contentMode = .scaleAspectFit
        typeIconView.backgroundColor = DesignSystem.Colors.primary.withAlphaComponent(0.1)
        typeIconView.layer.cornerRadius = 25
        typeIconView.tintColor = DesignSystem.Colors.primary
        
        // Type label
        typeLabel.font = DesignSystem.Typography.caption1
        typeLabel.textColor = DesignSystem.Colors.primary
        
        // Title label
        titleLabel.font = DesignSystem.Typography.title2
        titleLabel.textColor = DesignSystem.Colors.textPrimary
        titleLabel.numberOfLines = 0
        
        // Status indicator
        statusIndicator.backgroundColor = DesignSystem.Colors.success
        statusIndicator.layer.cornerRadius = 4
        
        contentView.addSubview(headerCard)
        headerCard.addSubview(typeIconView)
        headerCard.addSubview(typeLabel)
        headerCard.addSubview(titleLabel)
        headerCard.addSubview(statusIndicator)
    }
    
    private func setupDateCard() {
        dateCard.translatesAutoresizingMaskIntoConstraints = false
        dateIconView.translatesAutoresizingMaskIntoConstraints = false
        dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupInfoCard(dateCard, icon: dateIconView, title: dateTitleLabel, content: dateLabel, 
                     iconName: "calendar.circle.fill", titleText: "Tarih ve Saat")
    }
    
    private func setupVeterinarianCard() {
        veterinarianCard.translatesAutoresizingMaskIntoConstraints = false
        veterinarianIconView.translatesAutoresizingMaskIntoConstraints = false
        veterinarianTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        veterinarianLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupInfoCard(veterinarianCard, icon: veterinarianIconView, title: veterinarianTitleLabel, content: veterinarianLabel, 
                     iconName: "person.fill.badge.plus", titleText: "Veteriner Hekim")
    }
    
    private func setupDescriptionCard() {
        descriptionCard.translatesAutoresizingMaskIntoConstraints = false
        descriptionIconView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupInfoCard(descriptionCard, icon: descriptionIconView, title: descriptionTitleLabel, content: descriptionLabel, 
                     iconName: "text.alignleft", titleText: "Açıklama")
    }
    
    private func setupAttachmentsCard() {
        attachmentsCard.translatesAutoresizingMaskIntoConstraints = false
        attachmentsIconView.translatesAutoresizingMaskIntoConstraints = false
        attachmentsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        attachmentsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupInfoCard(attachmentsCard, icon: attachmentsIconView, title: attachmentsTitleLabel, content: attachmentsLabel, 
                     iconName: "paperclip.circle.fill", titleText: "Ekler")
    }
    
    private func setupInfoCard(_ card: UIView, icon: UIImageView, title: UILabel, content: UILabel, 
                              iconName: String, titleText: String) {
        // Card styling
        card.backgroundColor = DesignSystem.Colors.cardBackground
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowOpacity = 0.1
        card.layer.shadowRadius = 8
        
        // Icon styling
        icon.image = UIImage(systemName: iconName)
        icon.tintColor = DesignSystem.Colors.primary
        icon.contentMode = .scaleAspectFit
        
        // Title styling
        title.text = titleText
        title.font = DesignSystem.Typography.caption1
        title.textColor = DesignSystem.Colors.textSecondary
        
        // Content styling
        content.font = DesignSystem.Typography.callout
        content.textColor = DesignSystem.Colors.textPrimary
        content.numberOfLines = 0
        
        contentView.addSubview(card)
        card.addSubview(icon)
        card.addSubview(title)
        card.addSubview(content)
    }
    
    private func setupActionButtons() {
        actionButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        actionButtonsStackView.axis = .horizontal
        actionButtonsStackView.distribution = .fillEqually
        actionButtonsStackView.spacing = 12
        
        // Edit button
        setupActionButton(editButton, title: "✏️ Düzenle", color: DesignSystem.Colors.primary, action: #selector(editTapped))
        
        // Delete button
        setupActionButton(deleteButton, title: "🗑️ Sil", color: DesignSystem.Colors.error, action: #selector(deleteTapped))
        
        // Share button
        setupActionButton(shareButton, title: "📤 Paylaş", color: DesignSystem.Colors.secondary, action: #selector(shareTapped))
        
        actionButtonsStackView.addArrangedSubview(editButton)
        actionButtonsStackView.addArrangedSubview(shareButton)
        actionButtonsStackView.addArrangedSubview(deleteButton)
        
        contentView.addSubview(actionButtonsStackView)
    }
    
    private func setupActionButton(_ button: UIButton, title: String, color: UIColor, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = DesignSystem.Typography.buttonTitle
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 8
        
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // Add press animation
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
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
            
            // Header Card
            headerCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            headerCard.heightAnchor.constraint(equalToConstant: 120),
            
            statusIndicator.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 20),
            statusIndicator.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -20),
            statusIndicator.widthAnchor.constraint(equalToConstant: 8),
            statusIndicator.heightAnchor.constraint(equalToConstant: 8),
            
            typeIconView.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 20),
            typeIconView.centerYAnchor.constraint(equalTo: headerCard.centerYAnchor),
            typeIconView.widthAnchor.constraint(equalToConstant: 50),
            typeIconView.heightAnchor.constraint(equalToConstant: 50),
            
            typeLabel.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 20),
            typeLabel.leadingAnchor.constraint(equalTo: typeIconView.trailingAnchor, constant: 16),
            typeLabel.trailingAnchor.constraint(equalTo: statusIndicator.leadingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: typeIconView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: headerCard.bottomAnchor, constant: -20)
        ])
        
        // Info cards constraints
        let cards = [dateCard, veterinarianCard, descriptionCard, attachmentsCard]
        let icons = [dateIconView, veterinarianIconView, descriptionIconView, attachmentsIconView]
        let titles = [dateTitleLabel, veterinarianTitleLabel, descriptionTitleLabel, attachmentsTitleLabel]
        let contents = [dateLabel, veterinarianLabel, descriptionLabel, attachmentsLabel]
        
        var previousCard = headerCard
        
        for i in 0..<cards.count {
            let card = cards[i]
            let icon = icons[i]
            let title = titles[i]
            let content = contents[i]
            
            NSLayoutConstraint.activate([
                // Card positioning
                card.topAnchor.constraint(equalTo: previousCard.bottomAnchor, constant: 16),
                card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                card.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
                
                // Icon
                icon.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                icon.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
                icon.widthAnchor.constraint(equalToConstant: 24),
                icon.heightAnchor.constraint(equalToConstant: 24),
                
                // Title
                title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
                title.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
                title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
                
                // Content
                content.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
                content.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
                content.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
                content.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
            ])
            
            previousCard = card
        }
        
        // Action buttons
        NSLayoutConstraint.activate([
            actionButtonsStackView.topAnchor.constraint(equalTo: previousCard.bottomAnchor, constant: 32),
            actionButtonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionButtonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionButtonsStackView.heightAnchor.constraint(equalToConstant: 50),
            actionButtonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - Animations
    private func setupAnimations() {
        let elements = [headerCard, dateCard, veterinarianCard, descriptionCard, attachmentsCard, actionButtonsStackView]
        
        for (index, element) in elements.enumerated() {
            element.alpha = 0
            element.transform = CGAffineTransform(translationX: 0, y: 30)
            
            UIView.animate(withDuration: 0.5, delay: Double(index) * 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                element.alpha = 1.0
                element.transform = .identity
            })
        }
    }
    
    // MARK: - Data Loading
    private func loadHealthRecordData() {
        guard let healthRecord = healthRecord else { return }
        
        // Header data
        typeLabel.text = healthRecord.recordType.rawValue.uppercased()
        titleLabel.text = healthRecord.recordDescription
        
        // Set icon and color based on record type
        let (iconName, color) = getIconAndColor(for: healthRecord.recordType)
        typeIconView.image = UIImage(systemName: iconName)
        typeIconView.tintColor = color
        typeIconView.backgroundColor = color.withAlphaComponent(0.1)
        typeLabel.textColor = color
        statusIndicator.backgroundColor = color
        
        // Date data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy\nHH:mm"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateLabel.text = dateFormatter.string(from: healthRecord.recordDate)
        
        // Veterinarian data
        veterinarianLabel.text = healthRecord.veterinarian ?? "Belirtilmemiş"
        
        // Description data
        descriptionLabel.text = healthRecord.recordDescription
        
        // Attachments data
        if !healthRecord.attachments.isEmpty {
            attachmentsLabel.text = "\(healthRecord.attachments.count) dosya eklendi"
        } else {
            attachmentsLabel.text = "Ek dosya bulunmuyor"
        }
    }
    
    private func getIconAndColor(for recordType: HealthRecordType) -> (String, UIColor) {
        switch recordType {
        case .vaccination:
            return ("syringe.fill", UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0))
        case .checkup:
            return ("stethoscope", UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0))
        case .treatment:
            return ("pills.fill", UIColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0))
        case .surgery:
            return ("scissors", UIColor(red: 0.8, green: 0.4, blue: 0.9, alpha: 1.0))
        case .emergency:
            return ("exclamationmark.triangle.fill", UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0))
        case .grooming:
            return ("scissors", UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0))
        case .medication:
            return ("pills.fill", UIColor(red: 0.6, green: 0.9, blue: 0.4, alpha: 1.0))
        case .other:
            return ("heart.fill", DesignSystem.Colors.textSecondary)
        }
    }
    
    // MARK: - Actions
    @objc private func editTapped() {
        let healthRecordFormVC = HealthRecordFormViewController()
        healthRecordFormVC.healthRecord = healthRecord
        let navController = UINavigationController(rootViewController: healthRecordFormVC)
        navController.modalPresentationStyle = .pageSheet
        
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(navController, animated: true)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc private func deleteTapped() {
        let alert = UIAlertController(title: "🗑️ Sağlık Kaydını Sil", 
                                    message: "Bu sağlık kaydını silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.", 
                                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
            self?.deleteHealthRecord()
        })
        
        present(alert, animated: true)
    }
    
    @objc private func shareTapped() {
        guard let healthRecord = healthRecord else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy, HH:mm"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        
        let shareText = """
        🏥 Sağlık Kaydı
        
        📋 Tür: \(healthRecord.recordType.rawValue)
        📝 Açıklama: \(healthRecord.recordDescription)
        📅 Tarih: \(dateFormatter.string(from: healthRecord.recordDate))
        👨‍⚕️ Veteriner: \(healthRecord.veterinarian ?? "Belirtilmemiş")
        
        EvcilHayvanim uygulaması ile oluşturuldu 🐾
        """
        
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        // For iPad
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }
        
        present(activityViewController, animated: true)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
    }
    
    private func deleteHealthRecord() {
        guard let healthRecord = healthRecord else { return }
        
        DataManager.shared.deleteHealthRecord(healthRecord)
        
        // Success feedback
        let alert = UIAlertController(title: "✅ Başarılı", message: "Sağlık kaydı silindi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
        
        // Haptic feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
} 