//
//  AppointmentFormViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class AppointmentFormViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let petPickerView = UIPickerView()
    private let veterinarianTextField = UITextField()
    private let reasonTextField = UITextField()
    private let datePicker = UIDatePicker()
    private let notesTextView = UITextView()
    
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    
    // MARK: - Properties
    var appointment: AppointmentModel? // For editing
    var pet: PetModel? // For new appointment
    private var pets: [PetModel] = []
    private var selectedPet: PetModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadPets()
        setupData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.background
        title = appointment == nil ? "Yeni Randevu" : "Randevu Düzenle"
        
        setupNavigationBar()
        setupScrollView()
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
    
    private func setupFormFields() {
        petPickerView.translatesAutoresizingMaskIntoConstraints = false
        veterinarianTextField.translatesAutoresizingMaskIntoConstraints = false
        reasonTextField.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        
        // Pet Picker
        petPickerView.delegate = self
        petPickerView.dataSource = self
        
        // Veterinarian Field with cute styling
        veterinarianTextField.placeholder = "👨‍⚕️ Veteriner hekim"
        veterinarianTextField.borderStyle = .roundedRect
        veterinarianTextField.font = DesignSystem.Typography.callout
        veterinarianTextField.backgroundColor = DesignSystem.Colors.cardBackground
        
        // Reason Field with cute styling
        reasonTextField.placeholder = "📝 Randevu sebebi"
        reasonTextField.borderStyle = .roundedRect
        reasonTextField.font = DesignSystem.Typography.callout
        reasonTextField.backgroundColor = DesignSystem.Colors.cardBackground
        
        // Date Picker with cute styling
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        datePicker.tintColor = DesignSystem.Colors.primary
        
        // Notes TextView with cute styling
        notesTextView.font = DesignSystem.Typography.callout
        notesTextView.layer.borderWidth = 2
        notesTextView.layer.borderColor = DesignSystem.Colors.primaryLight.cgColor
        notesTextView.layer.cornerRadius = DesignSystem.CornerRadius.medium
        notesTextView.text = "📝 Notlar (opsiyonel)..."
        notesTextView.textColor = DesignSystem.Colors.textSecondary
        notesTextView.backgroundColor = DesignSystem.Colors.cardBackground
        
        contentView.addSubview(petPickerView)
        contentView.addSubview(veterinarianTextField)
        contentView.addSubview(reasonTextField)
        contentView.addSubview(datePicker)
        contentView.addSubview(notesTextView)
    }
    
    private func setupButtons() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("💾 Kaydet", for: .normal)
        saveButton.applyPrimaryStyle()
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        cancelButton.setTitle("❌ İptal", for: .normal)
        cancelButton.setTitleColor(DesignSystem.Colors.error, for: .normal)
        cancelButton.titleLabel?.font = DesignSystem.Typography.buttonTitle
        cancelButton.backgroundColor = DesignSystem.Colors.error.withAlphaComponent(0.1)
        cancelButton.layer.cornerRadius = DesignSystem.CornerRadius.medium
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
            
            // Form Fields
            petPickerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            petPickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            petPickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            petPickerView.heightAnchor.constraint(equalToConstant: 120),
            
            veterinarianTextField.topAnchor.constraint(equalTo: petPickerView.bottomAnchor, constant: 20),
            veterinarianTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            veterinarianTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            veterinarianTextField.heightAnchor.constraint(equalToConstant: 44),
            
            reasonTextField.topAnchor.constraint(equalTo: veterinarianTextField.bottomAnchor, constant: 20),
            reasonTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reasonTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            reasonTextField.heightAnchor.constraint(equalToConstant: 44),
            
            datePicker.topAnchor.constraint(equalTo: reasonTextField.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            datePicker.heightAnchor.constraint(equalToConstant: 44),
            
            notesTextView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            notesTextView.heightAnchor.constraint(equalToConstant: 100),
            
            // Buttons
            saveButton.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: 30),
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
    
    // MARK: - Data Loading
    private func loadPets() {
        pets = DataManager.shared.fetchPets()
        
        if let pet = pet {
            selectedPet = pet
            if let index = pets.firstIndex(where: { $0.identifier == pet.identifier }) {
                petPickerView.selectRow(index, inComponent: 0, animated: false)
            }
        } else if !pets.isEmpty {
            selectedPet = pets.first
        }
        
        petPickerView.reloadAllComponents()
    }
    
    private func setupData() {
        if let appointment = appointment {
            // Editing mode
            veterinarianTextField.text = appointment.veterinarian
            reasonTextField.text = appointment.reason
            datePicker.date = appointment.appointmentDate
            notesTextView.text = appointment.notes ?? "Notlar (opsiyonel)..."
        }
    }
    
    // MARK: - Actions
    @objc private func saveTapped() {
        guard validateForm() else { return }
        
        let newAppointment = AppointmentModel(
            identifier: appointment?.identifier ?? UUID(),
            petId: selectedPet?.identifier ?? appointment?.petId ?? UUID(),
            petName: selectedPet?.name ?? appointment?.petName ?? "",
            appointmentDate: datePicker.date,
            veterinarian: veterinarianTextField.text ?? "",
            reason: reasonTextField.text ?? "",
            notes: notesTextView.text == "Notlar (opsiyonel)..." ? nil : notesTextView.text,
            status: AppointmentStatus.scheduled
        )
        
        saveAppointment(newAppointment)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Validation
    private func validateForm() -> Bool {
        guard let veterinarian = veterinarianTextField.text, !veterinarian.isEmpty else {
            showAlert(title: "Hata", message: "Veteriner hekim bilgisi gereklidir")
            return false
        }
        
        guard let reason = reasonTextField.text, !reason.isEmpty else {
            showAlert(title: "Hata", message: "Randevu sebebi gereklidir")
            return false
        }
        
        guard selectedPet != nil else {
            showAlert(title: "Hata", message: "Evcil hayvan seçimi gereklidir")
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
    private func saveAppointment(_ appointment: AppointmentModel) {
        DataManager.shared.saveAppointment(appointment)
        print("Appointment saved: \(appointment.reason)")
        
        let alert = UIAlertController(title: "Başarılı", message: "Randevu kaydedildi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension AppointmentFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let pet = pets[row]
        return "\(pet.name) (\(pet.petType.rawValue))"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPet = pets[row]
    }
}

// MARK: - UITextViewDelegate
extension AppointmentFormViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Notlar (opsiyonel)..." {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notlar (opsiyonel)..."
            textView.textColor = .placeholderText
        }
    }
} 