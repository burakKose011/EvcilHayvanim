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
    private lazy var weightCard = createStatCard(title: "Kilo", icon: "scalemass.fill", color: .systemBlue)
    private lazy var ageCard = createStatCard(title: "Yaş", icon: "calendar", color: .systemGreen)
    private lazy var genderCard = createStatCard(title: "Cinsiyet", icon: "person.fill", color: .systemPink)
    private lazy var microchipCard = createStatCard(title: "Mikroçip", icon: "wave.3.right", color: .systemOrange)
    
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
    private let recordsCollectionView: UICollectionView
    
    // Floating Action Button
    private let fabButton = UIButton()
    
    // MARK: - Properties
    var pet: PetModel?
    private var recentHealthRecords: [HealthRecordModel] = []
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 300, height: 140)
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
        setupFAB()
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
            UIColor.black.withAlphaComponent(0.3).cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        heroGradientLayer.locations = [0.0, 0.6, 1.0]
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
        
        // Card styling
        petInfoCard.backgroundColor = .white
        petInfoCard.layer.cornerRadius = 24
        petInfoCard.layer.shadowColor = UIColor.black.cgColor
        petInfoCard.layer.shadowOffset = CGSize(width: 0, height: 8)
        petInfoCard.layer.shadowOpacity = 0.12
        petInfoCard.layer.shadowRadius = 20
        
        // Pet image container
        petImageContainer.backgroundColor = .white
        petImageContainer.layer.cornerRadius = 50
        petImageContainer.layer.borderWidth = 4
        petImageContainer.layer.borderColor = UIColor.white.cgColor
        petImageContainer.layer.shadowColor = UIColor.black.cgColor
        petImageContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        petImageContainer.layer.shadowOpacity = 0.15
        petImageContainer.layer.shadowRadius = 12
        
        // Pet image
        petImageView.contentMode = .scaleAspectFill
        petImageView.clipsToBounds = true
        petImageView.layer.cornerRadius = 46
        
        // Name label
        nameLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        nameLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        nameLabel.textAlignment = .center
        
        // Breed label
        breedLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        breedLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        breedLabel.textAlignment = .center
        
        // Age label
        ageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        ageLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        ageLabel.textAlignment = .center
        
        // Status badge
        statusBadge.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        statusBadge.layer.cornerRadius = 12
        
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        statusLabel.textColor = .white
        statusLabel.text = "Aktif"
        statusLabel.textAlignment = .center
        
        // Favorite button
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        favoriteButton.tintColor = .systemRed
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = 20
        favoriteButton.layer.shadowColor = UIColor.black.cgColor
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        favoriteButton.layer.shadowOpacity = 0.1
        favoriteButton.layer.shadowRadius = 8
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
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowOpacity = 0.06
        card.layer.shadowRadius = 8
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = "0"
        valueLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        valueLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(iconView)
        card.addSubview(titleLabel)
        card.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            iconView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            valueLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        return card
    }
    
    private func createActionButton(title: String, icon: String, color: UIColor) -> UIButton {
        let button = UIButton()
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = title
        buttonConfig.image = UIImage(systemName: icon)
        buttonConfig.imagePlacement = .top
        buttonConfig.imagePadding = 8
        buttonConfig.baseBackgroundColor = color.withAlphaComponent(0.1)
        buttonConfig.baseForegroundColor = color
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12)
        buttonConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            return outgoing
        }
        
        button.configuration = buttonConfig
        button.layer.cornerRadius = 16
        
        return button
    }
    
    private func setupActionsCard() {
        actionsCard.translatesAutoresizingMaskIntoConstraints = false
        actionsTitle.translatesAutoresizingMaskIntoConstraints = false
        actionsGrid.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        actionsCard.backgroundColor = .white
        actionsCard.layer.cornerRadius = 20
        actionsCard.layer.shadowColor = UIColor.black.cgColor
        actionsCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        actionsCard.layer.shadowOpacity = 0.08
        actionsCard.layer.shadowRadius = 16
        
        // Title
        actionsTitle.text = "Hızlı İşlemler"
        actionsTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        actionsTitle.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        // Actions grid
        actionsGrid.axis = .horizontal
        actionsGrid.distribution = .fillEqually
        actionsGrid.spacing = 16
        
        let addRecordButton = createActionButton(title: "Sağlık Kaydı", icon: "plus.circle.fill", color: .systemBlue)
        let addAppointmentButton = createActionButton(title: "Randevu", icon: "calendar.badge.plus", color: .systemGreen)
        let editButton = createActionButton(title: "Düzenle", icon: "pencil.circle.fill", color: .systemOrange)
        
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
        
        // Card styling
        healthCard.backgroundColor = .white
        healthCard.layer.cornerRadius = 20
        healthCard.layer.shadowColor = UIColor.black.cgColor
        healthCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        healthCard.layer.shadowOpacity = 0.08
        healthCard.layer.shadowRadius = 16
        
        // Title with icon
        healthTitle.text = "Sağlık Durumu"
        healthTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        healthTitle.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        healthIcon.image = UIImage(systemName: "heart.fill")
        healthIcon.tintColor = .systemRed
        healthIcon.contentMode = .scaleAspectFit
        
        // Progress view
        healthProgressView.progressTintColor = .systemGreen
        healthProgressView.trackTintColor = UIColor.systemGreen.withAlphaComponent(0.2)
        healthProgressView.layer.cornerRadius = 4
        healthProgressView.clipsToBounds = true
        healthProgressView.progress = 0.85
        
        // Stats stack
        healthStatsStack.axis = .horizontal
        healthStatsStack.distribution = .fillEqually
        healthStatsStack.spacing = 20
        
        let lastCheckup = createHealthStat(title: "Son Kontrol", value: "2 hafta önce", color: .systemBlue)
        let nextVaccine = createHealthStat(title: "Sonraki Aşı", value: "1 ay", color: .systemOrange)
        let overallHealth = createHealthStat(title: "Genel Durum", value: "Mükemmel", color: .systemGreen)
        
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
        
        // Card styling
        recordsCard.backgroundColor = .white
        recordsCard.layer.cornerRadius = 20
        recordsCard.layer.shadowColor = UIColor.black.cgColor
        recordsCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        recordsCard.layer.shadowOpacity = 0.08
        recordsCard.layer.shadowRadius = 16
        
        // Title
        recordsTitle.text = "Son Sağlık Kayıtları"
        recordsTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        recordsTitle.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        // Collection view
        recordsCollectionView.backgroundColor = .clear
        recordsCollectionView.showsHorizontalScrollIndicator = false
        recordsCollectionView.register(HealthRecordCell.self, forCellWithReuseIdentifier: "HealthRecordCell")
        recordsCollectionView.delegate = self
        recordsCollectionView.dataSource = self
        
        contentView.addSubview(recordsCard)
        recordsCard.addSubview(recordsTitle)
        recordsCard.addSubview(recordsCollectionView)
    }
    
    private func setupFAB() {
        fabButton.translatesAutoresizingMaskIntoConstraints = false
        
        fabButton.setImage(UIImage(systemName: "plus"), for: .normal)
        fabButton.tintColor = .white
        fabButton.backgroundColor = DesignSystem.Colors.primary
        fabButton.layer.cornerRadius = 28
        fabButton.layer.shadowColor = UIColor.black.cgColor
        fabButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        fabButton.layer.shadowOpacity = 0.2
        fabButton.layer.shadowRadius = 12
        fabButton.addTarget(self, action: #selector(fabTapped), for: .touchUpInside)
        
        view.addSubview(fabButton)
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
            heroContainer.heightAnchor.constraint(equalToConstant: 300),
            
            heroImageView.topAnchor.constraint(equalTo: heroContainer.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: heroContainer.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: heroContainer.trailingAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: heroContainer.bottomAnchor),
            
            heroOverlay.topAnchor.constraint(equalTo: heroContainer.topAnchor),
            heroOverlay.leadingAnchor.constraint(equalTo: heroContainer.leadingAnchor),
            heroOverlay.trailingAnchor.constraint(equalTo: heroContainer.trailingAnchor),
            heroOverlay.bottomAnchor.constraint(equalTo: heroContainer.bottomAnchor),
            
            // Pet Info Card
            petInfoCard.topAnchor.constraint(equalTo: heroContainer.bottomAnchor, constant: -60),
            petInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            petInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            petInfoCard.heightAnchor.constraint(equalToConstant: 200),
            
            petImageContainer.topAnchor.constraint(equalTo: petInfoCard.topAnchor, constant: -30),
            petImageContainer.centerXAnchor.constraint(equalTo: petInfoCard.centerXAnchor),
            petImageContainer.widthAnchor.constraint(equalToConstant: 100),
            petImageContainer.heightAnchor.constraint(equalToConstant: 100),
            
            petImageView.topAnchor.constraint(equalTo: petImageContainer.topAnchor, constant: 2),
            petImageView.leadingAnchor.constraint(equalTo: petImageContainer.leadingAnchor, constant: 2),
            petImageView.trailingAnchor.constraint(equalTo: petImageContainer.trailingAnchor, constant: -2),
            petImageView.bottomAnchor.constraint(equalTo: petImageContainer.bottomAnchor, constant: -2),
            
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
            statsGrid.heightAnchor.constraint(equalToConstant: 100),
            
            // Actions Card
            actionsCard.topAnchor.constraint(equalTo: statsGrid.bottomAnchor, constant: 24),
            actionsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionsCard.heightAnchor.constraint(equalToConstant: 140),
            
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
            healthCard.heightAnchor.constraint(equalToConstant: 160),
            
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
            recordsCard.heightAnchor.constraint(equalToConstant: 200),
            recordsCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            
            recordsTitle.topAnchor.constraint(equalTo: recordsCard.topAnchor, constant: 20),
            recordsTitle.leadingAnchor.constraint(equalTo: recordsCard.leadingAnchor, constant: 20),
            recordsTitle.trailingAnchor.constraint(equalTo: recordsCard.trailingAnchor, constant: -20),
            
            recordsCollectionView.topAnchor.constraint(equalTo: recordsTitle.bottomAnchor, constant: 20),
            recordsCollectionView.leadingAnchor.constraint(equalTo: recordsCard.leadingAnchor, constant: 20),
            recordsCollectionView.trailingAnchor.constraint(equalTo: recordsCard.trailingAnchor, constant: -20),
            recordsCollectionView.bottomAnchor.constraint(equalTo: recordsCard.bottomAnchor, constant: -20),
            
            // FAB
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fabButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            fabButton.widthAnchor.constraint(equalToConstant: 56),
            fabButton.heightAnchor.constraint(equalToConstant: 56)
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
        
        // Set hero background
        heroImageView.image = petImageView.image
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func moreOptionsTapped() {
        // Show more options menu
    }
    
    @objc private func favoriteTapped() {
        favoriteButton.isSelected.toggle()
        // Update favorite status
    }
    
    @objc private func addRecordTapped() {
        // Navigate to add health record
    }
    
    @objc private func addAppointmentTapped() {
        // Navigate to add appointment
    }
    
    @objc private func editTapped() {
        // Navigate to edit pet
    }
    
    @objc private func fabTapped() {
        // Show quick actions
    }
    
    private func loadRecentRecords() {
        // Load recent health records for this pet
        // This would typically come from a data manager
        recentHealthRecords = []
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HealthRecordCell", for: indexPath) as! HealthRecordCell
        // Configure cell with health record data
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
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        statusLabel.textColor = .white
        statusLabel.backgroundColor = .systemGreen
        statusLabel.layer.cornerRadius = 8
        statusLabel.layer.masksToBounds = true
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            statusLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            statusLabel.widthAnchor.constraint(equalToConstant: 60),
            statusLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with record: HealthRecordModel) {
        titleLabel.text = record.recordDescription
        dateLabel.text = formatDate(record.recordDate)
        statusLabel.text = "Tamamlandı"
        
        // Set icon based on record type
        switch record.recordType {
        case .vaccination:
            iconView.image = UIImage(systemName: "syringe.fill")
            iconView.tintColor = .systemGreen
        case .checkup:
            iconView.image = UIImage(systemName: "stethoscope")
            iconView.tintColor = .systemBlue
        case .treatment:
            iconView.image = UIImage(systemName: "pills.fill")
            iconView.tintColor = .systemOrange
        case .surgery:
            iconView.image = UIImage(systemName: "scissors")
            iconView.tintColor = .systemRed
        case .emergency:
            iconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
            iconView.tintColor = .systemRed
        case .grooming:
            iconView.image = UIImage(systemName: "scissors")
            iconView.tintColor = .systemPurple
        case .medication:
            iconView.image = UIImage(systemName: "pills.fill")
            iconView.tintColor = .systemBlue
        case .other:
            iconView.image = UIImage(systemName: "doc.text.fill")
            iconView.tintColor = .systemGray
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
} 
