//
//  PetListViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class PetListViewController: UIViewController {
    
    // MARK: - UI Elements
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private let addButton = UIButton()
    private let emptyStateView = UIView()
    private let emptyStateImageView = UIImageView()
    private let emptyStateLabel = UILabel()
    private let emptyStateSubtitle = UILabel()
    
    // MARK: - Properties
    private var pets: [PetModel] = []
    private var filteredPets: [PetModel] = []
    private var isSearching: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadPets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPets()
        
        // Add cute entrance animations
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) {
                CuteAnimations.slideInFromBottom(for: cell, delay: TimeInterval(i) * 0.1)
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.background
        title = "Sevimli Dostlarım"
        
        setupNavigationBar()
        setupSearchController()
        setupTableView()
        setupAddButton()
        setupEmptyState()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(addPetTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = DesignSystem.Colors.primary
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "🔍 Sevimli dostunu ara..."
        searchController.searchBar.tintColor = DesignSystem.Colors.primary
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PetTableViewCell.self, forCellReuseIdentifier: "PetCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
    }
    
    private func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("🐾 Yeni Dost Ekle", for: .normal)
        addButton.applyPrimaryStyle()
        addButton.layer.cornerRadius = DesignSystem.CornerRadius.large
        addButton.addTarget(self, action: #selector(addPetTapped), for: .touchUpInside)
        
        view.addSubview(addButton)
    }
    
    private func setupEmptyState() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateSubtitle.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateView.isHidden = true
        
        emptyStateImageView.image = UIImage(systemName: "pawprint.circle")
        emptyStateImageView.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        emptyStateImageView.contentMode = .scaleAspectFit
        
        emptyStateLabel.text = "Henüz sevimli dostunuz yok 🥺"
        emptyStateLabel.applyTitleStyle()
        emptyStateLabel.textAlignment = .center
        
        emptyStateSubtitle.text = "İlk evcil hayvanınızı ekleyerek bu güzel yolculuğa başlayın! 💕"
        emptyStateSubtitle.applySubtitleStyle()
        emptyStateSubtitle.textAlignment = .center
        emptyStateSubtitle.numberOfLines = 0
        
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(emptyStateSubtitle)
        view.addSubview(emptyStateView)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 56),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 16),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            emptyStateSubtitle.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: 8),
            emptyStateSubtitle.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateSubtitle.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyStateSubtitle.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    // MARK: - Data Loading
    private func loadPets() {
        pets = DataManager.shared.fetchPets()
        filteredPets = pets
        tableView.reloadData()
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        let isEmpty = filteredPets.isEmpty && !isSearching
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    private func filterPets(with searchText: String) {
        isSearching = !searchText.isEmpty
        if searchText.isEmpty {
            filteredPets = pets
        } else {
            filteredPets = pets.filter { pet in
                pet.name.localizedCaseInsensitiveContains(searchText) ||
                pet.breed.localizedCaseInsensitiveContains(searchText) ||
                pet.petType.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        tableView.reloadData()
        updateEmptyState()
    }
    
    // MARK: - Actions
    @objc private func addPetTapped() {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Add cute bounce animation
        CuteAnimations.bounceAnimation(for: addButton)
        
        let petFormVC = PetFormViewController()
        let navController = UINavigationController(rootViewController: petFormVC)
        present(navController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension PetListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetTableViewCell
        let pet = filteredPets[indexPath.row]
        cell.configure(with: pet)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PetListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Add cute bounce animation to selected cell
        if let cell = tableView.cellForRow(at: indexPath) {
            CuteAnimations.bounceAnimation(for: cell)
        }
        
        let pet = filteredPets[indexPath.row]
        let petDetailVC = PetDetailViewController()
        petDetailVC.pet = pet
        navigationController?.pushViewController(petDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { [weak self] (action, view, completion) in
            let pet = self?.filteredPets[indexPath.row]
            let petFormVC = PetFormViewController()
            petFormVC.pet = pet
            let navController = UINavigationController(rootViewController: petFormVC)
            self?.present(navController, animated: true)
            completion(true)
        }
        editAction.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        editAction.image = UIImage(systemName: "pencil")
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completion) in
            self?.showDeleteAlert(for: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func showDeleteAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Evcil Hayvanı Sil", message: "Bu evcil hayvanı silmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
            let pet = self?.filteredPets[indexPath.row]
            self?.deletePet(pet)
        })
        
        present(alert, animated: true)
    }
    
    private func deletePet(_ pet: PetModel?) {
        guard let pet = pet else { return }
        
        DataManager.shared.deletePet(pet)
        loadPets()
    }
}

// MARK: - UISearchResultsUpdating
extension PetListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterPets(with: searchText)
    }
}

// MARK: - PetTableViewCell
class PetTableViewCell: UITableViewCell {
    
    private let cardView = UIView()
    private let petImageView = UIImageView()
    private let petImageOverlay = UIView()
    private let nameLabel = UILabel()
    private let breedLabel = UILabel()
    private let ageLabel = UILabel()
    private let typeLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let statusIndicator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        petImageOverlay.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling with cute design
        cardView.backgroundColor = DesignSystem.Colors.cardBackground
        cardView.layer.cornerRadius = DesignSystem.CornerRadius.extraLarge
        cardView.layer.shadowColor = DesignSystem.Shadow.medium.color.cgColor
        cardView.layer.shadowOpacity = DesignSystem.Shadow.medium.opacity
        cardView.layer.shadowOffset = DesignSystem.Shadow.medium.offset
        cardView.layer.shadowRadius = DesignSystem.Shadow.medium.radius
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = DesignSystem.Colors.primaryLight.cgColor
        
        // Pet image styling
        petImageView.contentMode = .scaleAspectFill
        petImageView.clipsToBounds = true
        petImageView.layer.cornerRadius = 35
        petImageView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        petImageView.layer.borderWidth = 3
        petImageView.layer.borderColor = UIColor.white.cgColor
        
        // Pet image overlay
        petImageOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        petImageOverlay.layer.cornerRadius = 35
        petImageOverlay.isHidden = true
        
        // Label styling with design system
        nameLabel.applyHeadlineStyle()
        
        breedLabel.applySubtitleStyle()
        
        ageLabel.applyCaptionStyle()
        
        typeLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        typeLabel.textColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        typeLabel.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 0.1)
        typeLabel.layer.cornerRadius = 10
        typeLabel.textAlignment = .center
        
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        chevronImageView.contentMode = .scaleAspectFit
        
        // Status indicator
        statusIndicator.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.6, alpha: 1.0)
        statusIndicator.layer.cornerRadius = 6
        statusIndicator.layer.borderWidth = 2
        statusIndicator.layer.borderColor = UIColor.white.cgColor
        
        contentView.addSubview(cardView)
        cardView.addSubview(petImageView)
        cardView.addSubview(petImageOverlay)
        cardView.addSubview(nameLabel)
        cardView.addSubview(breedLabel)
        cardView.addSubview(ageLabel)
        cardView.addSubview(typeLabel)
        cardView.addSubview(chevronImageView)
        cardView.addSubview(statusIndicator)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            petImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            petImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            petImageView.widthAnchor.constraint(equalToConstant: 70),
            petImageView.heightAnchor.constraint(equalToConstant: 70),
            
            petImageOverlay.topAnchor.constraint(equalTo: petImageView.topAnchor),
            petImageOverlay.leadingAnchor.constraint(equalTo: petImageView.leadingAnchor),
            petImageOverlay.trailingAnchor.constraint(equalTo: petImageView.trailingAnchor),
            petImageOverlay.bottomAnchor.constraint(equalTo: petImageView.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: typeLabel.leadingAnchor, constant: -12),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            breedLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 20),
            breedLabel.trailingAnchor.constraint(equalTo: typeLabel.leadingAnchor, constant: -12),
            
            ageLabel.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 6),
            ageLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 20),
            ageLabel.trailingAnchor.constraint(equalTo: typeLabel.leadingAnchor, constant: -12),
            ageLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            
            typeLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            typeLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            typeLabel.widthAnchor.constraint(equalToConstant: 70),
            typeLabel.heightAnchor.constraint(equalToConstant: 24),
            
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            
            statusIndicator.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            statusIndicator.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            statusIndicator.widthAnchor.constraint(equalToConstant: 12),
            statusIndicator.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func configure(with pet: PetModel) {
        nameLabel.text = pet.name
        breedLabel.text = pet.breed
        
        let age = Calendar.current.dateComponents([.year], from: pet.birthDate, to: Date()).year ?? 0
        ageLabel.text = "\(age) yaşında"
        
        typeLabel.text = pet.petType.rawValue
        
        // Apply pet-specific colors and styling
        let petColor = DesignSystem.PetColors.colorForPetType(pet.petType)
        typeLabel.textColor = petColor
        typeLabel.backgroundColor = DesignSystem.PetColors.lightColorForPetType(pet.petType)
        
        // Set pet image with cute styling
        if pet.photoURL != nil {
            // TODO: Load image from URL
            petImageView.image = UIImage(systemName: DesignSystem.Icons.iconForPetType(pet.petType))
        } else {
            petImageView.image = UIImage(systemName: DesignSystem.Icons.iconForPetType(pet.petType))
        }
        petImageView.tintColor = petColor
        petImageView.layer.borderColor = petColor.cgColor
        
        // Update status indicator based on pet health
        updateStatusIndicator(for: pet)
    }
    
    private func updateStatusIndicator(for pet: PetModel) {
        // TODO: Implement health status logic
        // For now, show success color for all pets
        statusIndicator.backgroundColor = DesignSystem.Colors.success
        
        // Add cute pulse animation
        CuteAnimations.pulseAnimation(for: statusIndicator)
    }
} 