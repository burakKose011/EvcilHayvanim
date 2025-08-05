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
    
    // MARK: - Properties
    private var pets: [Pet] = []
    private var filteredPets: [Pet] = []
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
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Evcil Hayvanlarım"
        
        setupNavigationBar()
        setupSearchController()
        setupTableView()
        setupAddButton()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addPetTapped)
        )
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Evcil hayvan ara..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PetTableViewCell.self, forCellReuseIdentifier: "PetCell")
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
    }
    
    private func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("+ Yeni Evcil Hayvan Ekle", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 12
        addButton.addTarget(self, action: #selector(addPetTapped), for: .touchUpInside)
        
        view.addSubview(addButton)
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
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Data Loading
    private func loadPets() {
        // TODO: Load from Core Data
        pets = [
            Pet(id: UUID(), name: "Boncuk", type: .cat, breed: "Tekir", birthDate: Date().addingTimeInterval(-365*24*60*60*2), weight: 4.2, gender: .female, microchipNumber: "123456789", photoURL: nil),
            Pet(id: UUID(), name: "Karabaş", type: .dog, breed: "Golden Retriever", birthDate: Date().addingTimeInterval(-365*24*60*60*3), weight: 25.5, gender: .male, microchipNumber: "987654321", photoURL: nil),
            Pet(id: UUID(), name: "Maviş", type: .bird, breed: "Muhabbet Kuşu", birthDate: Date().addingTimeInterval(-365*24*60*60), weight: 0.05, gender: .male, microchipNumber: nil, photoURL: nil)
        ]
        
        filteredPets = pets
        tableView.reloadData()
    }
    
    private func filterPets(with searchText: String) {
        if searchText.isEmpty {
            filteredPets = pets
        } else {
            filteredPets = pets.filter { pet in
                pet.name.localizedCaseInsensitiveContains(searchText) ||
                pet.breed.localizedCaseInsensitiveContains(searchText) ||
                pet.type.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func addPetTapped() {
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
        
        let pet = filteredPets[indexPath.row]
        let petDetailVC = PetDetailViewController()
        petDetailVC.pet = pet
        navigationController?.pushViewController(petDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
        editAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completion) in
            self?.showDeleteAlert(for: indexPath)
            completion(true)
        }
        
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
    
    private func deletePet(_ pet: Pet?) {
        guard let pet = pet else { return }
        
        // TODO: Delete from Core Data
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets.remove(at: index)
        }
        if let index = filteredPets.firstIndex(where: { $0.id == pet.id }) {
            filteredPets.remove(at: index)
        }
        
        tableView.reloadData()
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
    
    private let petImageView = UIImageView()
    private let nameLabel = UILabel()
    private let breedLabel = UILabel()
    private let ageLabel = UILabel()
    private let typeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        petImageView.contentMode = .scaleAspectFill
        petImageView.clipsToBounds = true
        petImageView.layer.cornerRadius = 25
        petImageView.backgroundColor = .systemGray5
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .label
        
        breedLabel.font = UIFont.systemFont(ofSize: 14)
        breedLabel.textColor = .secondaryLabel
        
        ageLabel.font = UIFont.systemFont(ofSize: 12)
        ageLabel.textColor = .tertiaryLabel
        
        typeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        typeLabel.textColor = .systemBlue
        typeLabel.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        typeLabel.layer.cornerRadius = 8
        typeLabel.textAlignment = .center
        
        contentView.addSubview(petImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(breedLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(typeLabel)
        
        NSLayoutConstraint.activate([
            petImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            petImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            petImageView.widthAnchor.constraint(equalToConstant: 50),
            petImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: typeLabel.leadingAnchor, constant: -8),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            breedLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 12),
            breedLabel.trailingAnchor.constraint(equalTo: typeLabel.leadingAnchor, constant: -8),
            
            ageLabel.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 2),
            ageLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 12),
            ageLabel.trailingAnchor.constraint(equalTo: typeLabel.leadingAnchor, constant: -8),
            ageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            typeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            typeLabel.widthAnchor.constraint(equalToConstant: 60),
            typeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with pet: Pet) {
        nameLabel.text = pet.name
        breedLabel.text = pet.breed
        
        let age = Calendar.current.dateComponents([.year], from: pet.birthDate, to: Date()).year ?? 0
        ageLabel.text = "\(age) yaşında"
        
        typeLabel.text = pet.type.rawValue
        
        // TODO: Load pet image from URL
        petImageView.image = UIImage(systemName: pet.type.iconName)
        petImageView.tintColor = .systemGray
    }
}

// Models are now defined in Models.swift 