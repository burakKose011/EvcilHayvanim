//
//  SettingsViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

public class SettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Profile Section
    private let profileCard = UIView()
    private let profileImageView = UIImageView()
    private let profileNameLabel = UILabel()
    private let profileEmailLabel = UILabel()
    private let editProfileButton = UIButton()
    
    // Settings Sections
    private let generalCard = UIView()
    private let notificationsCard = UIView()
    private let dataManagementCard = UIView()
    private let aboutCard = UIView()
    
    // MARK: - Properties
    private let settingsData = [
        [
            ("person.circle", "Profil", "Hesap bilgilerinizi yönetin"),
            ("paintbrush", "Tema", "Uygulama temasını değiştirin"),
            ("globe", "Dil", "Uygulama dilini seçin")
        ],
        [
            ("bell", "Aşı Hatırlatmaları", "Aşı zamanlarını hatırlat"),
            ("calendar.badge", "Randevu Bildirimleri", "Randevu hatırlatmaları"),
            ("pills", "İlaç Hatırlatmaları", "İlaç alma zamanlarını hatırlat")
        ],
        [
            ("icloud.and.arrow.up", "Veri Yedekleme", "Verilerinizi güvenli şekilde yedekleyin"),
            ("square.and.arrow.up", "Veri Dışa Aktar", "Verilerinizi dışa aktarın"),
            ("square.and.arrow.down", "Veri İçe Aktar", "Verilerinizi içe aktarın")
        ],
        [
            ("info.circle", "Uygulama Hakkında", "Uygulama bilgileri"),
            ("hand.raised", "Gizlilik Politikası", "Gizlilik ayarları"),
            ("doc.text", "Kullanım Şartları", "Kullanım koşulları"),
            ("app.badge", "Sürüm", "Uygulama sürümü")
        ]
    ]
    
    // MARK: - Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupAnimations()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.background
        title = "Ayarlar"
        
        setupScrollView()
        setupProfileCard()
        setupGeneralCard()
        setupNotificationsCard()
        setupDataManagementCard()
        setupAboutCard()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        // Add bottom content inset to account for tab bar
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    private func setupProfileCard() {
        profileCard.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        profileCard.backgroundColor = .white
        profileCard.layer.cornerRadius = 16
        profileCard.layer.shadowColor = UIColor.black.cgColor
        profileCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        profileCard.layer.shadowOpacity = 0.1
        profileCard.layer.shadowRadius = 8
        
        // Profile image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
        profileImageView.backgroundColor = DesignSystem.Colors.primary.withAlphaComponent(0.1)
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = DesignSystem.Colors.primary
        
        // Profile name label
        profileNameLabel.text = "Ahmet Yılmaz"
        profileNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        profileNameLabel.textColor = DesignSystem.Colors.textPrimary
        
        // Profile email label
        profileEmailLabel.text = "ahmet@example.com"
        profileEmailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        profileEmailLabel.textColor = DesignSystem.Colors.textSecondary
        
        // Edit profile button
        editProfileButton.setTitle("Düzenle", for: .normal)
        editProfileButton.setTitleColor(DesignSystem.Colors.primary, for: .normal)
        editProfileButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        editProfileButton.backgroundColor = DesignSystem.Colors.primary.withAlphaComponent(0.1)
        editProfileButton.layer.cornerRadius = 16
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        
        // Add subviews
        contentView.addSubview(profileCard)
        profileCard.addSubview(profileImageView)
        profileCard.addSubview(profileNameLabel)
        profileCard.addSubview(profileEmailLabel)
        profileCard.addSubview(editProfileButton)
    }
    
    private func setupGeneralCard() {
        generalCard.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        generalCard.backgroundColor = .white
        generalCard.layer.cornerRadius = 16
        generalCard.layer.shadowColor = UIColor.black.cgColor
        generalCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        generalCard.layer.shadowOpacity = 0.1
        generalCard.layer.shadowRadius = 8
        
        // Title
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Genel Ayarlar"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = DesignSystem.Colors.textPrimary
        
        // Settings stack
        let settingsStack = UIStackView()
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        settingsStack.axis = .vertical
        settingsStack.spacing = 8
        
        // Create setting items
        for (icon, title, subtitle) in settingsData[0] {
            let settingItem = createSettingItem(icon: icon, title: title, subtitle: subtitle)
            settingsStack.addArrangedSubview(settingItem)
        }
        
        generalCard.addSubview(titleLabel)
        generalCard.addSubview(settingsStack)
        contentView.addSubview(generalCard)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: generalCard.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: generalCard.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: generalCard.trailingAnchor, constant: -16),
            
            settingsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            settingsStack.leadingAnchor.constraint(equalTo: generalCard.leadingAnchor, constant: 16),
            settingsStack.trailingAnchor.constraint(equalTo: generalCard.trailingAnchor, constant: -16),
            settingsStack.bottomAnchor.constraint(equalTo: generalCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupNotificationsCard() {
        notificationsCard.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        notificationsCard.backgroundColor = .white
        notificationsCard.layer.cornerRadius = 16
        notificationsCard.layer.shadowColor = UIColor.black.cgColor
        notificationsCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        notificationsCard.layer.shadowOpacity = 0.1
        notificationsCard.layer.shadowRadius = 8
        
        // Title
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Bildirimler"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = DesignSystem.Colors.textPrimary
        
        // Settings stack
        let settingsStack = UIStackView()
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        settingsStack.axis = .vertical
        settingsStack.spacing = 8
        
        // Create setting items
        for (icon, title, subtitle) in settingsData[1] {
            let settingItem = createSettingItem(icon: icon, title: title, subtitle: subtitle)
            settingsStack.addArrangedSubview(settingItem)
        }
        
        notificationsCard.addSubview(titleLabel)
        notificationsCard.addSubview(settingsStack)
        contentView.addSubview(notificationsCard)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: notificationsCard.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: notificationsCard.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: notificationsCard.trailingAnchor, constant: -16),
            
            settingsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            settingsStack.leadingAnchor.constraint(equalTo: notificationsCard.leadingAnchor, constant: 16),
            settingsStack.trailingAnchor.constraint(equalTo: notificationsCard.trailingAnchor, constant: -16),
            settingsStack.bottomAnchor.constraint(equalTo: notificationsCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupDataManagementCard() {
        dataManagementCard.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        dataManagementCard.backgroundColor = .white
        dataManagementCard.layer.cornerRadius = 16
        dataManagementCard.layer.shadowColor = UIColor.black.cgColor
        dataManagementCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        dataManagementCard.layer.shadowOpacity = 0.1
        dataManagementCard.layer.shadowRadius = 8
        
        // Title
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Veri Yönetimi"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = DesignSystem.Colors.textPrimary
        
        // Settings stack
        let settingsStack = UIStackView()
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        settingsStack.axis = .vertical
        settingsStack.spacing = 8
        
        // Create setting items
        for (icon, title, subtitle) in settingsData[2] {
            let settingItem = createSettingItem(icon: icon, title: title, subtitle: subtitle)
            settingsStack.addArrangedSubview(settingItem)
        }
        
        dataManagementCard.addSubview(titleLabel)
        dataManagementCard.addSubview(settingsStack)
        contentView.addSubview(dataManagementCard)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dataManagementCard.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: dataManagementCard.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: dataManagementCard.trailingAnchor, constant: -16),
            
            settingsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            settingsStack.leadingAnchor.constraint(equalTo: dataManagementCard.leadingAnchor, constant: 16),
            settingsStack.trailingAnchor.constraint(equalTo: dataManagementCard.trailingAnchor, constant: -16),
            settingsStack.bottomAnchor.constraint(equalTo: dataManagementCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupAboutCard() {
        aboutCard.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        aboutCard.backgroundColor = .white
        aboutCard.layer.cornerRadius = 16
        aboutCard.layer.shadowColor = UIColor.black.cgColor
        aboutCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        aboutCard.layer.shadowOpacity = 0.1
        aboutCard.layer.shadowRadius = 8
        
        // Title
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Hakkında"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = DesignSystem.Colors.textPrimary
        
        // Settings stack
        let settingsStack = UIStackView()
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        settingsStack.axis = .vertical
        settingsStack.spacing = 8
        
        // Create setting items
        for (icon, title, subtitle) in settingsData[3] {
            let settingItem = createSettingItem(icon: icon, title: title, subtitle: subtitle)
            settingsStack.addArrangedSubview(settingItem)
        }
        
        aboutCard.addSubview(titleLabel)
        aboutCard.addSubview(settingsStack)
        contentView.addSubview(aboutCard)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: aboutCard.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: aboutCard.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: aboutCard.trailingAnchor, constant: -16),
            
            settingsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            settingsStack.leadingAnchor.constraint(equalTo: aboutCard.leadingAnchor, constant: 16),
            settingsStack.trailingAnchor.constraint(equalTo: aboutCard.trailingAnchor, constant: -16),
            settingsStack.bottomAnchor.constraint(equalTo: aboutCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func createSettingItem(icon: String, title: String, subtitle: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.05)
        containerView.layer.cornerRadius = 12
        
        // Icon
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = DesignSystem.Colors.primary
        iconView.contentMode = .scaleAspectFit
        
        // Title
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = DesignSystem.Colors.textPrimary
        
        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = DesignSystem.Colors.textSecondary
        subtitleLabel.numberOfLines = 2
        
        // Arrow
        let arrowView = UIImageView()
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.image = UIImage(systemName: "chevron.right")
        arrowView.tintColor = UIColor.gray.withAlphaComponent(0.5)
        arrowView.contentMode = .scaleAspectFit
        
        // Add subviews
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(arrowView)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 60),
            
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            arrowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            arrowView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 12),
            arrowView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(settingItemTapped(_:)))
        containerView.addGestureRecognizer(tapGesture)
        
        return containerView
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Profile Card
            profileCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            profileCard.heightAnchor.constraint(equalToConstant: 100),
            
            // Profile Image
            profileImageView.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: profileCard.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Profile Name Label
            profileNameLabel.topAnchor.constraint(equalTo: profileCard.topAnchor, constant: 20),
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            profileNameLabel.trailingAnchor.constraint(equalTo: editProfileButton.leadingAnchor, constant: -16),
            
            // Profile Email Label
            profileEmailLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 4),
            profileEmailLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            profileEmailLabel.trailingAnchor.constraint(equalTo: editProfileButton.leadingAnchor, constant: -16),
            
            // Edit Profile Button
            editProfileButton.trailingAnchor.constraint(equalTo: profileCard.trailingAnchor, constant: -16),
            editProfileButton.centerYAnchor.constraint(equalTo: profileCard.centerYAnchor),
            editProfileButton.widthAnchor.constraint(equalToConstant: 80),
            editProfileButton.heightAnchor.constraint(equalToConstant: 32),
            
            // General Card
            generalCard.topAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: 20),
            generalCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            generalCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Notifications Card
            notificationsCard.topAnchor.constraint(equalTo: generalCard.bottomAnchor, constant: 20),
            notificationsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            notificationsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Data Management Card
            dataManagementCard.topAnchor.constraint(equalTo: notificationsCard.bottomAnchor, constant: 20),
            dataManagementCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dataManagementCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // About Card
            aboutCard.topAnchor.constraint(equalTo: dataManagementCard.bottomAnchor, constant: 20),
            aboutCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            aboutCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Actions
    @objc private func editProfileTapped() {
        // TODO: Implement edit profile functionality
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    @objc private func settingItemTapped(_ gesture: UITapGestureRecognizer) {
        guard let containerView = gesture.view else { return }
        
        // Add press animation
        UIView.animate(withDuration: 0.1, animations: {
            containerView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                containerView.transform = .identity
            }
        }
        
        let alert = UIAlertController(title: "Geliştiriliyor", message: "Bu özellik yakında eklenecek", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Helper Methods
    private func setupAnimations() {
        // Add initial animations for UI elements
        profileImageView.alpha = 0
        profileImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.profileImageView.alpha = 1
            self.profileImageView.transform = .identity
        })
    }
} 