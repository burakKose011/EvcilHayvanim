//
//  DashboardViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

public class DashboardViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Hero Section
    private let heroCard = UIView()
    private let profileImageView = UIImageView()
    private let welcomeLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let weatherView = UIView()
    private let weatherIcon = UIImageView()
    private let weatherLabel = UILabel()
    private let backgroundImageView = UIImageView()
    private let overlayView = UIView()

    
    // Today's Overview
    private let todayOverviewCard = UIView()
    private let todayTitle = UILabel()
    private let todayContentStack = UIStackView()
    private let upcomingAppointmentView = UIView()
    private let healthReminderView = UIView()
    
    // Recent Activity
    private let recentActivityCard = UIView()
    private let activityTitle = UILabel()
    private let activityTableView = UITableView()
    private let viewAllActivityButton = UIButton()
    
    // Quick Stats
    private let statsContainerView = UIView()
    private let statsStackView = UIStackView()
    private let petsStatCard = UIView()
    private let appointmentsStatCard = UIView()
    private let healthStatCard = UIView()
    
    // Quick Actions
    private let quickActionsCard = UIView()
    private let quickActionsTitle = UILabel()
    private let actionsGrid = UIStackView()
    private let addPetActionView = UIView()
    private let addHealthActionView = UIView()
    private let addAppointmentActionView = UIView()
    
    // MARK: - Properties
    private var pets: [PetModel] = []
    private var upcomingAppointments: [AppointmentModel] = []
    private var reminders: [ReminderModel] = []
    private var recentHealthRecords: [HealthRecordModel] = []
    
    // MARK: - Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadDashboardData()
        setupAnimations()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshDashboard()
        updateTimeBasedContent()
    }
    

    

    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupScrollView()
        setupHeroSection()
        setupStatsSection()
        setupTodayOverview()
        setupQuickActions()
        setupRecentActivity()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func setupHeroSection() {
        heroCard.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Hero card with background image instead of gradient
        heroCard.backgroundColor = .clear
        heroCard.layer.cornerRadius = 28 // Daha yumuşak köşeler
        
        // Add background image
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let sevimliImage = UIImage(named: "sevimli") {
            backgroundImageView.image = sevimliImage
            print("✅ Sevimli.jpg başarıyla yüklendi")
        } else {
            // Fallback olarak sistem resmi kullan
            backgroundImageView.image = UIImage(systemName: "photo.fill")
            backgroundImageView.tintColor = DesignSystem.Colors.primary
            print("⚠️ Sevimli.jpg bulunamadı, fallback resim kullanılıyor")
        }
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = 28 // Hero card ile uyumlu
        backgroundImageView.layer.masksToBounds = true
        
        // Add dark overlay for better text readability
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.layer.cornerRadius = 28 // Hero card ile uyumlu
        overlayView.layer.masksToBounds = true
        
        // Add subviews
        contentView.addSubview(heroCard)
        heroCard.addSubview(backgroundImageView)
        heroCard.addSubview(overlayView)
        heroCard.addSubview(profileImageView)
        heroCard.addSubview(welcomeLabel)
        heroCard.addSubview(subtitleLabel)
        heroCard.addSubview(weatherView)
        weatherView.addSubview(weatherIcon)
        weatherView.addSubview(weatherLabel)
        

        
        // Profile image
        profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        profileImageView.tintColor = .white
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        
        // Welcome text
        welcomeLabel.text = getTimeBasedGreeting()
        welcomeLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        welcomeLabel.textColor = .white
        welcomeLabel.numberOfLines = 0
        
        // Subtitle
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        subtitleLabel.text = dateFormatter.string(from: Date())
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        
        // Weather view
        weatherView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        weatherView.layer.cornerRadius = 16
        
        weatherIcon.image = UIImage(systemName: "sun.max.fill")
        weatherIcon.tintColor = .white
        weatherIcon.contentMode = .scaleAspectFit
        
        weatherLabel.text = "22°C"
        weatherLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        weatherLabel.textColor = .white
        
        // Add subviews
        weatherView.addSubview(weatherIcon)
        weatherView.addSubview(weatherLabel)
    }
    
    private func setupStatsSection() {
        statsContainerView.translatesAutoresizingMaskIntoConstraints = false

        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 16
        
        // Create modern stat cards
        createModernStatCard(petsStatCard, title: "Dostlarım", count: "\(DataManager.shared.fetchPets().count)", icon: "pawprint.fill", color: UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0), subtitle: "Hayvan")
        
        createModernStatCard(appointmentsStatCard, title: "Randevular", count: "\(DataManager.shared.fetchAppointments().filter { $0.appointmentDate > Date() }.count)", icon: "calendar", color: UIColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0), subtitle: "Randevular")
        
        createModernStatCard(healthStatCard, title: "Sağlık", count: "\(DataManager.shared.fetchHealthRecords().count)", icon: "heart.fill", color: UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0), subtitle: "Sağlık")
        
        statsStackView.addArrangedSubview(petsStatCard)
        statsStackView.addArrangedSubview(appointmentsStatCard)
        statsStackView.addArrangedSubview(healthStatCard)
        
        statsContainerView.addSubview(statsStackView)
        contentView.addSubview(statsContainerView)
    }
    
    private func createModernStatCard(_ card: UIView, title: String, count: String, icon: String, color: UIColor, subtitle: String) {
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white // Beyaz arka plan ekle
        card.layer.cornerRadius = 20 // Yuvarlak köşeler
        card.layer.shadowColor = color.withAlphaComponent(0.3).cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowOpacity = 0.2
        card.layer.shadowRadius = 8
        
        // Pati resmi arka plana ekle
        let pawImageView = UIImageView()
        pawImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let pawImage = UIImage(named: "pati") {
            pawImageView.image = pawImage
            pawImageView.tintColor = color // Her card'ın kendi rengi
        } else {
            // Fallback olarak sistem icon'u kullan
            pawImageView.image = UIImage(systemName: "pawprint.fill")
            pawImageView.tintColor = color
        }
        
        pawImageView.contentMode = .scaleAspectFit
        pawImageView.alpha = 0.7 // Çok daha canlı yap
        card.addSubview(pawImageView)
        card.sendSubviewToBack(pawImageView) // En arkaya gönder
        
        // Pati resmi için constraint'ler
        NSLayoutConstraint.activate([
            pawImageView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            pawImageView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            pawImageView.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.8), // Card'ın %80'i kadar
            pawImageView.heightAnchor.constraint(equalTo: card.heightAnchor, multiplier: 0.8) // Card'ın %80'i kadar
        ])
        

        
        // Icon container
        let iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.backgroundColor = color.withAlphaComponent(0.15) // Daha belirgin
        iconContainer.layer.cornerRadius = 20 // Daha yumuşak

        
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        
        // Count label
        let countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.text = count
        countLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold) // Daha büyük font
        countLabel.textColor = color // Card rengi ile uyumlu
        countLabel.textAlignment = .right // Sağa hizala
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold) // Daha uyumlu boyut
        titleLabel.textColor = color
        titleLabel.textAlignment = .left // Sola hizala
        titleLabel.numberOfLines = 0 // Çok satır destekle
        
        // Subtitle label
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium) // Daha uyumlu boyut
        subtitleLabel.textColor = color.withAlphaComponent(0.9) // Daha belirgin
        subtitleLabel.textAlignment = .left // Sola hizala
        subtitleLabel.numberOfLines = 0 // Çok satır destekle
        
        // Add subviews
        iconContainer.addSubview(iconView)
        card.addSubview(iconContainer)
        card.addSubview(countLabel)
        card.addSubview(titleLabel)
        card.addSubview(subtitleLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            iconContainer.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            iconContainer.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            iconContainer.widthAnchor.constraint(equalToConstant: 36),
            iconContainer.heightAnchor.constraint(equalToConstant: 36),
            
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            countLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            
            titleLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            subtitleLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -4),
            subtitleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(statCardTapped(_:)))
        card.addGestureRecognizer(tapGesture)
        card.tag = statsStackView.arrangedSubviews.count
    }
    

    
    private func setupTodayOverview() {
        todayOverviewCard.translatesAutoresizingMaskIntoConstraints = false
        todayTitle.translatesAutoresizingMaskIntoConstraints = false
        todayContentStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        todayOverviewCard.backgroundColor = .white
        todayOverviewCard.layer.cornerRadius = 24 // Daha yumuşak köşeler

        
        // Title
        todayTitle.text = "📅 Bugün"
        todayTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        todayTitle.textColor = DesignSystem.Colors.textPrimary
        
        // Content stack
        todayContentStack.axis = .vertical
        todayContentStack.spacing = 12
        
        // Setup today's content
        setupTodayContent()
        
        todayOverviewCard.addSubview(todayTitle)
        todayOverviewCard.addSubview(todayContentStack)
        contentView.addSubview(todayOverviewCard)
    }
    
    private func setupTodayContent() {
        // Upcoming appointment
        upcomingAppointmentView.translatesAutoresizingMaskIntoConstraints = false
        createTodayItem(upcomingAppointmentView, icon: "calendar.circle.fill", title: "Randevu", subtitle: "Bugün 14:30 - Dr. Ahmet Yılmaz", color: UIColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0))
        
        // Health reminder
        healthReminderView.translatesAutoresizingMaskIntoConstraints = false
        createTodayItem(healthReminderView, icon: "pills.circle.fill", title: "İlaç Hatırlatması", subtitle: "Boncuk'un ilacını vermeyi unutma", color: UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0))
        
        todayContentStack.addArrangedSubview(upcomingAppointmentView)
        todayContentStack.addArrangedSubview(healthReminderView)
    }
    
    private func createTodayItem(_ view: UIView, icon: String, title: String, subtitle: String, color: UIColor) {
        view.backgroundColor = color.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = DesignSystem.Colors.textPrimary
        
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        subtitleLabel.textColor = DesignSystem.Colors.textSecondary
        subtitleLabel.numberOfLines = 0
        
        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            iconView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            subtitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupRecentActivity() {
        recentActivityCard.translatesAutoresizingMaskIntoConstraints = false
        activityTitle.translatesAutoresizingMaskIntoConstraints = false
        activityTableView.translatesAutoresizingMaskIntoConstraints = false
        viewAllActivityButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        recentActivityCard.backgroundColor = .white
        recentActivityCard.layer.cornerRadius = 24 // Daha yumuşak köşeler

        
        // Title
        activityTitle.text = "📈 Son Aktiviteler"
        activityTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        activityTitle.textColor = DesignSystem.Colors.textPrimary
        
        // Table view
        activityTableView.delegate = self
        activityTableView.dataSource = self
        activityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActivityCell")
        activityTableView.separatorStyle = .none
        activityTableView.backgroundColor = .clear
        activityTableView.isScrollEnabled = false
        
        // View all button
        viewAllActivityButton.setTitle("Tümünü Gör", for: .normal)
        viewAllActivityButton.setTitleColor(DesignSystem.Colors.primary, for: .normal)
        viewAllActivityButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        viewAllActivityButton.addTarget(self, action: #selector(viewAllActivityTapped), for: .touchUpInside)
        
        recentActivityCard.addSubview(activityTitle)
        recentActivityCard.addSubview(activityTableView)
        recentActivityCard.addSubview(viewAllActivityButton)
        contentView.addSubview(recentActivityCard)
    }
    

    
    private func setupQuickActions() {
        quickActionsCard.translatesAutoresizingMaskIntoConstraints = false
        quickActionsTitle.translatesAutoresizingMaskIntoConstraints = false
        actionsGrid.translatesAutoresizingMaskIntoConstraints = false
        
        // Clean card styling
        quickActionsCard.backgroundColor = .white
        quickActionsCard.layer.cornerRadius = 24 // Daha yumuşak köşeler

        
        // Title
        quickActionsTitle.text = "⚡ Hızlı İşlemler"
        quickActionsTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        quickActionsTitle.textColor = DesignSystem.Colors.textPrimary
        
        // Actions grid
        actionsGrid.axis = .horizontal
        actionsGrid.distribution = .fillEqually
        actionsGrid.spacing = 12
        
        // Setup only essential actions
        setupEssentialActions()
        
        quickActionsCard.addSubview(quickActionsTitle)
        quickActionsCard.addSubview(actionsGrid)
        contentView.addSubview(quickActionsCard)
    }
    
    private func setupEssentialActions() {
        createSimpleActionView(addPetActionView, icon: "plus.circle.fill", title: "Evcil Hayvan", subtitle: "Ekle", color: UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0), action: #selector(addPetTapped))
        
        createSimpleActionView(addHealthActionView, icon: "heart.circle.fill", title: "Sağlık Kaydı", subtitle: "Ekle", color: UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0), action: #selector(addHealthRecordTapped))
        
        createSimpleActionView(addAppointmentActionView, icon: "calendar.circle.fill", title: "Randevu", subtitle: "Ekle", color: UIColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0), action: #selector(addAppointmentTapped))
        
        actionsGrid.addArrangedSubview(addPetActionView)
        actionsGrid.addArrangedSubview(addHealthActionView)
        actionsGrid.addArrangedSubview(addAppointmentActionView)
    }
    
    private func createSimpleActionView(_ view: UIView, icon: String, title: String, subtitle: String, color: UIColor, action: Selector) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color.withAlphaComponent(0.12) // Daha belirgin
        view.layer.cornerRadius = 20 // Daha yumuşak
        view.layer.borderWidth = 1.5 // Daha kalın border
        view.layer.borderColor = color.withAlphaComponent(0.4).cgColor // Daha belirgin border

        
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = DesignSystem.Colors.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        subtitleLabel.textColor = color
        subtitleLabel.textAlignment = .center
        
        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32), // Daha büyük icon
            iconView.heightAnchor.constraint(equalToConstant: 32), // Daha büyük icon
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            subtitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
        
        // Add button instead of gesture for better reliability
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // Add press animation directly to button
        button.addTarget(self, action: #selector(actionButtonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(actionButtonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func actionButtonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.superview?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func actionButtonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.superview?.transform = .identity
        }
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
            
            // Hero Section
            heroCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            heroCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            heroCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            heroCard.heightAnchor.constraint(equalToConstant: 150),
            
            profileImageView.topAnchor.constraint(equalTo: heroCard.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: heroCard.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            backgroundImageView.topAnchor.constraint(equalTo: heroCard.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: heroCard.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: heroCard.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: heroCard.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: heroCard.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: heroCard.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: heroCard.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: heroCard.bottomAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: heroCard.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: heroCard.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: heroCard.trailingAnchor, constant: -20),
            
            weatherView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            weatherView.leadingAnchor.constraint(equalTo: heroCard.leadingAnchor, constant: 20),
            weatherView.trailingAnchor.constraint(equalTo: heroCard.trailingAnchor, constant: -20),
            weatherView.heightAnchor.constraint(equalToConstant: 40),
            
            weatherIcon.topAnchor.constraint(equalTo: weatherView.topAnchor, constant: 8),
            weatherIcon.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor, constant: 12),
            weatherIcon.widthAnchor.constraint(equalToConstant: 24),
            weatherIcon.heightAnchor.constraint(equalToConstant: 24),
            
            weatherLabel.topAnchor.constraint(equalTo: weatherView.topAnchor, constant: 8),
            weatherLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 8),
            weatherLabel.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor, constant: -12),
            
            // Quick Stats
            statsContainerView.topAnchor.constraint(equalTo: heroCard.bottomAnchor, constant: 20),
            statsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statsContainerView.heightAnchor.constraint(equalToConstant: 160), // Daha da yüksek
            
            statsStackView.topAnchor.constraint(equalTo: statsContainerView.topAnchor),
            statsStackView.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor),
            statsStackView.trailingAnchor.constraint(equalTo: statsContainerView.trailingAnchor),
            statsStackView.bottomAnchor.constraint(equalTo: statsContainerView.bottomAnchor),
            
            // Today's Overview
            todayOverviewCard.topAnchor.constraint(equalTo: statsContainerView.bottomAnchor, constant: 20),
            todayOverviewCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            todayOverviewCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            todayOverviewCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 140),
            
            todayTitle.topAnchor.constraint(equalTo: todayOverviewCard.topAnchor, constant: 20),
            todayTitle.leadingAnchor.constraint(equalTo: todayOverviewCard.leadingAnchor, constant: 20),
            todayTitle.trailingAnchor.constraint(equalTo: todayOverviewCard.trailingAnchor, constant: -20),
            
            todayContentStack.topAnchor.constraint(equalTo: todayTitle.bottomAnchor, constant: 12),
            todayContentStack.leadingAnchor.constraint(equalTo: todayOverviewCard.leadingAnchor, constant: 20),
            todayContentStack.trailingAnchor.constraint(equalTo: todayOverviewCard.trailingAnchor, constant: -20),
            todayContentStack.bottomAnchor.constraint(equalTo: todayOverviewCard.bottomAnchor, constant: -16),
            
            // Quick Actions
            quickActionsCard.topAnchor.constraint(equalTo: todayOverviewCard.bottomAnchor, constant: 20),
            quickActionsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            quickActionsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            quickActionsCard.heightAnchor.constraint(equalToConstant: 200),
            
            quickActionsTitle.topAnchor.constraint(equalTo: quickActionsCard.topAnchor, constant: 20),
            quickActionsTitle.leadingAnchor.constraint(equalTo: quickActionsCard.leadingAnchor, constant: 20),
            quickActionsTitle.trailingAnchor.constraint(equalTo: quickActionsCard.trailingAnchor, constant: -20),
            
            actionsGrid.topAnchor.constraint(equalTo: quickActionsTitle.bottomAnchor, constant: 16),
            actionsGrid.leadingAnchor.constraint(equalTo: quickActionsCard.leadingAnchor, constant: 20),
            actionsGrid.trailingAnchor.constraint(equalTo: quickActionsCard.trailingAnchor, constant: -20),
            actionsGrid.bottomAnchor.constraint(equalTo: quickActionsCard.bottomAnchor, constant: -20),
            
            // Recent Activity
            recentActivityCard.topAnchor.constraint(equalTo: quickActionsCard.bottomAnchor, constant: 20),
            recentActivityCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recentActivityCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recentActivityCard.heightAnchor.constraint(equalToConstant: 200),
            recentActivityCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            activityTitle.topAnchor.constraint(equalTo: recentActivityCard.topAnchor, constant: 20),
            activityTitle.leadingAnchor.constraint(equalTo: recentActivityCard.leadingAnchor, constant: 20),
            activityTitle.trailingAnchor.constraint(equalTo: recentActivityCard.trailingAnchor, constant: -20),
            
            activityTableView.topAnchor.constraint(equalTo: activityTitle.bottomAnchor, constant: 16),
            activityTableView.leadingAnchor.constraint(equalTo: recentActivityCard.leadingAnchor, constant: 20),
            activityTableView.trailingAnchor.constraint(equalTo: recentActivityCard.trailingAnchor, constant: -20),
            activityTableView.bottomAnchor.constraint(equalTo: viewAllActivityButton.topAnchor, constant: -12),
            
            viewAllActivityButton.bottomAnchor.constraint(equalTo: recentActivityCard.bottomAnchor, constant: -16),
            viewAllActivityButton.trailingAnchor.constraint(equalTo: recentActivityCard.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Animations
    private func setupAnimations() {
        let elements = [heroCard, statsContainerView, todayOverviewCard, quickActionsCard, recentActivityCard]
        
        for (index, element) in elements.enumerated() {
            element.alpha = 0
            element.transform = CGAffineTransform(translationX: 0, y: 30)
            
            UIView.animate(withDuration: 0.6, delay: Double(index) * 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                element.alpha = 1.0
                element.transform = .identity
            })
        }
    }
    
    // MARK: - Helper Methods

    
    // MARK: - Data Loading
    private func loadDashboardData() {
        pets = DataManager.shared.fetchPets()
        upcomingAppointments = DataManager.shared.fetchAppointments().filter { $0.appointmentDate > Date() }
        reminders = DataManager.shared.fetchReminders()
        recentHealthRecords = DataManager.shared.fetchHealthRecords().sorted { $0.recordDate > $1.recordDate }
        
        // Take only recent items for dashboard
        upcomingAppointments = Array(upcomingAppointments.prefix(3))
        recentHealthRecords = Array(recentHealthRecords.prefix(3))
        reminders = Array(reminders.filter { $0.reminderDate > Date() }.prefix(3))
        
        // Update UI
        updateStatistics()
        activityTableView.reloadData()
    }
    
    private func refreshDashboard() {
        loadDashboardData()
        activityTableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func handleRefresh() {
        refreshDashboard()
        updateTimeBasedContent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func statCardTapped(_ gesture: UITapGestureRecognizer) {
        guard let card = gesture.view else { return }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Navigate based on card
        switch card.tag {
        case 0: // Pets
            if let tabBar = tabBarController {
                tabBar.selectedIndex = 1
            }
        case 1: // Appointments
            if let tabBar = tabBarController {
                tabBar.selectedIndex = 3
            }
        case 2: // Health
            if let tabBar = tabBarController {
                tabBar.selectedIndex = 2
            }
        default:
            break
        }
    }
    
    @objc private func addPetTapped() {
        let petFormVC = PetFormViewController()
        let navController = UINavigationController(rootViewController: petFormVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc private func addHealthRecordTapped() {
        let healthRecordFormVC = HealthRecordFormViewController()
        let navController = UINavigationController(rootViewController: healthRecordFormVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc private func addAppointmentTapped() {
        let appointmentFormVC = AppointmentFormViewController()
        let navController = UINavigationController(rootViewController: appointmentFormVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc private func viewAllActivityTapped() {
        if let tabBar = tabBarController {
            tabBar.selectedIndex = 2 // Health Records
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    // MARK: - Helper Methods
    private func getTimeBasedGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "Günaydın! ☀️"
        case 12..<17:
            return "İyi Günler! 🌤️"
        case 17..<21:
            return "İyi Akşamlar! 🌅"
        default:
            return "İyi Geceler! 🌙"
        }
    }
    
    private func updateTimeBasedContent() {
        welcomeLabel.text = getTimeBasedGreeting()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        subtitleLabel.text = dateFormatter.string(from: Date())
    }
    
    private func updateStatistics() {
        // Update pets count
        petsStatCard.subviews.forEach { $0.removeFromSuperview() }
        createModernStatCard(petsStatCard, title: "Dostlarım", count: "\(pets.count)", icon: "pawprint.fill", color: UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0), subtitle: "Evcil Hayvan")
        
        // Update appointments count
        appointmentsStatCard.subviews.forEach { $0.removeFromSuperview() }
        createModernStatCard(appointmentsStatCard, title: "Randevular", count: "\(upcomingAppointments.count)", icon: "calendar", color: UIColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0), subtitle: "Randevular")
        
        // Update health records count
        healthStatCard.subviews.forEach { $0.removeFromSuperview() }
        createModernStatCard(healthStatCard, title: "Sağlık", count: "\(recentHealthRecords.count)", icon: "heart.fill", color: UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0), subtitle: "Kayıt")
    }
    


}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(recentHealthRecords.count, 3) // Show max 3 recent activities
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
        
        if indexPath.row < recentHealthRecords.count {
            let record = recentHealthRecords[indexPath.row]
            
            let emoji = getEmojiForRecordType(record.recordType)
            cell.textLabel?.text = "\(emoji) \(record.recordDescription)"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            cell.textLabel?.textColor = DesignSystem.Colors.textPrimary
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM"
            dateFormatter.locale = Locale(identifier: "tr_TR")
            cell.detailTextLabel?.text = dateFormatter.string(from: record.recordDate)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            cell.detailTextLabel?.textColor = DesignSystem.Colors.textSecondary
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
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
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
} 
