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
    
    private let petImageView = UIImageView()
    private let addPhotoButton = UIButton()
    
    private let nameTextField = UITextField()
    private let typePickerView = UIPickerView()
    private let breedTextField = UITextField()
    private let birthDatePicker = UIDatePicker()
    private let weightTextField = UITextField()
    private let genderSegmentedControl = UISegmentedControl(items: ["Erkek", "Dişi"])
    private let microchipTextField = UITextField()
    
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    
    // MARK: - Properties
    var pet: Pet? // For editing
    private var selectedPetType: PetType = .dog
    private var selectedGender: Gender = .male
    private var selectedImage: UIImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = pet == nil ? "Yeni Evcil Hayvan" : "Evcil Hayvan Düzenle"
        
        setupNavigationBar()
        setupScrollView()
        setupPhotoSection()
        setupFormFields()
        setupButtons()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupPhotoSection() {
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        petImageView.contentMode = .scaleAspectFill
        petImageView.clipsToBounds = true
        petImageView.layer.cornerRadius = 50
        petImageView.backgroundColor = .systemGray5
        petImageView.image = UIImage(systemName: "camera")
        petImageView.tintColor = .systemGray
        
        addPhotoButton.setTitle("Fotoğraf Ekle", for: .normal)
        addPhotoButton.setTitleColor(.systemBlue, for: .normal)
        addPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        
        contentView.addSubview(petImageView)
        contentView.addSubview(addPhotoButton)
    }
    
    private func setupFormFields() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        typePickerView.translatesAutoresizingMaskIntoConstraints = false
        breedTextField.translatesAutoresizingMaskIntoConstraints = false
        birthDatePicker.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        genderSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        microchipTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Name Field
        nameTextField.placeholder = "Evcil hayvan adı"
        nameTextField.borderStyle = .roundedRect
        nameTextField.font = UIFont.systemFont(ofSize: 16)
        
        // Type Picker
        typePickerView.delegate = self
        typePickerView.dataSource = self
        
        // Breed Field
        breedTextField.placeholder = "Irk"
        breedTextField.borderStyle = .roundedRect
        breedTextField.font = UIFont.systemFont(ofSize: 16)
        
        // Birth Date Picker
        birthDatePicker.datePickerMode = .date
        birthDatePicker.preferredDatePickerStyle = .compact
        birthDatePicker.maximumDate = Date()
        
        // Weight Field
        weightTextField.placeholder = "Kilo (kg)"
        weightTextField.borderStyle = .roundedRect
        weightTextField.font = UIFont.systemFont(ofSize: 16)
        weightTextField.keyboardType = .decimalPad
        
        // Gender Segmented Control
        genderSegmentedControl.selectedSegmentIndex = 0
        
        // Microchip Field
        microchipTextField.placeholder = "Mikroçip numarası (opsiyonel)"
        microchipTextField.borderStyle = .roundedRect
        microchipTextField.font = UIFont.systemFont(ofSize: 16)
        microchipTextField.keyboardType = .numberPad
        
        contentView.addSubview(nameTextField)
        contentView.addSubview(typePickerView)
        contentView.addSubview(breedTextField)
        contentView.addSubview(birthDatePicker)
        contentView.addSubview(weightTextField)
        contentView.addSubview(genderSegmentedControl)
        contentView.addSubview(microchipTextField)
    }
    
    private func setupButtons() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Kaydet", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 12
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        cancelButton.setTitle("İptal", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cancelButton.backgroundColor = .systemRed.withAlphaComponent(0.1)
        cancelButton.layer.cornerRadius = 12
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
            
            // Photo Section
            petImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            petImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            petImageView.widthAnchor.constraint(equalToConstant: 100),
            petImageView.heightAnchor.constraint(equalToConstant: 100),
            
            addPhotoButton.topAnchor.constraint(equalTo: petImageView.bottomAnchor, constant: 12),
            addPhotoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Form Fields
            nameTextField.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            typePickerView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            typePickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            typePickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            typePickerView.heightAnchor.constraint(equalToConstant: 120),
            
            breedTextField.topAnchor.constraint(equalTo: typePickerView.bottomAnchor, constant: 20),
            breedTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            breedTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            breedTextField.heightAnchor.constraint(equalToConstant: 44),
            
            birthDatePicker.topAnchor.constraint(equalTo: breedTextField.bottomAnchor, constant: 20),
            birthDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            birthDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            birthDatePicker.heightAnchor.constraint(equalToConstant: 44),
            
            weightTextField.topAnchor.constraint(equalTo: birthDatePicker.bottomAnchor, constant: 20),
            weightTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weightTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            weightTextField.heightAnchor.constraint(equalToConstant: 44),
            
            genderSegmentedControl.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 20),
            genderSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            genderSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            microchipTextField.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: 20),
            microchipTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            microchipTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            microchipTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Buttons
            saveButton.topAnchor.constraint(equalTo: microchipTextField.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Setup
    private func setupData() {
        if let pet = pet {
            // Editing mode
            nameTextField.text = pet.name
            breedTextField.text = pet.breed
            weightTextField.text = "\(pet.weight)"
            microchipTextField.text = pet.microchipNumber
            birthDatePicker.date = pet.birthDate
            
            if let index = PetType.allCases.firstIndex(of: pet.type) {
                typePickerView.selectRow(index, inComponent: 0, animated: false)
                selectedPetType = pet.type
            }
            
            genderSegmentedControl.selectedSegmentIndex = pet.gender == .male ? 0 : 1
            selectedGender = pet.gender
            
            // TODO: Load pet image
            petImageView.image = UIImage(systemName: pet.type.iconName)
            petImageView.tintColor = .systemGray
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
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }
    
    @objc private func saveTapped() {
        guard validateForm() else { return }
        
        let newPet = Pet(
            id: pet?.id ?? UUID(),
            name: nameTextField.text ?? "",
            type: selectedPetType,
            breed: breedTextField.text ?? "",
            birthDate: birthDatePicker.date,
            weight: Double(weightTextField.text ?? "0") ?? 0,
            gender: selectedGender,
            microchipNumber: microchipTextField.text?.isEmpty == false ? microchipTextField.text : nil,
            photoURL: nil // TODO: Save image and get URL
        )
        
        // TODO: Save to Core Data
        savePet(newPet)
        
        dismiss(animated: true)
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
    private func savePet(_ pet: Pet) {
        // TODO: Save to Core Data
        print("Pet saved: \(pet.name)")
        
        let alert = UIAlertController(title: "Başarılı", message: "Evcil hayvan kaydedildi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension PetFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PetType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PetType.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPetType = PetType.allCases[row]
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PetFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            petImageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
} 