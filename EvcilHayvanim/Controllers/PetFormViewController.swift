//
//  PetFormViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class PetFormViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerView = UIView()
    private let headerTitleLabel = UILabel()
    private let headerSubtitleLabel = UILabel()
    
    private let photoCard = UIView()
    private let petImageView = UIImageView()
    private let addPhotoButton = UIButton()
    private let photoIconView = UIImageView()
    
    private let formCard = UIView()
    private let nameTextField = UITextField()
    private let typeButton = UIButton()
    private let breedTextField = UITextField()
    private let birthDateButton = UIButton()
    private let weightTextField = UITextField()
    private let genderButton = UIButton()
    private let microchipTextField = UITextField()
    
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    
    // MARK: - Properties
    var pet: PetModel? // For editing
    private var selectedPetType: PetType = .dog
    private var selectedGender: Gender = .male
    private var selectedImage: UIImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupData()
        setupAnimations()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.background
        title = pet == nil ? "Yeni Sevimli Dost" : "Dostumu Düzenle"
        
        setupNavigationBar()
        setupScrollView()
        setupHeader()
        setupPhotoCard()
        setupFormCard()
        setupButtons()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerTitleLabel.text = pet == nil ? "Yeni Evcil Hayvan Ekle" : "Evcil Hayvan Düzenle"
        headerTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        headerTitleLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        headerTitleLabel.textAlignment = .center
        
        headerSubtitleLabel.text = "Evcil hayvanınızın bilgilerini girin"
        headerSubtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        headerSubtitleLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        headerSubtitleLabel.textAlignment = .center
        headerSubtitleLabel.numberOfLines = 0
        
        contentView.addSubview(headerView)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(headerSubtitleLabel)
    }
    
    private func setupPhotoCard() {
        photoCard.translatesAutoresizingMaskIntoConstraints = false
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        photoIconView.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        photoCard.backgroundColor = .white
        photoCard.layer.cornerRadius = 20
        photoCard.layer.shadowColor = UIColor.black.cgColor
        photoCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        photoCard.layer.shadowOpacity = 0.1
        photoCard.layer.shadowRadius = 8
        
        // Photo image view
        petImageView.contentMode = .scaleAspectFill
        petImageView.clipsToBounds = true
        petImageView.layer.cornerRadius = 50
        petImageView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        petImageView.layer.borderWidth = 3
        petImageView.layer.borderColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 0.2).cgColor
        
        // Photo icon
        photoIconView.image = UIImage(systemName: "camera.fill")
        photoIconView.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        photoIconView.contentMode = .scaleAspectFit
        
        // Add photo button
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "Fotoğraf Ekle"
        buttonConfig.baseBackgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 0.1)
        buttonConfig.baseForegroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        buttonConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            return outgoing
        }
        
        addPhotoButton.configuration = buttonConfig
        addPhotoButton.layer.cornerRadius = 10
        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        
        contentView.addSubview(photoCard)
        photoCard.addSubview(petImageView)
        photoCard.addSubview(photoIconView)
        photoCard.addSubview(addPhotoButton)
    }
    
    private func setupFormCard() {
        formCard.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        typeButton.translatesAutoresizingMaskIntoConstraints = false
        breedTextField.translatesAutoresizingMaskIntoConstraints = false
        birthDateButton.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        genderButton.translatesAutoresizingMaskIntoConstraints = false
        microchipTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Card styling
        formCard.backgroundColor = .white
        formCard.layer.cornerRadius = 20
        formCard.layer.shadowColor = UIColor.black.cgColor
        formCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        formCard.layer.shadowOpacity = 0.1
        formCard.layer.shadowRadius = 8
        
        // Name field
        setupModernTextField(nameTextField, placeholder: "Evcil hayvan adı", icon: "pawprint.fill")
        
        // Type button
        setupModernButton(typeButton, title: "Evcil Hayvan Türü", subtitle: "Köpek", icon: "chevron.right")
        typeButton.addTarget(self, action: #selector(typeButtonTapped), for: .touchUpInside)
        
        // Breed field
        setupModernTextField(breedTextField, placeholder: "Irk", icon: "tag.fill")
        
        // Birth date button
        setupModernButton(birthDateButton, title: "Doğum Tarihi", subtitle: "Seçin", icon: "calendar")
        birthDateButton.addTarget(self, action: #selector(birthDateButtonTapped), for: .touchUpInside)
        
        // Weight field
        setupModernTextField(weightTextField, placeholder: "Kilo (kg)", icon: "scalemass.fill")
        weightTextField.keyboardType = .decimalPad
        
        // Gender button
        setupModernButton(genderButton, title: "Cinsiyet", subtitle: "Erkek", icon: "chevron.right")
        genderButton.addTarget(self, action: #selector(genderButtonTapped), for: .touchUpInside)
        
        // Microchip field
        setupModernTextField(microchipTextField, placeholder: "Mikroçip numarası (opsiyonel)", icon: "number.circle.fill")
        microchipTextField.keyboardType = .numberPad
        
        contentView.addSubview(formCard)
        formCard.addSubview(nameTextField)
        formCard.addSubview(typeButton)
        formCard.addSubview(breedTextField)
        formCard.addSubview(birthDateButton)
        formCard.addSubview(weightTextField)
        formCard.addSubview(genderButton)
        formCard.addSubview(microchipTextField)
    }
    
    private func setupModernTextField(_ textField: UITextField, placeholder: String, icon: String) {
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        
        // Add left padding for icon
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 44))
        let iconView = UIImageView(frame: CGRect(x: 15, y: 12, width: 20, height: 20))
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        leftView.addSubview(iconView)
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
    
    private func setupModernButton(_ button: UIButton, title: String, subtitle: String, icon: String) {
        button.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        
        // Create stack view for title and subtitle
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        subtitleLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        // Create right icon
        let rightIcon = UIImageView()
        rightIcon.image = UIImage(systemName: icon)
        rightIcon.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        rightIcon.contentMode = .scaleAspectFit
        
        // Add to button
        button.addSubview(stackView)
        button.addSubview(rightIcon)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        rightIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: rightIcon.leadingAnchor, constant: -12),
            
            rightIcon.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            rightIcon.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            rightIcon.widthAnchor.constraint(equalToConstant: 20),
            rightIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupButtons() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Save button
        saveButton.setTitle("Kaydet", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        saveButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        saveButton.layer.cornerRadius = 16
        saveButton.layer.shadowColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0).cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        saveButton.layer.shadowOpacity = 0.3
        saveButton.layer.shadowRadius = 8
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        // Cancel button
        cancelButton.setTitle("İptal", for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cancelButton.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        contentView.addSubview(saveButton)
        contentView.addSubview(cancelButton)
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
            
            // Header
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            headerTitleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerTitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            headerSubtitleLabel.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 8),
            headerSubtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerSubtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerSubtitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            // Photo Card
            photoCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            photoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            photoCard.heightAnchor.constraint(equalToConstant: 180),
            
            petImageView.topAnchor.constraint(equalTo: photoCard.topAnchor, constant: 20),
            petImageView.centerXAnchor.constraint(equalTo: photoCard.centerXAnchor),
            petImageView.widthAnchor.constraint(equalToConstant: 100),
            petImageView.heightAnchor.constraint(equalToConstant: 100),
            
            photoIconView.centerXAnchor.constraint(equalTo: petImageView.centerXAnchor),
            photoIconView.centerYAnchor.constraint(equalTo: petImageView.centerYAnchor),
            photoIconView.widthAnchor.constraint(equalToConstant: 30),
            photoIconView.heightAnchor.constraint(equalToConstant: 30),
            
            addPhotoButton.topAnchor.constraint(equalTo: petImageView.bottomAnchor, constant: 12),
            addPhotoButton.centerXAnchor.constraint(equalTo: photoCard.centerXAnchor),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 36),
            addPhotoButton.leadingAnchor.constraint(greaterThanOrEqualTo: photoCard.leadingAnchor, constant: 20),
            addPhotoButton.trailingAnchor.constraint(lessThanOrEqualTo: photoCard.trailingAnchor, constant: -20),
            addPhotoButton.bottomAnchor.constraint(lessThanOrEqualTo: photoCard.bottomAnchor, constant: -16),
            
            // Form Card
            formCard.topAnchor.constraint(equalTo: photoCard.bottomAnchor, constant: 20),
            formCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            formCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Form fields
            nameTextField.topAnchor.constraint(equalTo: formCard.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            typeButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            typeButton.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 20),
            typeButton.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -20),
            typeButton.heightAnchor.constraint(equalToConstant: 60),
            
            breedTextField.topAnchor.constraint(equalTo: typeButton.bottomAnchor, constant: 16),
            breedTextField.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 20),
            breedTextField.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -20),
            breedTextField.heightAnchor.constraint(equalToConstant: 50),
            
            birthDateButton.topAnchor.constraint(equalTo: breedTextField.bottomAnchor, constant: 16),
            birthDateButton.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 20),
            birthDateButton.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -20),
            birthDateButton.heightAnchor.constraint(equalToConstant: 60),
            
            weightTextField.topAnchor.constraint(equalTo: birthDateButton.bottomAnchor, constant: 16),
            weightTextField.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 20),
            weightTextField.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -20),
            weightTextField.heightAnchor.constraint(equalToConstant: 50),
            
            genderButton.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 16),
            genderButton.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 20),
            genderButton.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -20),
            genderButton.heightAnchor.constraint(equalToConstant: 60),
            
            microchipTextField.topAnchor.constraint(equalTo: genderButton.bottomAnchor, constant: 16),
            microchipTextField.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 20),
            microchipTextField.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -20),
            microchipTextField.heightAnchor.constraint(equalToConstant: 50),
            microchipTextField.bottomAnchor.constraint(equalTo: formCard.bottomAnchor, constant: -20),
            
            // Buttons
            saveButton.topAnchor.constraint(equalTo: formCard.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 56),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Animations
    private func setupAnimations() {
        // Animate cards with staggered timing
        let cards = [photoCard, formCard]
        for (index, card) in cards.enumerated() {
            card.alpha = 0
            card.transform = CGAffineTransform(translationX: 0, y: 30)
            
            UIView.animate(withDuration: 0.5, delay: 0.2 + Double(index) * 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                card.alpha = 1.0
                card.transform = .identity
            })
        }
    }
    
    // MARK: - Data Setup
    private func setupData() {
        if let pet = pet {
            // Editing mode
            nameTextField.text = pet.name
            breedTextField.text = pet.breed
            weightTextField.text = "\(pet.weight)"
            microchipTextField.text = pet.microchipNumber
            
            selectedPetType = pet.petType
            selectedGender = pet.gender
            
            // Update button titles
            updateTypeButtonTitle()
            updateGenderButtonTitle()
            
            // TODO: Load pet image
            petImageView.image = UIImage(systemName: pet.petType.iconName)
            petImageView.tintColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
            photoIconView.isHidden = true
        }
    }
    
    private func updateTypeButtonTitle() {
        if let subtitleLabel = typeButton.subviews.first?.subviews.last as? UILabel {
            subtitleLabel.text = selectedPetType.rawValue
        }
    }
    
    private func updateGenderButtonTitle() {
        if let subtitleLabel = genderButton.subviews.first?.subviews.last as? UILabel {
            subtitleLabel.text = selectedGender.rawValue
        }
    }
    
    // MARK: - Actions
    @objc private func addPhotoTapped() {
        let alert = UIAlertController(title: "Fotoğraf Ekle", message: "Fotoğraf kaynağını seçin", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Kamera", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .camera)
        })
        
        alert.addAction(UIAlertAction(title: "Galeri", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary)
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func typeButtonTapped() {
        let alert = UIAlertController(title: "Evcil Hayvan Türü", message: "Tür seçin", preferredStyle: .actionSheet)
        
        for petType in PetType.allCases {
            alert.addAction(UIAlertAction(title: petType.rawValue, style: .default) { [weak self] _ in
                self?.selectedPetType = petType
                self?.updateTypeButtonTitle()
            })
        }
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func birthDateButtonTapped() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        let alert = UIAlertController(title: "Doğum Tarihi", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alert.view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor, constant: 20)
        ])
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            if let subtitleLabel = self?.birthDateButton.subviews.first?.subviews.last as? UILabel {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM yyyy"
                subtitleLabel.text = formatter.string(from: datePicker.date)
            }
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func genderButtonTapped() {
        let alert = UIAlertController(title: "Cinsiyet", message: "Cinsiyet seçin", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Erkek", style: .default) { [weak self] _ in
            self?.selectedGender = .male
            self?.updateGenderButtonTitle()
        })
        
        alert.addAction(UIAlertAction(title: "Dişi", style: .default) { [weak self] _ in
            self?.selectedGender = .female
            self?.updateGenderButtonTitle()
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }
    
    @objc private func saveTapped() {
        guard validateForm() else { return }
        
        let newPet = PetModel(
            identifier: pet?.identifier ?? UUID(),
            name: nameTextField.text ?? "",
            petType: selectedPetType,
            breed: breedTextField.text ?? "",
            birthDate: Date(), // TODO: Get from date picker
            weight: Double(weightTextField.text ?? "0") ?? 0,
            gender: selectedGender,
            microchipNumber: microchipTextField.text?.isEmpty == false ? microchipTextField.text : nil,
            photoURL: nil // TODO: Save image and get URL
        )
        
        savePet(newPet)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Validation
    private func validateForm() -> Bool {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "Hata", message: "Evcil hayvan adı gereklidir")
            return false
        }
        
        guard let breed = breedTextField.text, !breed.isEmpty else {
            showAlert(title: "Hata", message: "Irk bilgisi gereklidir")
            return false
        }
        
        guard let weightText = weightTextField.text, let weight = Double(weightText), weight > 0 else {
            showAlert(title: "Hata", message: "Geçerli bir kilo değeri girin")
            return false
        }
        
        return true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Data Operations
    private func savePet(_ pet: PetModel) {
        DataManager.shared.savePet(pet)
        print("Pet saved: \(pet.name)")
        
        let alert = UIAlertController(title: "Başarılı", message: "Evcil hayvan kaydedildi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PetFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            petImageView.image = image
            photoIconView.isHidden = true
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
} 