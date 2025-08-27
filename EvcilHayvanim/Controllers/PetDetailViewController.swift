//
//  PetDetailViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class PetDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Hero Section with Parallax Effect
    private let heroContainer = UIView()
    private let heroImageView = UIImageView()
    private let heroOverlay = UIView()
    private let heroGradientLayer = CAGradientLayer()
    
    // Pet Info Header
    private let petInfoCard = UIView()
    private let petImageView = UIImageView()
    private let petImageContainer = UIView()
    private let nameLabel = UILabel()
    private let breedLabel = UILabel()
    private let ageLabel = UILabel()
    private let statusBadge = UIView()
    private let statusLabel = UILabel()
    private let favoriteButton = UIButton()
    
    // Stats Grid
    private let statsGrid = UIStackView()
    private lazy var weightCard = createStatCard(title: "Kilo", icon: "scalemass.fill", color: UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0))
    private lazy var ageCard = createStatCard(title: "Yaş", icon: "calendar", color: UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0))
    private lazy var genderCard = createStatCard(title: "Cinsiyet", icon: "person.fill", color: UIColor(red: 0.9, green: 0.4, blue: 0.8, alpha: 1.0))
    private lazy var microchipCard = createStatCard(title: "Mikroçip", icon: "wave.3.right", color: UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0))
    
    // Quick Actions
    private let actionsCard = UIView()
    private let actionsTitle = UILabel()
    private let actionsGrid = UIStackView()
    
    // Health Overview
    private let healthCard = UIView()
    private let healthTitle = UILabel()
    private let healthIcon = UIImageView()
    private let healthProgressView = UIProgressView()
    private let healthStatsStack = UIStackView()
    
    // Recent Records
    private let recordsCard = UIView()
    private let recordsTitle = UILabel()
    private let recordsIcon = UIImageView()
    private let recordsCollectionView: UICollectionView
    
    // MARK: - Properties
    var pet: PetModel?
    private var recentHealthRecords: [HealthRecordModel] = []
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        recordsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadPetData()
        setupAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecentRecords()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        heroGradientLayer.frame = heroContainer.bounds
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.background
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        
        setupNavigationBar()
        setupScrollView()
        setupHeroSection()
        setupPetInfoCard()
        setupStatsGrid()
        setupActionsCard()
        setupHealthCard()
        setupRecordsCard()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(moreOptionsTapped)
        )
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
    }
    
    private func setupHeroSection() {
        heroContainer.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        // Hero container
        heroContainer.clipsToBounds = true
        heroContainer.layer.cornerRadius = 0
        
        // Hero image
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true
        
        // Hero overlay with gradient
        heroOverlay.backgroundColor = .clear
        heroGradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.2).cgColor,
            UIColor.black.withAlphaComponent(0.6).cgColor
        ]
        heroGradientLayer.locations = [0.0, 0.5, 1.0]
        heroOverlay.layer.addSublayer(heroGradientLayer)
        
        contentView.addSubview(heroContainer)
        heroContainer.addSubview(heroImageView)
        heroContainer.addSubview(heroOverlay)
    }
    
    private func setupPetInfoCard() {
        petInfoCard.translatesAutoresizingMaskIntoConstraints = false
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        petImageContainer.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        statusBadge.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling - daha modern
        petInfoCard.backgroundColor = .white
        petInfoCard.layer.cornerRadius = 28
        petInfoCard.layer.shadowColor = UIColor.black.cgColor
        petInfoCard.layer.shadowOffset = CGSize(width: 0, height: 12)
        petInfoCard.layer.shadowOpacity = 0.15
        petInfoCard.layer.shadowRadius = 24
        
        // Pet image container - daha küçük ve kompakt
        petImageContainer.backgroundColor = .white
        petImageContainer.layer.cornerRadius = 40
        petImageContainer.layer.borderWidth = 4
        petImageContainer.layer.borderColor = UIColor.white.cgColor
        petImageContainer.layer.shadowColor = UIColor.black.cgColor
        petImageContainer.layer.shadowOffset = CGSize(width: 0, height: 6)
        petImageContainer.layer.shadowOpacity = 0.15
        petImageContainer.layer.shadowRadius = 12
        
        // Pet image
        petImageView.contentMode = .scaleAspectFill
        petImageView.clipsToBounds = true
        petImageView.layer.cornerRadius = 36
        
        // Name label - daha küçük ve kompakt
        nameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        nameLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        nameLabel.textAlignment = .center
        
        // Breed label - daha küçük
        breedLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        breedLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        breedLabel.textAlignment = .center
        
        // Age label - daha küçük
        ageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        ageLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        ageLabel.textAlignment = .center
        
        // Status badge - daha modern
        statusBadge.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        statusBadge.layer.cornerRadius = 16
        
        statusLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        statusLabel.textColor = .white
        statusLabel.text = "Aktif"
        statusLabel.textAlignment = .center
        
        // Favorite button - daha modern
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        favoriteButton.tintColor = .systemRed
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = 24
        favoriteButton.layer.shadowColor = UIColor.black.cgColor
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        favoriteButton.layer.shadowOpacity = 0.15
        favoriteButton.layer.shadowRadius = 12
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        
        contentView.addSubview(petInfoCard)
        petInfoCard.addSubview(petImageContainer)
        petImageContainer.addSubview(petImageView)
        petInfoCard.addSubview(nameLabel)
        petInfoCard.addSubview(breedLabel)
        petInfoCard.addSubview(ageLabel)
        petInfoCard.addSubview(statusBadge)
        statusBadge.addSubview(statusLabel)
        petInfoCard.addSubview(favoriteButton)
    }
    
    private func setupStatsGrid() {
        statsGrid.translatesAutoresizingMaskIntoConstraints = false
        statsGrid.axis = .horizontal
        statsGrid.distribution = .fillEqually
        statsGrid.spacing = 16
        
        contentView.addSubview(statsGrid)
        statsGrid.addArrangedSubview(weightCard)
        statsGrid.addArrangedSubview(ageCard)
        statsGrid.addArrangedSubview(genderCard)
        statsGrid.addArrangedSubview(microchipCard)
    }
    
    // MARK: - Helper Methods
    private func createStatCard(title: String, icon: String, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 20
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowOpacity = 0.08
        card.layer.shadowRadius = 12
        
        // Gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            color.withAlphaComponent(0.1).cgColor,
            color.withAlphaComponent(0.05).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = 20
        card.layer.insertSublayer(gradientLayer, at: 0)
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon background
        let iconBackground = UIView()
        iconBackground.backgroundColor = color.withAlphaComponent(0.15)
        iconBackground.layer.cornerRadius = 16
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = "0"
        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = color
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(iconBackground)
        iconBackground.addSubview(iconView)
        card.addSubview(titleLabel)
        card.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconBackground.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            iconBackground.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            iconBackground.widthAnchor.constraint(equalToConstant: 32),
            iconBackground.heightAnchor.constraint(equalToConstant: 32),
            
            iconView.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: iconBackground.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            valueLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        // Gradient frame'i güncelle
        DispatchQueue.main.async {
            gradientLayer.frame = card.bounds
        }
        
        return card
    }
    
    private func createActionButton(title: String, icon: String, color: UIColor) -> UIButton {
        let button = UIButton()
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = title
        buttonConfig.image = UIImage(systemName: icon)
        buttonConfig.imagePlacement = .top
        buttonConfig.imagePadding = 12
        buttonConfig.baseBackgroundColor = color.withAlphaComponent(0.12)
        buttonConfig.baseForegroundColor = color
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
        buttonConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            return outgoing
        }
        
        button.configuration = buttonConfig
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = color.withAlphaComponent(0.2).cgColor
        
        // Hover effect için shadow
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 12
        
        return button
    }
    
    private func setupActionsCard() {
        actionsCard.translatesAutoresizingMaskIntoConstraints = false
        actionsTitle.translatesAutoresizingMaskIntoConstraints = false
        actionsGrid.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling - daha modern
        actionsCard.backgroundColor = .white
        actionsCard.layer.cornerRadius = 24
        actionsCard.layer.shadowColor = UIColor.black.cgColor
        actionsCard.layer.shadowOffset = CGSize(width: 0, height: 6)
        actionsCard.layer.shadowOpacity = 0.1
        actionsCard.layer.shadowRadius = 20
        
        // Title - daha modern
        actionsTitle.text = "🚀 Hızlı İşlemler"
        actionsTitle.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        actionsTitle.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        // Actions grid
        actionsGrid.axis = .horizontal
        actionsGrid.distribution = .fillEqually
        actionsGrid.spacing = 20
        
        let addRecordButton = createActionButton(title: "Sağlık Kaydı", icon: "plus.circle.fill", color: UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0))
        let addAppointmentButton = createActionButton(title: "Randevu", icon: "calendar.badge.plus", color: UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0))
        let editButton = createActionButton(title: "Düzenle", icon: "pencil.circle.fill", color: UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0))
        
        addRecordButton.addTarget(self, action: #selector(addRecordTapped), for: .touchUpInside)
        addAppointmentButton.addTarget(self, action: #selector(addAppointmentTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        
        contentView.addSubview(actionsCard)
        actionsCard.addSubview(actionsTitle)
        actionsCard.addSubview(actionsGrid)
        actionsGrid.addArrangedSubview(addRecordButton)
        actionsGrid.addArrangedSubview(addAppointmentButton)
        actionsGrid.addArrangedSubview(editButton)
    }
    
    private func setupHealthCard() {
        healthCard.translatesAutoresizingMaskIntoConstraints = false
        healthTitle.translatesAutoresizingMaskIntoConstraints = false
        healthIcon.translatesAutoresizingMaskIntoConstraints = false
        healthProgressView.translatesAutoresizingMaskIntoConstraints = false
        healthStatsStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling - daha modern
        healthCard.backgroundColor = .white
        healthCard.layer.cornerRadius = 24
        healthCard.layer.shadowColor = UIColor.black.cgColor
        healthCard.layer.shadowOffset = CGSize(width: 0, height: 6)
        healthCard.layer.shadowOpacity = 0.1
        healthCard.layer.shadowRadius = 20
        
        // Title with icon - daha modern
        healthTitle.text = "💚 Sağlık Durumu"
        healthTitle.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        healthTitle.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        healthIcon.image = UIImage(systemName: "heart.fill")
        healthIcon.tintColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        healthIcon.contentMode = .scaleAspectFit
        
        // Progress view - daha modern
        healthProgressView.progressTintColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        healthProgressView.trackTintColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0).withAlphaComponent(0.2)
        healthProgressView.layer.cornerRadius = 6
        healthProgressView.clipsToBounds = true
        healthProgressView.progress = 0.85
        
        // Stats stack
        healthStatsStack.axis = .horizontal
        healthStatsStack.distribution = .fillEqually
        healthStatsStack.spacing = 24
        
        let lastCheckup = createHealthStat(title: "Son Kontrol", value: "2 hafta önce", color: UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0))
        let nextVaccine = createHealthStat(title: "Sonraki Aşı", value: "1 ay", color: UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0))
        let overallHealth = createHealthStat(title: "Genel Durum", value: "Mükemmel", color: UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0))
        
        contentView.addSubview(healthCard)
        healthCard.addSubview(healthTitle)
        healthCard.addSubview(healthIcon)
        healthCard.addSubview(healthProgressView)
        healthCard.addSubview(healthStatsStack)
        healthStatsStack.addArrangedSubview(lastCheckup)
        healthStatsStack.addArrangedSubview(nextVaccine)
        healthStatsStack.addArrangedSubview(overallHealth)
    }
    
    private func createHealthStat(title: String, value: String, color: UIColor) -> UIView {
        let container = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textColor = color
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func setupRecordsCard() {
        recordsCard.translatesAutoresizingMaskIntoConstraints = false
        recordsTitle.translatesAutoresizingMaskIntoConstraints = false
        recordsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling - çok daha modern ve şık
        recordsCard.backgroundColor = .white
        recordsCard.layer.cornerRadius = 24
        recordsCard.layer.shadowColor = UIColor.black.cgColor
        recordsCard.layer.shadowOffset = CGSize(width: 0, height: 8)
        recordsCard.layer.shadowOpacity = 0.12
        recordsCard.layer.shadowRadius = 24
        
        // Title - daha büyük ve dikkat çekici
        recordsTitle.text = "🏥 Son Sağlık Kayıtları"
        recordsTitle.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        recordsTitle.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        // Collection view - daha iyi görünüm
        recordsCollectionView.backgroundColor = .clear
        recordsCollectionView.showsVerticalScrollIndicator = false
        recordsCollectionView.showsHorizontalScrollIndicator = false
        recordsCollectionView.register(HealthRecordCell.self, forCellWithReuseIdentifier: "HealthRecordCell")
        recordsCollectionView.delegate = self
        recordsCollectionView.dataSource = self
        
        contentView.addSubview(recordsCard)
        recordsCard.addSubview(recordsTitle)
        recordsCard.addSubview(recordsCollectionView)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Hero Section
            heroContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroContainer.heightAnchor.constraint(equalToConstant: 220),
            
            heroImageView.topAnchor.constraint(equalTo: heroContainer.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: heroContainer.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: heroContainer.trailingAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: heroContainer.bottomAnchor),
            
            heroOverlay.topAnchor.constraint(equalTo: heroContainer.topAnchor),
            heroOverlay.leadingAnchor.constraint(equalTo: heroContainer.leadingAnchor),
            heroOverlay.trailingAnchor.constraint(equalTo: heroContainer.trailingAnchor),
            heroOverlay.bottomAnchor.constraint(equalTo: heroContainer.bottomAnchor),
            
            // Pet Info Card
            petInfoCard.topAnchor.constraint(equalTo: heroContainer.bottomAnchor, constant: -50),
            petInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            petInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            petInfoCard.heightAnchor.constraint(equalToConstant: 180),
            
            petImageContainer.topAnchor.constraint(equalTo: petInfoCard.topAnchor, constant: -25),
            petImageContainer.centerXAnchor.constraint(equalTo: petInfoCard.centerXAnchor),
            petImageContainer.widthAnchor.constraint(equalToConstant: 80),
            petImageContainer.heightAnchor.constraint(equalToConstant: 80),
            
            petImageView.topAnchor.constraint(equalTo: petImageContainer.topAnchor, constant: 2.5),
            petImageView.leadingAnchor.constraint(equalTo: petImageContainer.leadingAnchor, constant: 2.5),
            petImageView.trailingAnchor.constraint(equalTo: petImageContainer.trailingAnchor, constant: -2.5),
            petImageView.bottomAnchor.constraint(equalTo: petImageContainer.bottomAnchor, constant: -2.5),
            
            nameLabel.topAnchor.constraint(equalTo: petImageContainer.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: petInfoCard.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: petInfoCard.trailingAnchor, constant: -20),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            breedLabel.leadingAnchor.constraint(equalTo: petInfoCard.leadingAnchor, constant: 20),
            breedLabel.trailingAnchor.constraint(equalTo: petInfoCard.trailingAnchor, constant: -20),
            
            ageLabel.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 4),
            ageLabel.leadingAnchor.constraint(equalTo: petInfoCard.leadingAnchor, constant: 20),
            ageLabel.trailingAnchor.constraint(equalTo: petInfoCard.trailingAnchor, constant: -20),
            
            statusBadge.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 12),
            statusBadge.centerXAnchor.constraint(equalTo: petInfoCard.centerXAnchor),
            statusBadge.widthAnchor.constraint(equalToConstant: 60),
            statusBadge.heightAnchor.constraint(equalToConstant: 24),
            
            statusLabel.topAnchor.constraint(equalTo: statusBadge.topAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusBadge.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: statusBadge.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: statusBadge.bottomAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: petInfoCard.topAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: petInfoCard.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Stats Grid
            statsGrid.topAnchor.constraint(equalTo: petInfoCard.bottomAnchor, constant: 24),
            statsGrid.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsGrid.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statsGrid.heightAnchor.constraint(equalToConstant: 120),
            
            // Actions Card
            actionsCard.topAnchor.constraint(equalTo: statsGrid.bottomAnchor, constant: 24),
            actionsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionsCard.heightAnchor.constraint(equalToConstant: 160),
            
            actionsTitle.topAnchor.constraint(equalTo: actionsCard.topAnchor, constant: 20),
            actionsTitle.leadingAnchor.constraint(equalTo: actionsCard.leadingAnchor, constant: 20),
            actionsTitle.trailingAnchor.constraint(equalTo: actionsCard.trailingAnchor, constant: -20),
            
            actionsGrid.topAnchor.constraint(equalTo: actionsTitle.bottomAnchor, constant: 20),
            actionsGrid.leadingAnchor.constraint(equalTo: actionsCard.leadingAnchor, constant: 20),
            actionsGrid.trailingAnchor.constraint(equalTo: actionsCard.trailingAnchor, constant: -20),
            actionsGrid.bottomAnchor.constraint(equalTo: actionsCard.bottomAnchor, constant: -20),
            
            // Health Card
            healthCard.topAnchor.constraint(equalTo: actionsCard.bottomAnchor, constant: 24),
            healthCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            healthCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            healthCard.heightAnchor.constraint(equalToConstant: 180),
            
            healthTitle.topAnchor.constraint(equalTo: healthCard.topAnchor, constant: 20),
            healthTitle.leadingAnchor.constraint(equalTo: healthCard.leadingAnchor, constant: 20),
            
            healthIcon.topAnchor.constraint(equalTo: healthCard.topAnchor, constant: 20),
            healthIcon.trailingAnchor.constraint(equalTo: healthCard.trailingAnchor, constant: -20),
            healthIcon.widthAnchor.constraint(equalToConstant: 24),
            healthIcon.heightAnchor.constraint(equalToConstant: 24),
            
            healthProgressView.topAnchor.constraint(equalTo: healthTitle.bottomAnchor, constant: 20),
            healthProgressView.leadingAnchor.constraint(equalTo: healthCard.leadingAnchor, constant: 20),
            healthProgressView.trailingAnchor.constraint(equalTo: healthCard.trailingAnchor, constant: -20),
            healthProgressView.heightAnchor.constraint(equalToConstant: 8),
            
            healthStatsStack.topAnchor.constraint(equalTo: healthProgressView.bottomAnchor, constant: 24),
            healthStatsStack.leadingAnchor.constraint(equalTo: healthCard.leadingAnchor, constant: 20),
            healthStatsStack.trailingAnchor.constraint(equalTo: healthCard.trailingAnchor, constant: -20),
            healthStatsStack.bottomAnchor.constraint(equalTo: healthCard.bottomAnchor, constant: -20),
            
            // Records Card
            recordsCard.topAnchor.constraint(equalTo: healthCard.bottomAnchor, constant: 24),
            recordsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recordsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recordsCard.heightAnchor.constraint(equalToConstant: 160),
            recordsCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            recordsTitle.topAnchor.constraint(equalTo: recordsCard.topAnchor, constant: 20),
            recordsTitle.leadingAnchor.constraint(equalTo: recordsCard.leadingAnchor, constant: 20),
            recordsTitle.trailingAnchor.constraint(equalTo: recordsCard.trailingAnchor, constant: -20),
            
            recordsCollectionView.topAnchor.constraint(equalTo: recordsTitle.bottomAnchor, constant: 16),
            recordsCollectionView.leadingAnchor.constraint(equalTo: recordsCard.leadingAnchor, constant: 16),
            recordsCollectionView.trailingAnchor.constraint(equalTo: recordsCard.trailingAnchor, constant: -16),
            recordsCollectionView.bottomAnchor.constraint(equalTo: recordsCard.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Data Loading
    private func loadPetData() {
        guard let pet = pet else { return }
        
        nameLabel.text = pet.name
        breedLabel.text = pet.breed
        
        let age = Calendar.current.dateComponents([.year], from: pet.birthDate, to: Date()).year ?? 0
        ageLabel.text = "\(age) yaşında"
        
        // Update stat cards
        if let weightCard = weightCard.subviews.last as? UILabel {
            weightCard.text = "\(pet.weight) kg"
        }
        if let ageCard = ageCard.subviews.last as? UILabel {
            ageCard.text = "\(age) yaş"
        }
        if let genderCard = genderCard.subviews.last as? UILabel {
            genderCard.text = pet.gender == .male ? "Erkek" : "Dişi"
        }
        if let microchipCard = microchipCard.subviews.last as? UILabel {
            microchipCard.text = pet.microchipNumber ?? "Yok"
        }
        
        // Load pet image if available
        if pet.photoURL != nil {
            // Load image from URL
            petImageView.image = UIImage(named: "pet") // Placeholder
        } else {
            petImageView.image = UIImage(named: "pet") // Default image
        }
        
        // Set hero background - hayvanlar.jpg kullan
        if let hayvanlarImage = UIImage(named: "hayvanlar") {
            heroImageView.image = hayvanlarImage
            print("✅ Hayvanlar.jpg başarıyla yüklendi")
        } else if let petYanimdaImage = UIImage(named: "petYanimda") {
            // Fallback olarak petYanimda resmini kullan
            heroImageView.image = petYanimdaImage
            print("⚠️ Hayvanlar.jpg bulunamadı, petYanimda resmi kullanılıyor")
        } else {
            // Son fallback olarak pet resmini kullan
            heroImageView.image = petImageView.image
            print("⚠️ Hiçbir kapak resmi bulunamadı, pet resmi kullanılıyor")
        }
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func moreOptionsTapped() {
        // More options menu göster
        let alert = UIAlertController(title: "⚙️ Daha Fazla Seçenek", message: "Ne yapmak istiyorsunuz?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "📸 Fotoğraf Değiştir", style: .default) { [weak self] _ in
            // TODO: Fotoğraf değiştirme işlevi
        })
        
        alert.addAction(UIAlertAction(title: "🗑️ Hayvanı Sil", style: .destructive) { [weak self] _ in
            self?.showDeleteConfirmation()
        })
        
        alert.addAction(UIAlertAction(title: "📤 Dışa Aktar", style: .default) { [weak self] _ in
            // TODO: Dışa aktarma işlevi
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
        
        present(alert, animated: true)
    }
    
    private func showDeleteConfirmation() {
        guard let pet = pet else { return }
        
        let alert = UIAlertController(title: "⚠️ Dikkat!", message: "\(pet.name) adlı hayvanı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
            // Hayvanı sil
            DataManager.shared.deletePet(pet)
            
            // Ana sayfaya dön
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    @objc private func favoriteTapped() {
        favoriteButton.isSelected.toggle()
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Animasyon ekle
        UIView.animate(withDuration: 0.2, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.favoriteButton.transform = .identity
            }
        }
        
        // TODO: Favori durumunu kaydet
        if favoriteButton.isSelected {
            // Favoriye eklendi
            print("\(pet?.name ?? "Hayvan") favorilere eklendi")
        } else {
            // Favorilerden çıkarıldı
            print("\(pet?.name ?? "Hayvan") favorilerden çıkarıldı")
        }
    }
    
    @objc private func addRecordTapped() {
        guard let pet = pet else { return }
        
        // HealthRecordFormViewController'ı aç
        let healthRecordFormVC = HealthRecordFormViewController()
        healthRecordFormVC.pet = pet // Seçili hayvanı geçir
        
        let navController = UINavigationController(rootViewController: healthRecordFormVC)
        navController.modalPresentationStyle = .pageSheet
        
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(navController, animated: true)
    }
    
    @objc private func addAppointmentTapped() {
        guard let pet = pet else { return }
        
        // AppointmentFormViewController'ı aç
        let appointmentFormVC = AppointmentFormViewController()
        appointmentFormVC.pet = pet // Seçili hayvanı geçir
        
        let navController = UINavigationController(rootViewController: appointmentFormVC)
        navController.modalPresentationStyle = .pageSheet
        
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(navController, animated: true)
    }
    
    @objc private func editTapped() {
        guard let pet = pet else { return }
        
        // PetFormViewController'ı düzenleme modunda aç
        let petFormVC = PetFormViewController()
        petFormVC.pet = pet // Mevcut hayvan bilgilerini geçir
        petFormVC.isEditMode = true // Düzenleme modunda olduğunu belirt
        
        // Düzenleme tamamlandığında verileri yeniden yükle
        petFormVC.onEditCompleted = { [weak self] in
            self?.loadPetData()
        }
        
        let navController = UINavigationController(rootViewController: petFormVC)
        navController.modalPresentationStyle = .pageSheet
        
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(navController, animated: true)
    }
    
    private func loadRecentRecords() {
        guard let pet = pet else { return }
        
        // Bu hayvan için son sağlık kayıtlarını yükle
        let allRecords = DataManager.shared.fetchHealthRecords()
        let filteredRecords = allRecords.filter { $0.petId == pet.identifier }
            .sorted { $0.recordDate > $1.recordDate }
        
        // Son 5 kaydı al ve Array'e dönüştür
        recentHealthRecords = Array(filteredRecords.prefix(5))
        
        recordsCollectionView.reloadData()
    }
    
    // MARK: - Animations
    private func setupAnimations() {
        // Add entrance animations
        UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseOut) {
            self.petInfoCard.alpha = 1
            self.petInfoCard.transform = .identity
        }
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension PetDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentHealthRecords.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32) // 16 + 16 (margins)
        return CGSize(width: width, height: 100)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HealthRecordCell", for: indexPath) as! HealthRecordCell
        let record = recentHealthRecords[indexPath.item]
        cell.configure(with: record)
        
        // Staggered animation for cells
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 30)
        
        UIView.animate(withDuration: 0.4, delay: Double(indexPath.item % 6) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            cell.alpha = 1.0
            cell.transform = .identity
        })
        
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension PetDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Implement parallax effect
        let offset = scrollView.contentOffset.y
        if offset < 0 {
            heroImageView.transform = CGAffineTransform(translationX: 0, y: offset * 0.5)
        }
    }
}

// MARK: - HealthRecordCell
class HealthRecordCell: UICollectionViewCell {
    private let containerView = UIView()
    private let leftBorderView = UIView()
    private let iconContainer = UIView()
    private let iconView = UIImageView()
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let veterinarianLabel = UILabel()
    private let statusContainer = UIView()
    private let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Container styling - çok daha modern ve şık
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.06
        containerView.layer.shadowRadius = 8
        
        // Sol kenar çizgisi - renkli vurgu
        leftBorderView.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        leftBorderView.layer.cornerRadius = 2
        leftBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon container - modern tasarım
        iconContainer.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        iconContainer.layer.cornerRadius = 12
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        // Content stack view
        contentStackView.axis = .vertical
        contentStackView.spacing = 4
        contentStackView.alignment = .leading
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title label - daha büyük ve okunabilir
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Date label - daha belirgin
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        dateLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Veterinarian label - yeni eklenen
        veterinarianLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        veterinarianLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        veterinarianLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Status container - daha modern
        statusContainer.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        statusContainer.layer.cornerRadius = 10
        statusContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Status label
        statusLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        statusLabel.textColor = .white
        statusLabel.text = "Tamamlandı"
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubview(leftBorderView)
        containerView.addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        containerView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(dateLabel)
        contentStackView.addArrangedSubview(veterinarianLabel)
        containerView.addSubview(statusContainer)
        statusContainer.addSubview(statusLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            leftBorderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            leftBorderView.topAnchor.constraint(equalTo: containerView.topAnchor),
            leftBorderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            leftBorderView.widthAnchor.constraint(equalToConstant: 4),
            
            iconContainer.leadingAnchor.constraint(equalTo: leftBorderView.trailingAnchor, constant: 12),
            iconContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            contentStackView.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: statusContainer.leadingAnchor, constant: -12),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            statusContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            statusContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusContainer.widthAnchor.constraint(equalToConstant: 65),
            statusContainer.heightAnchor.constraint(equalToConstant: 20),
            
            statusLabel.centerXAnchor.constraint(equalTo: statusContainer.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusContainer.centerYAnchor)
        ])
    }
    
    func configure(with record: HealthRecordModel) {
        titleLabel.text = record.recordDescription
        dateLabel.text = formatDate(record.recordDate)
        veterinarianLabel.text = record.veterinarian ?? "Veteriner belirtilmemiş"
        
        // Set icon and color based on record type
        switch record.recordType {
        case .vaccination:
            iconView.image = UIImage(systemName: "syringe.fill")
            iconView.tintColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
            leftBorderView.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
            statusContainer.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        case .checkup:
            iconView.image = UIImage(systemName: "stethoscope")
            iconView.tintColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
            leftBorderView.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
            statusContainer.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        case .treatment:
            iconView.image = UIImage(systemName: "pills.fill")
            iconView.tintColor = UIColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0)
            leftBorderView.backgroundColor = UIColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0)
            statusContainer.backgroundColor = UIColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0)
        case .surgery:
            iconView.image = UIImage(systemName: "scissors")
            iconView.tintColor = UIColor(red: 0.8, green: 0.4, blue: 0.9, alpha: 1.0)
            leftBorderView.backgroundColor = UIColor(red: 0.8, green: 0.4, blue: 0.9, alpha: 1.0)
            statusContainer.backgroundColor = UIColor(red: 0.8, green: 0.4, blue: 0.9, alpha: 1.0)
        case .emergency:
            iconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
            iconView.tintColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
            leftBorderView.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
            statusContainer.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        case .grooming:
            iconView.image = UIImage(systemName: "scissors")
            iconView.tintColor = UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0)
            leftBorderView.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0)
            statusContainer.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0)
        case .medication:
            iconView.image = UIImage(systemName: "pills.fill")
            iconView.tintColor = UIColor(red: 0.6, green: 0.9, blue: 0.4, alpha: 1.0)
            leftBorderView.backgroundColor = UIColor(red: 0.6, green: 0.9, blue: 0.4, alpha: 1.0)
            statusContainer.backgroundColor = UIColor(red: 0.6, green: 0.9, blue: 0.4, alpha: 1.0)
        case .other:
            iconView.image = UIImage(systemName: "doc.text.fill")
            iconView.tintColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            leftBorderView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            statusContainer.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
} 
