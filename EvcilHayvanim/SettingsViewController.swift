//
//  SettingsViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Properties
    private let sections = [
        "Genel",
        "Bildirimler",
        "Veri Yönetimi",
        "Hakkında"
    ]
    
    private let settingsData = [
        ["Profil", "Tema", "Dil"],
        ["Aşı Hatırlatmaları", "Randevu Bildirimleri", "İlaç Hatırlatmaları"],
        ["Veri Yedekleme", "Veri Dışa Aktar", "Veri İçe Aktar"],
        ["Uygulama Hakkında", "Gizlilik Politikası", "Kullanım Şartları", "Sürüm"]
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Ayarlar"
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        let setting = settingsData[indexPath.section][indexPath.row]
        cell.textLabel?.text = setting
        cell.accessoryType = .disclosureIndicator
        
        // Add switches for notification settings
        if indexPath.section == 1 {
            let switchView = UISwitch()
            switchView.tag = indexPath.row
            switchView.addTarget(self, action: #selector(notificationSwitchChanged(_:)), for: .valueChanged)
            
            // Set initial values (TODO: Load from UserDefaults)
            switch indexPath.row {
            case 0: // Aşı Hatırlatmaları
                switchView.isOn = true
            case 1: // Randevu Bildirimleri
                switchView.isOn = true
            case 2: // İlaç Hatırlatmaları
                switchView.isOn = false
            default:
                break
            }
            
            cell.accessoryView = switchView
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let setting = settingsData[indexPath.section][indexPath.row]
        
        switch indexPath.section {
        case 0: // Genel
            handleGeneralSettings(setting)
        case 1: // Bildirimler
            // Handled by switches
            break
        case 2: // Veri Yönetimi
            handleDataManagement(setting)
        case 3: // Hakkında
            handleAboutSettings(setting)
        default:
            break
        }
    }
    
    private func handleGeneralSettings(_ setting: String) {
        switch setting {
        case "Profil":
            showProfileSettings()
        case "Tema":
            showThemeSettings()
        case "Dil":
            showLanguageSettings()
        default:
            break
        }
    }
    
    private func handleDataManagement(_ setting: String) {
        switch setting {
        case "Veri Yedekleme":
            showBackupOptions()
        case "Veri Dışa Aktar":
            showExportOptions()
        case "Veri İçe Aktar":
            showImportOptions()
        default:
            break
        }
    }
    
    private func handleAboutSettings(_ setting: String) {
        switch setting {
        case "Uygulama Hakkında":
            showAboutApp()
        case "Gizlilik Politikası":
            showPrivacyPolicy()
        case "Kullanım Şartları":
            showTermsOfService()
        case "Sürüm":
            showAppVersion()
        default:
            break
        }
    }
    
    // MARK: - Settings Actions
    private func showProfileSettings() {
        let alert = UIAlertController(title: "Profil Ayarları", message: "Bu özellik yakında eklenecek", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func showThemeSettings() {
        let alert = UIAlertController(title: "Tema Seçimi", message: "Tema seçin", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sistem", style: .default) { _ in
            // TODO: Set system theme
        })
        
        alert.addAction(UIAlertAction(title: "Açık", style: .default) { _ in
            // TODO: Set light theme
        })
        
        alert.addAction(UIAlertAction(title: "Koyu", style: .default) { _ in
            // TODO: Set dark theme
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showLanguageSettings() {
        let alert = UIAlertController(title: "Dil Seçimi", message: "Dil seçin", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Türkçe", style: .default) { _ in
            // TODO: Set Turkish language
        })
        
        alert.addAction(UIAlertAction(title: "English", style: .default) { _ in
            // TODO: Set English language
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showBackupOptions() {
        let alert = UIAlertController(title: "Veri Yedekleme", message: "Verilerinizi yedeklemek istiyor musunuz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yedekle", style: .default) { _ in
            self.performBackup()
        })
        
        present(alert, animated: true)
    }
    
    private func showExportOptions() {
        let alert = UIAlertController(title: "Veri Dışa Aktar", message: "Verilerinizi dışa aktarmak istiyor musunuz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Dışa Aktar", style: .default) { _ in
            self.performExport()
        })
        
        present(alert, animated: true)
    }
    
    private func showImportOptions() {
        let alert = UIAlertController(title: "Veri İçe Aktar", message: "Veri içe aktarmak istiyor musunuz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "İçe Aktar", style: .default) { _ in
            self.performImport()
        })
        
        present(alert, animated: true)
    }
    
    private func showAboutApp() {
        let alert = UIAlertController(title: "EvcilHayvanim Hakkında", message: "Evcil hayvan sağlık takibi uygulaması\n\nVersiyon 1.0\n\nBu uygulama evcil hayvan sahiplerinin hayvanlarının sağlık durumunu takip etmelerine yardımcı olmak için geliştirilmiştir.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func showPrivacyPolicy() {
        let alert = UIAlertController(title: "Gizlilik Politikası", message: "Gizlilik politikası yakında eklenecek", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func showTermsOfService() {
        let alert = UIAlertController(title: "Kullanım Şartları", message: "Kullanım şartları yakında eklenecek", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func showAppVersion() {
        let alert = UIAlertController(title: "Uygulama Sürümü", message: "EvcilHayvanim v1.0.0", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Data Operations
    private func performBackup() {
        // TODO: Implement backup functionality
        let alert = UIAlertController(title: "Başarılı", message: "Verileriniz yedeklendi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func performExport() {
        // TODO: Implement export functionality
        let alert = UIAlertController(title: "Başarılı", message: "Verileriniz dışa aktarıldı", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func performImport() {
        // TODO: Implement import functionality
        let alert = UIAlertController(title: "Başarılı", message: "Verileriniz içe aktarıldı", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Notification Actions
    @objc private func notificationSwitchChanged(_ sender: UISwitch) {
        let setting: String
        switch sender.tag {
        case 0:
            setting = "Aşı Hatırlatmaları"
        case 1:
            setting = "Randevu Bildirimleri"
        case 2:
            setting = "İlaç Hatırlatmaları"
        default:
            setting = "Bilinmeyen"
        }
        
        // TODO: Save to UserDefaults
        print("\(setting): \(sender.isOn ? "Açık" : "Kapalı")")
        
        let alert = UIAlertController(title: "Bildirim Ayarları", message: "\(setting) \(sender.isOn ? "açıldı" : "kapatıldı")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
} 