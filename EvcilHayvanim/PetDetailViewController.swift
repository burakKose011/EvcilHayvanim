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
    
    private let petImageView = UIImageView()
    private let nameLabel = UILabel()
    private let breedLabel = UILabel()
    private let ageLabel = UILabel()
    private let weightLabel = UILabel()
    private let genderLabel = UILabel()
    private let microchipLabel = UILabel()
    
    private let healthSummaryCard = UIView()
    private let healthSummaryTitle = UILabel()
    private let lastCheckupLabel = UILabel()
    private let nextVaccinationLabel = UILabel()
    private let currentWeightLabel = UILabel()
    
    private let quickActionsCard = UIView()
    private let quickActionsTitle = UILabel()
    private let addHealthRecordButton = UIButton()
    private let addAppointmentButton = UIButton()
    private let addWeightButton = UIButton()
    private let addPhotoButton = UIButton()
    
    private let recentRecordsCard = UIView()
    private let recentRecordsTitle = UILabel()
    private let recordsTableView = UITableView()
    
    // MARK: - Properties
    var pet: Pet?
    private var recentHealthRecords: [HealthRecord] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadPetData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecentRecords()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = pet?.name ?? "Evcil Hayvan Detayı"
        
        setupNavigationBar()
        setupScrollView()
        setupPetInfoSection()
        setupHealthSummaryCard()
        setupQuickActionsCard()
        setupRecentRecordsCard()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(editPetTapped)
        )
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupPetInfoSection() {
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        microchipLabel.translatesAutoresizingMaskIntoConstraints = false
        
        petImageView.contentMode = .scaleAspectFill
        petImageView.clipsToBounds = true
        petImageView.layer.cornerRadius = 50
        petImageView.backgroundColor = .systemGray5
        
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        
        breedLabel.font = UIFont.systemFont(ofSize: 16)
        breedLabel.textColor = .secondaryLabel
        breedLabel.textAlignment = .center
        
        ageLabel.font = UIFont.systemFont(ofSize: 14)
        ageLabel.textColor = .tertiaryLabel
        ageLabel.textAlignment = .center
        
        weightLabel.font = UIFont.systemFont(ofSize: 14)
        weightLabel.textColor = .tertiaryLabel
        weightLabel.textAlignment = .center
        
        genderLabel.font = UIFont.systemFont(ofSize: 14)
        genderLabel.textColor = .tertiaryLabel
        genderLabel.textAlignment = .center
        
        microchipLabel.font = UIFont.systemFont(ofSize: 14)
        microchipLabel.textColor = .tertiaryLabel
        microchipLabel.textAlignment = .center
        
        contentView.addSubview(petImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(breedLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(weightLabel)
        contentView.addSubview(genderLabel)
        contentView.addSubview(microchipLabel)
    }
    
    private func setupHealthSummaryCard() {
        healthSummaryCard.translatesAutoresizingMaskIntoConstraints = false
        healthSummaryTitle.translatesAutoresizingMaskIntoConstraints = false
        lastCheckupLabel.translatesAutoresizingMaskIntoConstraints = false
        nextVaccinationLabel.translatesAutoresizingMaskIntoConstraints = false
        currentWeightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        healthSummaryCard.backgroundColor = .systemBlue
        healthSummaryCard.layer.cornerRadius = 12
        
        healthSummaryTitle.text = "Sağlık Özeti"
        healthSummaryTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        healthSummaryTitle.textColor = .white
        
        lastCheckupLabel.font = UIFont.systemFont(ofSize: 14)
        lastCheckupLabel.textColor = .white
        lastCheckupLabel.numberOfLines = 0
        
        nextVaccinationLabel.font = UIFont.systemFont(ofSize: 14)
        nextVaccinationLabel.textColor = .white
        nextVaccinationLabel.numberOfLines = 0
        
        currentWeightLabel.font = UIFont.systemFont(ofSize: 14)
        currentWeightLabel.textColor = .white
        currentWeightLabel.numberOfLines = 0
        
        contentView.addSubview(healthSummaryCard)
        healthSummaryCard.addSubview(healthSummaryTitle)
        healthSummaryCard.addSubview(lastCheckupLabel)
        healthSummaryCard.addSubview(nextVaccinationLabel)
        healthSummaryCard.addSubview(currentWeightLabel)
    }
    
    private func setupQuickActionsCard() {
        quickActionsCard.translatesAutoresizingMaskIntoConstraints = false
        quickActionsTitle.translatesAutoresizingMaskIntoConstraints = false
        addHealthRecordButton.translatesAutoresizingMaskIntoConstraints = false
        addAppointmentButton.translatesAutoresizingMaskIntoConstraints = false
        addWeightButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        quickActionsCard.backgroundColor = .systemBackground
        quickActionsCard.layer.cornerRadius = 12
        quickActionsCard.layer.borderWidth = 1
        quickActionsCard.layer.borderColor = UIColor.systemGray4.cgColor
        
        quickActionsTitle.text = "Hızlı İşlemler"
        quickActionsTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        quickActionsTitle.textColor = .label
        
        setupQuickActionButton(addHealthRecordButton, title: "Sağlık Kaydı", icon: "heart")
        setupQuickActionButton(addAppointmentButton, title: "Randevu", icon: "calendar")
        setupQuickActionButton(addWeightButton, title: "Kilo Ekle", icon: "scalemass")
        setupQuickActionButton(addPhotoButton, title: "Fotoğraf", icon: "camera")
        
        contentView.addSubview(quickActionsCard)
        quickActionsCard.addSubview(quickActionsTitle)
        quickActionsCard.addSubview(addHealthRecordButton)
        quickActionsCard.addSubview(addAppointmentButton)
        quickActionsCard.addSubview(addWeightButton)
        quickActionsCard.addSubview(addPhotoButton)
    }
    
    private func setupQuickActionButton(_ button: UIButton, title: String, icon: String) {
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(systemName: icon), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        button.layer.cornerRadius = 8
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        
        button.addTarget(self, action: #selector(quickActionTapped(_:)), for: .touchUpInside)
    }
    
    private func setupRecentRecordsCard() {
        recentRecordsCard.translatesAutoresizingMaskIntoConstraints = false
        recentRecordsTitle.translatesAutoresizingMaskIntoConstraints = false
        recordsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        recentRecordsCard.backgroundColor = .systemBackground
        recentRecordsCard.layer.cornerRadius = 12
        recentRecordsCard.layer.borderWidth = 1
        recentRecordsCard.layer.borderColor = UIColor.systemGray4.cgColor
        
        recentRecordsTitle.text = "Son Sağlık Kayıtları"
        recentRecordsTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        recentRecordsTitle.textColor = .label
        
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        recordsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecordCell")
        recordsTableView.isScrollEnabled = false
        recordsTableView.backgroundColor = .clear
        
        contentView.addSubview(recentRecordsCard)
        recentRecordsCard.addSubview(recentRecordsTitle)
        recentRecordsCard.addSubview(recordsTableView)
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
            
            // Pet Info Section
            petImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            petImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            petImageView.widthAnchor.constraint(equalToConstant: 100),
            petImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: petImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            breedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            breedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ageLabel.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 4),
            ageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            weightLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 4),
            weightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            genderLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 4),
            genderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            microchipLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 4),
            microchipLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            microchipLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Health Summary Card
            healthSummaryCard.topAnchor.constraint(equalTo: microchipLabel.bottomAnchor, constant: 20),
            healthSummaryCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            healthSummaryCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            healthSummaryCard.heightAnchor.constraint(equalToConstant: 120),
            
            healthSummaryTitle.topAnchor.constraint(equalTo: healthSummaryCard.topAnchor, constant: 16),
            healthSummaryTitle.leadingAnchor.constraint(equalTo: healthSummaryCard.leadingAnchor, constant: 16),
            healthSummaryTitle.trailingAnchor.constraint(equalTo: healthSummaryCard.trailingAnchor, constant: -16),
            
            lastCheckupLabel.topAnchor.constraint(equalTo: healthSummaryTitle.bottomAnchor, constant: 8),
            lastCheckupLabel.leadingAnchor.constraint(equalTo: healthSummaryCard.leadingAnchor, constant: 16),
            lastCheckupLabel.trailingAnchor.constraint(equalTo: healthSummaryCard.trailingAnchor, constant: -16),
            
            nextVaccinationLabel.topAnchor.constraint(equalTo: lastCheckupLabel.bottomAnchor, constant: 4),
            nextVaccinationLabel.leadingAnchor.constraint(equalTo: healthSummaryCard.leadingAnchor, constant: 16),
            nextVaccinationLabel.trailingAnchor.constraint(equalTo: healthSummaryCard.trailingAnchor, constant: -16),
            
            currentWeightLabel.topAnchor.constraint(equalTo: nextVaccinationLabel.bottomAnchor, constant: 4),
            currentWeightLabel.leadingAnchor.constraint(equalTo: healthSummaryCard.leadingAnchor, constant: 16),
            currentWeightLabel.trailingAnchor.constraint(equalTo: healthSummaryCard.trailingAnchor, constant: -16),
            currentWeightLabel.bottomAnchor.constraint(equalTo: healthSummaryCard.bottomAnchor, constant: -16),
            
            // Quick Actions Card
            quickActionsCard.topAnchor.constraint(equalTo: healthSummaryCard.bottomAnchor, constant: 20),
            quickActionsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            quickActionsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            quickActionsCard.heightAnchor.constraint(equalToConstant: 240),
            
            quickActionsTitle.topAnchor.constraint(equalTo: quickActionsCard.topAnchor, constant: 16),
            quickActionsTitle.leadingAnchor.constraint(equalTo: quickActionsCard.leadingAnchor, constant: 16),
            quickActionsTitle.trailingAnchor.constraint(equalTo: quickActionsCard.trailingAnchor, constant: -16),
            
            addHealthRecordButton.topAnchor.constraint(equalTo: quickActionsTitle.bottomAnchor, constant: 12),
            addHealthRecordButton.leadingAnchor.constraint(equalTo: quickActionsCard.leadingAnchor, constant: 16),
            addHealthRecordButton.trailingAnchor.constraint(equalTo: quickActionsCard.trailingAnchor, constant: -16),
            addHealthRecordButton.heightAnchor.constraint(equalToConstant: 44),
            
            addAppointmentButton.topAnchor.constraint(equalTo: addHealthRecordButton.bottomAnchor, constant: 8),
            addAppointmentButton.leadingAnchor.constraint(equalTo: quickActionsCard.leadingAnchor, constant: 16),
            addAppointmentButton.trailingAnchor.constraint(equalTo: quickActionsCard.trailingAnchor, constant: -16),
            addAppointmentButton.heightAnchor.constraint(equalToConstant: 44),
            
            addWeightButton.topAnchor.constraint(equalTo: addAppointmentButton.bottomAnchor, constant: 8),
            addWeightButton.leadingAnchor.constraint(equalTo: quickActionsCard.leadingAnchor, constant: 16),
            addWeightButton.trailingAnchor.constraint(equalTo: quickActionsCard.trailingAnchor, constant: -16),
            addWeightButton.heightAnchor.constraint(equalToConstant: 44),
            
            addPhotoButton.topAnchor.constraint(equalTo: addWeightButton.bottomAnchor, constant: 8),
            addPhotoButton.leadingAnchor.constraint(equalTo: quickActionsCard.leadingAnchor, constant: 16),
            addPhotoButton.trailingAnchor.constraint(equalTo: quickActionsCard.trailingAnchor, constant: -16),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Recent Records Card
            recentRecordsCard.topAnchor.constraint(equalTo: quickActionsCard.bottomAnchor, constant: 20),
            recentRecordsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recentRecordsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recentRecordsCard.heightAnchor.constraint(equalToConstant: 200),
            recentRecordsCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            recentRecordsTitle.topAnchor.constraint(equalTo: recentRecordsCard.topAnchor, constant: 16),
            recentRecordsTitle.leadingAnchor.constraint(equalTo: recentRecordsCard.leadingAnchor, constant: 16),
            recentRecordsTitle.trailingAnchor.constraint(equalTo: recentRecordsCard.trailingAnchor, constant: -16),
            
            recordsTableView.topAnchor.constraint(equalTo: recentRecordsTitle.bottomAnchor, constant: 12),
            recordsTableView.leadingAnchor.constraint(equalTo: recentRecordsCard.leadingAnchor, constant: 16),
            recordsTableView.trailingAnchor.constraint(equalTo: recentRecordsCard.trailingAnchor, constant: -16),
            recordsTableView.bottomAnchor.constraint(equalTo: recentRecordsCard.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Data Loading
    private func loadPetData() {
        guard let pet = pet else { return }
        
        title = pet.name
        nameLabel.text = pet.name
        breedLabel.text = pet.breed
        
        let age = Calendar.current.dateComponents([.year], from: pet.birthDate, to: Date()).year ?? 0
        ageLabel.text = "\(age) yaşında"
        
        weightLabel.text = "\(pet.weight) kg"
        genderLabel.text = pet.gender.rawValue
        
        if let microchip = pet.microchipNumber {
            microchipLabel.text = "Mikroçip: \(microchip)"
        } else {
            microchipLabel.text = "Mikroçip: Yok"
        }
        
        // TODO: Load pet image from URL
        petImageView.image = UIImage(systemName: pet.type.iconName)
        petImageView.tintColor = .systemGray
        
        updateHealthSummary()
    }
    
    private func updateHealthSummary() {
        guard let pet = pet else { return }
        
        // TODO: Load from Core Data
        lastCheckupLabel.text = "Son kontrol: 2 hafta önce"
        nextVaccinationLabel.text = "Sonraki aşı: 1 ay sonra"
        currentWeightLabel.text = "Mevcut kilo: \(pet.weight) kg"
    }
    
    private func loadRecentRecords() {
        // TODO: Load from Core Data
        recentHealthRecords = []
        recordsTableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func editPetTapped() {
        let petFormVC = PetFormViewController()
        petFormVC.pet = pet
        let navController = UINavigationController(rootViewController: petFormVC)
        present(navController, animated: true)
    }
    
    @objc private func quickActionTapped(_ sender: UIButton) {
        switch sender {
        case addHealthRecordButton:
            let healthRecordFormVC = HealthRecordFormViewController()
            healthRecordFormVC.pet = pet
            navigationController?.pushViewController(healthRecordFormVC, animated: true)
        case addAppointmentButton:
            let appointmentFormVC = AppointmentFormViewController()
            appointmentFormVC.pet = pet
            navigationController?.pushViewController(appointmentFormVC, animated: true)
        case addWeightButton:
            showWeightInputAlert()
        case addPhotoButton:
            showImagePicker()
        default:
            break
        }
    }
    
    private func showWeightInputAlert() {
        let alert = UIAlertController(title: "Kilo Ekle", message: "Yeni kilo değerini girin", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Kilo (kg)"
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Kaydet", style: .default) { [weak self] _ in
            if let text = alert.textFields?.first?.text, let weight = Double(text) {
                self?.saveWeight(weight)
            }
        })
        
        present(alert, animated: true)
    }
    
    private func saveWeight(_ weight: Double) {
        // TODO: Save to Core Data
        weightLabel.text = "\(weight) kg"
        
        let alert = UIAlertController(title: "Başarılı", message: "Kilo kaydedildi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension PetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(recentHealthRecords.count, 3)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)
        
        if indexPath.row < recentHealthRecords.count {
            let record = recentHealthRecords[indexPath.row]
            cell.textLabel?.text = record.type.rawValue
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, HH:mm"
            cell.detailTextLabel?.text = dateFormatter.string(from: record.date)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PetDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            petImageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// Models are now defined in Models.swift 