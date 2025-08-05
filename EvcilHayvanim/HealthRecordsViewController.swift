//
//  HealthRecordsViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class HealthRecordsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private let addButton = UIButton()
    private let filterSegmentedControl = UISegmentedControl(items: ["Tümü", "Aşı", "Kontrol", "Tedavi"])
    
    // MARK: - Properties
    private var healthRecords: [HealthRecord] = []
    private var filteredRecords: [HealthRecord] = []
    private var selectedFilter: HealthRecordType? = nil
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadHealthRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHealthRecords()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Sağlık Kayıtları"
        
        setupNavigationBar()
        setupSearchController()
        setupFilterControl()
        setupTableView()
        setupAddButton()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addHealthRecordTapped)
        )
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Sağlık kaydı ara..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupFilterControl() {
        filterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        filterSegmentedControl.selectedSegmentIndex = 0
        filterSegmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        
        view.addSubview(filterSegmentedControl)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HealthRecordTableViewCell.self, forCellReuseIdentifier: "HealthRecordCell")
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
    }
    
    private func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("+ Yeni Sağlık Kaydı", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 12
        addButton.addTarget(self, action: #selector(addHealthRecordTapped), for: .touchUpInside)
        
        view.addSubview(addButton)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filterSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            filterSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filterSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            filterSegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            tableView.topAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor, constant: 10),
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
    private func loadHealthRecords() {
        // TODO: Load from Core Data
        healthRecords = [
            HealthRecord(id: UUID(), petId: UUID(), date: Date().addingTimeInterval(-7*24*60*60), type: .vaccination, description: "Kuduz aşısı yapıldı", veterinarian: "Dr. Ahmet Yılmaz", attachments: []),
            HealthRecord(id: UUID(), petId: UUID(), date: Date().addingTimeInterval(-14*24*60*60), type: .checkup, description: "Genel sağlık kontrolü", veterinarian: "Dr. Ayşe Demir", attachments: []),
            HealthRecord(id: UUID(), petId: UUID(), date: Date().addingTimeInterval(-30*24*60*60), type: .treatment, description: "Kulak enfeksiyonu tedavisi", veterinarian: "Dr. Mehmet Kaya", attachments: [])
        ]
        
        applyFilters()
    }
    
    private func applyFilters() {
        var filtered = healthRecords
        
        // Apply type filter
        if let selectedFilter = selectedFilter {
            filtered = filtered.filter { $0.type == selectedFilter }
        }
        
        // Apply search filter
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filtered = filtered.filter { record in
                record.description.localizedCaseInsensitiveContains(searchText) ||
                record.veterinarian?.localizedCaseInsensitiveContains(searchText) == true ||
                record.type.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredRecords = filtered
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func addHealthRecordTapped() {
        let healthRecordFormVC = HealthRecordFormViewController()
        let navController = UINavigationController(rootViewController: healthRecordFormVC)
        present(navController, animated: true)
    }
    
    @objc private func filterChanged() {
        switch filterSegmentedControl.selectedSegmentIndex {
        case 0:
            selectedFilter = nil
        case 1:
            selectedFilter = .vaccination
        case 2:
            selectedFilter = .checkup
        case 3:
            selectedFilter = .treatment
        default:
            selectedFilter = nil
        }
        
        applyFilters()
    }
}

// MARK: - UITableViewDataSource
extension HealthRecordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthRecordCell", for: indexPath) as! HealthRecordTableViewCell
        let record = filteredRecords[indexPath.row]
        cell.configure(with: record)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HealthRecordsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let record = filteredRecords[indexPath.row]
        let recordDetailVC = HealthRecordDetailViewController()
        recordDetailVC.healthRecord = record
        navigationController?.pushViewController(recordDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { [weak self] (action, view, completion) in
            let record = self?.filteredRecords[indexPath.row]
            let recordFormVC = HealthRecordFormViewController()
            recordFormVC.healthRecord = record
            let navController = UINavigationController(rootViewController: recordFormVC)
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
        let alert = UIAlertController(title: "Sağlık Kaydını Sil", message: "Bu sağlık kaydını silmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
            let record = self?.filteredRecords[indexPath.row]
            self?.deleteHealthRecord(record)
        })
        
        present(alert, animated: true)
    }
    
    private func deleteHealthRecord(_ record: HealthRecord?) {
        guard let record = record else { return }
        
        // TODO: Delete from Core Data
        if let index = healthRecords.firstIndex(where: { $0.id == record.id }) {
            healthRecords.remove(at: index)
        }
        if let index = filteredRecords.firstIndex(where: { $0.id == record.id }) {
            filteredRecords.remove(at: index)
        }
        
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension HealthRecordsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        applyFilters()
    }
}

// MARK: - HealthRecordTableViewCell
class HealthRecordTableViewCell: UITableViewCell {
    
    private let typeImageView = UIImageView()
    private let typeLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let veterinarianLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        typeImageView.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        veterinarianLabel.translatesAutoresizingMaskIntoConstraints = false
        
        typeImageView.contentMode = .scaleAspectFit
        typeImageView.tintColor = .systemBlue
        typeImageView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        typeImageView.layer.cornerRadius = 20
        
        typeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        typeLabel.textColor = .systemBlue
        typeLabel.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        typeLabel.layer.cornerRadius = 8
        typeLabel.textAlignment = .center
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 2
        
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel
        
        veterinarianLabel.font = UIFont.systemFont(ofSize: 12)
        veterinarianLabel.textColor = .tertiaryLabel
        
        contentView.addSubview(typeImageView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(veterinarianLabel)
        
        NSLayoutConstraint.activate([
            typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeImageView.widthAnchor.constraint(equalToConstant: 40),
            typeImageView.heightAnchor.constraint(equalToConstant: 40),
            
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            typeLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 12),
            typeLabel.widthAnchor.constraint(equalToConstant: 60),
            typeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            veterinarianLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
            veterinarianLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 12),
            veterinarianLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            veterinarianLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with record: HealthRecord) {
        typeLabel.text = record.type.rawValue
        
        switch record.type {
        case .vaccination:
            typeImageView.image = UIImage(systemName: "syringe")
        case .checkup:
            typeImageView.image = UIImage(systemName: "stethoscope")
        case .treatment:
            typeImageView.image = UIImage(systemName: "pills")
        case .surgery:
            typeImageView.image = UIImage(systemName: "scissors")
        case .medication:
            typeImageView.image = UIImage(systemName: "pills")
        case .other:
            typeImageView.image = UIImage(systemName: "heart")
        }
        
        descriptionLabel.text = record.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, HH:mm"
        dateLabel.text = dateFormatter.string(from: record.date)
        veterinarianLabel.text = record.veterinarian ?? "Veteriner bilgisi yok"
    }
} 