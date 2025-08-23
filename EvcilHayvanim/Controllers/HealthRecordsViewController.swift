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
    private let collectionView: UICollectionView
    private let floatingActionButton = UIButton()
    private let filterContainerView = UIView()
    private let currentFilterButton = UIButton()
    private let filterDropdownButton = UIButton()
    private let emptyStateView = UIView()
    private let emptyStateLabel = UILabel()
    private let emptyStateImageView = UIImageView()
    
    // Filter system
    private var currentFilterIndex = 0
    private let filterTypes: [(title: String, emoji: String, type: HealthRecordType?)] = [
        ("Tümü", "📋", nil),
        ("Aşı", "💉", .vaccination),
        ("Kontrol", "🩺", .checkup),
        ("Tedavi", "💊", .treatment),
        ("Acil", "🚨", .emergency),
        ("Bakım", "✂️", .grooming),
        ("Ameliyat", "🏥", .surgery),
        ("İlaç", "💊", .medication),
        ("Diğer", "📝", .other)
    ]
    
    // MARK: - Properties
    private var healthRecords: [HealthRecordModel] = []
    private var filteredRecords: [HealthRecordModel] = []
    private var selectedFilter: HealthRecordType? = nil
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 100, right: 16)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
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
        loadHealthRecords()
        setupAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHealthRecords()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.background
        title = "🏥 Sağlık Kayıtları"
        
        setupNavigationBar()
        setupSearchController()
        setupFilterContainer()
        setupCollectionView()
        setupFloatingActionButton()
        setupEmptyState()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = DesignSystem.Colors.background
        appearance.titleTextAttributes = [.foregroundColor: DesignSystem.Colors.textPrimary]
        appearance.largeTitleTextAttributes = [.foregroundColor: DesignSystem.Colors.textPrimary]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "🔍 Sağlık kaydı ara..."
        searchController.searchBar.tintColor = DesignSystem.Colors.primary
        searchController.searchBar.searchBarStyle = .minimal
        
        // Modern search bar styling
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = DesignSystem.Colors.cardBackground
            textField.layer.cornerRadius = 12
            textField.font = DesignSystem.Typography.callout
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupFilterContainer() {
        filterContainerView.translatesAutoresizingMaskIntoConstraints = false
        currentFilterButton.translatesAutoresizingMaskIntoConstraints = false
        filterDropdownButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Container styling
        filterContainerView.backgroundColor = DesignSystem.Colors.cardBackground
        filterContainerView.layer.cornerRadius = 16
        filterContainerView.layer.shadowColor = UIColor.black.cgColor
        filterContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        filterContainerView.layer.shadowOpacity = 0.1
        filterContainerView.layer.shadowRadius = 8
        
        // Current filter button
        updateCurrentFilterButton()
        currentFilterButton.contentHorizontalAlignment = .left
        currentFilterButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        currentFilterButton.addTarget(self, action: #selector(showFilterMenu), for: .touchUpInside)
        
        // Dropdown arrow button
        filterDropdownButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        filterDropdownButton.tintColor = DesignSystem.Colors.primary
        filterDropdownButton.addTarget(self, action: #selector(showFilterMenu), for: .touchUpInside)
        
        filterContainerView.addSubview(currentFilterButton)
        filterContainerView.addSubview(filterDropdownButton)
        view.addSubview(filterContainerView)
    }
    
    private func updateCurrentFilterButton() {
        let currentFilter = filterTypes[currentFilterIndex]
        let count = getFilterCount(for: currentFilter.type)
        
        // Create attributed string with emoji, title and count
        let attributedString = NSMutableAttributedString()
        
        // Emoji
        let emojiAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18)
        ]
        attributedString.append(NSAttributedString(string: "\(currentFilter.emoji) ", attributes: emojiAttributes))
        
        // Title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: DesignSystem.Colors.textPrimary
        ]
        attributedString.append(NSAttributedString(string: currentFilter.title, attributes: titleAttributes))
        
        // Count badge
        if count > 0 {
            let countAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
                .foregroundColor: DesignSystem.Colors.primary
            ]
            attributedString.append(NSAttributedString(string: " (\(count))", attributes: countAttributes))
        }
        
        currentFilterButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    private func getFilterCount(for type: HealthRecordType?) -> Int {
        if type == nil {
            return healthRecords.count
        }
        return healthRecords.filter { $0.recordType == type }.count
    }
    
    @objc private func showFilterMenu() {
        let alert = UIAlertController(title: "🏥 Kategori Seçin", message: "Hangi sağlık kayıtlarını görmek istiyorsunuz?", preferredStyle: .actionSheet)
        
        // Add filter options
        for (index, filterType) in filterTypes.enumerated() {
            let count = getFilterCount(for: filterType.type)
            let title = count > 0 ? "\(filterType.emoji) \(filterType.title) (\(count))" : "\(filterType.emoji) \(filterType.title)"
            
            let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.selectFilter(at: index)
            }
            
            // Highlight current selection
            if index == currentFilterIndex {
                action.setValue(DesignSystem.Colors.primary, forKey: "titleTextColor")
            }
            
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = filterContainerView
            popover.sourceRect = filterContainerView.bounds
            popover.permittedArrowDirections = .up
        }
        
        present(alert, animated: true)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func selectFilter(at index: Int) {
        let previousIndex = currentFilterIndex
        currentFilterIndex = index
        
        let filterType = filterTypes[index]
        selectedFilter = filterType.type
        
        // Update UI
        updateCurrentFilterButton()
        
        // Animate dropdown arrow
        UIView.animate(withDuration: 0.2) {
            self.filterDropdownButton.transform = CGAffineTransform(rotationAngle: 0)
        }
        
        // Apply filters with animation if changed
        if previousIndex != index {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                self.collectionView.alpha = 0.7
            }) { _ in
                self.applyFilters()
                UIView.animate(withDuration: 0.3, animations: {
                    self.collectionView.alpha = 1.0
                })
    }
        } else {
            applyFilters()
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        // Register custom cell
        collectionView.register(ModernHealthRecordCell.self, forCellWithReuseIdentifier: "ModernHealthRecordCell")
        
        view.addSubview(collectionView)
    }
    
    private func setupFloatingActionButton() {
        floatingActionButton.translatesAutoresizingMaskIntoConstraints = false
        floatingActionButton.backgroundColor = DesignSystem.Colors.primary
        floatingActionButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)), for: .normal)
        floatingActionButton.tintColor = .white
        floatingActionButton.layer.cornerRadius = 28
        floatingActionButton.layer.shadowColor = DesignSystem.Colors.primary.cgColor
        floatingActionButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        floatingActionButton.layer.shadowOpacity = 0.3
        floatingActionButton.layer.shadowRadius = 12
        
        floatingActionButton.addTarget(self, action: #selector(addHealthRecordTapped), for: .touchUpInside)
        
        // Add press animation
        floatingActionButton.addTarget(self, action: #selector(fabTouchDown), for: .touchDown)
        floatingActionButton.addTarget(self, action: #selector(fabTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        view.addSubview(floatingActionButton)
    }
    
    private func setupEmptyState() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateImageView.image = UIImage(systemName: "heart.text.square")
        emptyStateImageView.tintColor = DesignSystem.Colors.textSecondary.withAlphaComponent(0.6)
        emptyStateImageView.contentMode = .scaleAspectFit
        
        emptyStateLabel.text = "Henüz sağlık kaydı yok\n\n+ butonuna tıklayarak\nilk sağlık kaydınızı ekleyin! 🏥"
        emptyStateLabel.font = DesignSystem.Typography.callout
        emptyStateLabel.textColor = DesignSystem.Colors.textSecondary
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        view.addSubview(emptyStateView)
        
        emptyStateView.isHidden = true
        
        NSLayoutConstraint.activate([
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 24),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyStateLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Filter Container
            filterContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filterContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            filterContainerView.heightAnchor.constraint(equalToConstant: 56),
            
            currentFilterButton.topAnchor.constraint(equalTo: filterContainerView.topAnchor),
            currentFilterButton.leadingAnchor.constraint(equalTo: filterContainerView.leadingAnchor),
            currentFilterButton.bottomAnchor.constraint(equalTo: filterContainerView.bottomAnchor),
            currentFilterButton.trailingAnchor.constraint(equalTo: filterDropdownButton.leadingAnchor, constant: -8),
            
            filterDropdownButton.topAnchor.constraint(equalTo: filterContainerView.topAnchor),
            filterDropdownButton.bottomAnchor.constraint(equalTo: filterContainerView.bottomAnchor),
            filterDropdownButton.trailingAnchor.constraint(equalTo: filterContainerView.trailingAnchor),
            filterDropdownButton.widthAnchor.constraint(equalToConstant: 30),
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: filterContainerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Floating Action Button
            floatingActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            floatingActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            floatingActionButton.widthAnchor.constraint(equalToConstant: 56),
            floatingActionButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Empty State
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    // MARK: - Animations
    private func setupAnimations() {
        // Staggered animation for filter buttons
        // No longer needed as filter is a single button
        
        // FAB animation
        floatingActionButton.alpha = 0
        floatingActionButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
            self.floatingActionButton.alpha = 1.0
            self.floatingActionButton.transform = .identity
        })
    }
    
    // MARK: - Data Loading
    private func loadHealthRecords() {
        healthRecords = DataManager.shared.fetchHealthRecords()
        updateCurrentFilterButton() // Update button counts
        applyFilters()
    }
    
    private func applyFilters() {
        var filtered = healthRecords
        
        // Apply type filter
        if let selectedFilter = selectedFilter {
            filtered = filtered.filter { $0.recordType == selectedFilter }
        }
        
        // Apply search filter
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filtered = filtered.filter { record in
                record.recordDescription.localizedCaseInsensitiveContains(searchText) ||
                record.veterinarian?.localizedCaseInsensitiveContains(searchText) == true ||
                record.recordType.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredRecords = filtered.sorted { $0.recordDate > $1.recordDate }
        
        // Update empty state
        emptyStateView.isHidden = !filteredRecords.isEmpty
        collectionView.isHidden = filteredRecords.isEmpty
        
        // Update empty state message based on filter
        updateEmptyStateMessage()
        
        collectionView.reloadData()
    }
    
    private func updateEmptyStateMessage() {
        let currentFilter = filterTypes[currentFilterIndex]
        let filterName = currentFilter.title
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            emptyStateLabel.text = "'\(searchText)' için\n\(filterName) kategorisinde\nsonuç bulunamadı\n\nFarklı kelimeler\ndeneyin 🔍"
        } else {
            emptyStateLabel.text = "Henüz \(filterName) kaydı yok\n\n+ butonuna tıklayarak\nilk kaydınızı ekleyin! 🏥"
        }
    }
    
    // MARK: - Actions
    @objc private func addHealthRecordTapped() {
        let healthRecordFormVC = HealthRecordFormViewController()
        let navController = UINavigationController(rootViewController: healthRecordFormVC)
        navController.modalPresentationStyle = .pageSheet
        
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(navController, animated: true)
    }
    
    
    
    @objc private func fabTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.floatingActionButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    @objc private func fabTouchUp() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        UIView.animate(withDuration: 0.1) {
            self.floatingActionButton.transform = .identity
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HealthRecordsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredRecords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModernHealthRecordCell", for: indexPath) as! ModernHealthRecordCell
        let record = filteredRecords[indexPath.item]
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

// MARK: - UICollectionViewDelegate
extension HealthRecordsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let record = filteredRecords[indexPath.item]
        let recordDetailVC = HealthRecordDetailViewController()
        recordDetailVC.healthRecord = record
        navigationController?.pushViewController(recordDetailVC, animated: true)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HealthRecordsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) // 16 + 16 + 16 (margins + spacing)
        return CGSize(width: width, height: 140)
    }
}

// MARK: - UISearchResultsUpdating
extension HealthRecordsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        applyFilters()
    }
}

// MARK: - ModernHealthRecordCell
class ModernHealthRecordCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let typeIconView = UIImageView()
    private let typeLabel = UILabel()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let veterinarianLabel = UILabel()
    private let statusIndicator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        typeIconView.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        veterinarianLabel.translatesAutoresizingMaskIntoConstraints = false
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Container styling
        containerView.backgroundColor = DesignSystem.Colors.cardBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 8
        
        // Type icon styling
        typeIconView.contentMode = .scaleAspectFit
        typeIconView.backgroundColor = DesignSystem.Colors.primary.withAlphaComponent(0.1)
        typeIconView.layer.cornerRadius = 20
        typeIconView.tintColor = DesignSystem.Colors.primary
        
        // Labels styling
        typeLabel.font = DesignSystem.Typography.caption1
        typeLabel.textColor = DesignSystem.Colors.primary
        
        titleLabel.font = DesignSystem.Typography.headline
        titleLabel.textColor = DesignSystem.Colors.textPrimary
        titleLabel.numberOfLines = 2
        
        dateLabel.font = DesignSystem.Typography.subheadline
        dateLabel.textColor = DesignSystem.Colors.textSecondary
        
        veterinarianLabel.font = DesignSystem.Typography.caption1
        veterinarianLabel.textColor = DesignSystem.Colors.textSecondary
        
        // Status indicator
        statusIndicator.backgroundColor = DesignSystem.Colors.success
        statusIndicator.layer.cornerRadius = 3
        
        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubview(typeIconView)
        containerView.addSubview(typeLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(veterinarianLabel)
        containerView.addSubview(statusIndicator)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            typeIconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            typeIconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            typeIconView.widthAnchor.constraint(equalToConstant: 40),
            typeIconView.heightAnchor.constraint(equalToConstant: 40),
            
            statusIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            statusIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusIndicator.widthAnchor.constraint(equalToConstant: 6),
            statusIndicator.heightAnchor.constraint(equalToConstant: 6),
            
            typeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            typeLabel.leadingAnchor.constraint(equalTo: typeIconView.trailingAnchor, constant: 12),
            typeLabel.trailingAnchor.constraint(equalTo: statusIndicator.leadingAnchor, constant: -12),
            
            titleLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: typeIconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: typeIconView.trailingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            veterinarianLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            veterinarianLabel.leadingAnchor.constraint(equalTo: typeIconView.trailingAnchor, constant: 12),
            veterinarianLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            veterinarianLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with record: HealthRecordModel) {
        typeLabel.text = record.recordType.rawValue.uppercased()
        titleLabel.text = record.recordDescription
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateLabel.text = dateFormatter.string(from: record.recordDate)
        
        veterinarianLabel.text = record.veterinarian ?? "Veteriner belirtilmemiş"
        
        // Set icon and color based on record type
        let (icon, color) = getIconAndColor(for: record.recordType)
        typeIconView.image = UIImage(systemName: icon)
        typeIconView.tintColor = color
        typeIconView.backgroundColor = color.withAlphaComponent(0.1)
        typeLabel.textColor = color
        statusIndicator.backgroundColor = color
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        alpha = 1.0
        transform = .identity
    }
} 
