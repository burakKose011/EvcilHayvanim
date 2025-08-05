//
//  HealthRecordFormViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class HealthRecordFormViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let typePickerView = UIPickerView()
    private let descriptionTextView = UITextView()
    private let veterinarianTextField = UITextField()
    private let datePicker = UIDatePicker()
    private let notesTextView = UITextView()
    
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    
    // MARK: - Properties
    var healthRecord: HealthRecord? // For editing
    var pet: Pet? // For new record
    private var selectedType: HealthRecordType = .checkup
    
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
        title = healthRecord == nil ? "Yeni Sağlık Kaydı" : "Sağlık Kaydı Düzenle"
        
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
        typePickerView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        veterinarianTextField.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        
        // Type Picker
        typePickerView.delegate = self
        typePickerView.dataSource = self
        
        // Description TextView
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.text = "Sağlık kaydı açıklaması..."
        descriptionTextView.textColor = .placeholderText
        
        // Veterinarian Field
        veterinarianTextField.placeholder = "Veteriner hekim"
        veterinarianTextField.borderStyle = .roundedRect
        veterinarianTextField.font = UIFont.systemFont(ofSize: 16)
        
        // Date Picker
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        
        // Notes TextView
        notesTextView.font = UIFont.systemFont(ofSize: 16)
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor.systemGray4.cgColor
        notesTextView.layer.cornerRadius = 8
        notesTextView.text = "Notlar (opsiyonel)..."
        notesTextView.textColor = .placeholderText
        
        contentView.addSubview(typePickerView)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(veterinarianTextField)
        contentView.addSubview(datePicker)
        contentView.addSubview(notesTextView)
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
            
            // Form Fields
            typePickerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            typePickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            typePickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            typePickerView.heightAnchor.constraint(equalToConstant: 120),
            
            descriptionTextView.topAnchor.constraint(equalTo: typePickerView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            veterinarianTextField.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            veterinarianTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            veterinarianTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            veterinarianTextField.heightAnchor.constraint(equalToConstant: 44),
            
            datePicker.topAnchor.constraint(equalTo: veterinarianTextField.bottomAnchor, constant: 20),
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
    
    // MARK: - Data Setup
    private func setupData() {
        if let healthRecord = healthRecord {
            // Editing mode
            descriptionTextView.text = healthRecord.description
            veterinarianTextField.text = healthRecord.veterinarian
            datePicker.date = healthRecord.date
            
            if let index = HealthRecordType.allCases.firstIndex(of: healthRecord.type) {
                typePickerView.selectRow(index, inComponent: 0, animated: false)
                selectedType = healthRecord.type
            }
        }
    }
    
    // MARK: - Actions
    @objc private func saveTapped() {
        guard validateForm() else { return }
        
        let newHealthRecord = HealthRecord(
            id: healthRecord?.id ?? UUID(),
            petId: pet?.id ?? healthRecord?.petId ?? UUID(),
            date: datePicker.date,
            type: selectedType,
            description: descriptionTextView.text,
            veterinarian: veterinarianTextField.text?.isEmpty == false ? veterinarianTextField.text : nil,
            attachments: []
        )
        
        // TODO: Save to Core Data
        saveHealthRecord(newHealthRecord)
        
        dismiss(animated: true)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Validation
    private func validateForm() -> Bool {
        guard let description = descriptionTextView.text, !description.isEmpty, description != "Sağlık kaydı açıklaması..." else {
            showAlert(title: "Hata", message: "Sağlık kaydı açıklaması gereklidir")
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
    private func saveHealthRecord(_ healthRecord: HealthRecord) {
        // TODO: Save to Core Data
        print("Health record saved: \(healthRecord.description)")
        
        let alert = UIAlertController(title: "Başarılı", message: "Sağlık kaydı kaydedildi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension HealthRecordFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return HealthRecordType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return HealthRecordType.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = HealthRecordType.allCases[row]
    }
}

// MARK: - UITextViewDelegate
extension HealthRecordFormViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Sağlık kaydı açıklaması..." || textView.text == "Notlar (opsiyonel)..." {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == descriptionTextView {
                textView.text = "Sağlık kaydı açıklaması..."
            } else if textView == notesTextView {
                textView.text = "Notlar (opsiyonel)..."
            }
            textView.textColor = .placeholderText
        }
    }
} 