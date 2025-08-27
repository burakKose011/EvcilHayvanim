//
//  Models.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import Foundation
import CoreData
import UIKit

// MARK: - Pet Models
public struct PetModel {
    public let identifier: UUID
    public var name: String
    public var petType: PetType
    public var breed: String
    public var birthDate: Date
    public var weight: Double
    public var gender: Gender
    public var microchipNumber: String?
    public var photoURL: URL?
    
    public init(identifier: UUID, name: String, petType: PetType, breed: String, birthDate: Date, weight: Double, gender: Gender, microchipNumber: String?, photoURL: URL?) {
        self.identifier = identifier
        self.name = name
        self.petType = petType
        self.breed = breed
        self.birthDate = birthDate
        self.weight = weight
        self.gender = gender
        self.microchipNumber = microchipNumber
        self.photoURL = photoURL
    }
}

public enum PetType: String, CaseIterable {
    case dog = "Köpek"
    case cat = "Kedi"
    case bird = "Kuş"
    case fish = "Balık"
    case rabbit = "Tavşan"
    case hamster = "Hamster"
    case other = "Diğer"
    
    public var iconName: String {
        switch self {
        case .dog: return "pawprint.fill"
        case .cat: return "cat.fill"
        case .bird: return "bird.fill"
        case .fish: return "fish.fill"
        case .rabbit: return "hare.fill"
        case .hamster: return "pawprint.circle.fill"
        case .other: return "heart.fill"
        }
    }
}

public enum Gender: String, CaseIterable {
    case male = "Erkek"
    case female = "Dişi"
}

// MARK: - Health Record Models
public struct HealthRecordModel {
    public let identifier: UUID
    public let petId: UUID
    public let recordDate: Date
    public let recordType: HealthRecordType
    public let recordDescription: String
    public let veterinarian: String?
    public let attachments: [URL]
    
    public init(identifier: UUID, petId: UUID, recordDate: Date, recordType: HealthRecordType, recordDescription: String, veterinarian: String?, attachments: [URL]) {
        self.identifier = identifier
        self.petId = petId
        self.recordDate = recordDate
        self.recordType = recordType
        self.recordDescription = recordDescription
        self.veterinarian = veterinarian
        self.attachments = attachments
    }
}

public enum HealthRecordType: String, CaseIterable {
    case checkup = "Kontrol"
    case emergency = "Acil Durum"
    case grooming = "Bakım"
    case medication = "İlaç"
    case other = "Diğer"
    case surgery = "Ameliyat"
    case treatment = "Tedavi"
    case vaccination = "Aşı"
}

// MARK: - Appointment Models
public struct AppointmentModel {
    public let identifier: UUID
    public let petId: UUID
    public let petName: String
    public let appointmentDate: Date
    public let veterinarian: String
    public let reason: String
    public let notes: String?
    public var status: AppointmentStatus
    
    public init(identifier: UUID, petId: UUID, petName: String, appointmentDate: Date, veterinarian: String, reason: String, notes: String?, status: AppointmentStatus) {
        self.identifier = identifier
        self.petId = petId
        self.petName = petName
        self.appointmentDate = appointmentDate
        self.veterinarian = veterinarian
        self.reason = reason
        self.notes = notes
        self.status = status
    }
}

public enum AppointmentStatus: String, CaseIterable {
    case scheduled = "Planlandı"
    case completed = "Tamamlandı"
    case cancelled = "İptal"
}

// MARK: - Reminder Models
public struct ReminderModel {
    public let identifier: UUID
    public let title: String
    public let reminderDate: Date
    public let reminderType: ReminderType
    
    public init(identifier: UUID, title: String, reminderDate: Date, reminderType: ReminderType) {
        self.identifier = identifier
        self.title = title
        self.reminderDate = reminderDate
        self.reminderType = reminderType
    }
}

public enum ReminderType {
    case vaccination
    case medication
    case appointment
    case checkup
}

// MARK: - Data Manager
public class DataManager {
    public static let shared = DataManager()
    
    private init() {}
    
    // MARK: - Mock Data Storage
    private var pets: [PetModel] = []
    private var healthRecords: [HealthRecordModel] = []
    private var appointments: [AppointmentModel] = []
    private var reminders: [ReminderModel] = []
    
    // MARK: - Core Data Context (will be used later)
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - Pet Operations
    public func savePet(_ pet: PetModel) {
        // For now, just add to mock data
        if let index = pets.firstIndex(where: { $0.identifier == pet.identifier }) {
            pets[index] = pet
        } else {
            pets.append(pet)
        }
        print("Pet saved: \(pet.name)")
    }
    
    public func fetchPets() -> [PetModel] {
        // Return mock data for now
        if pets.isEmpty {
            pets = [
                PetModel(identifier: UUID(), name: "Boncuk", petType: PetType.cat, breed: "Tekir", birthDate: Date().addingTimeInterval(-365*24*60*60*2), weight: 4.2, gender: Gender.female, microchipNumber: "123456789", photoURL: nil),
                PetModel(identifier: UUID(), name: "Karabaş", petType: PetType.dog, breed: "Golden Retriever", birthDate: Date().addingTimeInterval(-365*24*60*60*3), weight: 25.5, gender: Gender.male, microchipNumber: "987654321", photoURL: nil),
                PetModel(identifier: UUID(), name: "Maviş", petType: PetType.bird, breed: "Muhabbet Kuşu", birthDate: Date().addingTimeInterval(-365*24*60*60), weight: 0.05, gender: Gender.male, microchipNumber: nil, photoURL: nil)
            ]
        }
        return pets
    }
    
    public func deletePet(_ pet: PetModel) {
        pets.removeAll { $0.identifier == pet.identifier }
        print("Pet deleted: \(pet.name)")
    }
    
    // MARK: - Health Record Operations
    func saveHealthRecord(_ healthRecord: HealthRecordModel) {
        // For now, just add to mock data
        if let index = healthRecords.firstIndex(where: { $0.identifier == healthRecord.identifier }) {
            healthRecords[index] = healthRecord
        } else {
            healthRecords.append(healthRecord)
        }
        print("Health record saved: \(healthRecord.recordDescription)")
    }
    
    func fetchHealthRecords(for petId: UUID? = nil) -> [HealthRecordModel] {
        // Return mock data for now
        if healthRecords.isEmpty {
            // Önce hayvanları al
            let pets = fetchPets()
            let boncukId = pets.first(where: { $0.name == "Boncuk" })?.identifier ?? UUID()
            let karabasId = pets.first(where: { $0.name == "Karabaş" })?.identifier ?? UUID()
            let mavisId = pets.first(where: { $0.name == "Maviş" })?.identifier ?? UUID()
            
            healthRecords = [
                // Vaccination examples
                HealthRecordModel(identifier: UUID(), petId: boncukId, recordDate: Date().addingTimeInterval(-7*24*60*60), recordType: HealthRecordType.vaccination, recordDescription: "Kuduz aşısı yapıldı", veterinarian: "Dr. Ahmet Yılmaz", attachments: []),
                HealthRecordModel(identifier: UUID(), petId: karabasId, recordDate: Date().addingTimeInterval(-21*24*60*60), recordType: HealthRecordType.vaccination, recordDescription: "Karma aşı (5'li) uygulandı", veterinarian: "Dr. Fatma Öz", attachments: []),
                
                // Checkup examples
                HealthRecordModel(identifier: UUID(), petId: boncukId, recordDate: Date().addingTimeInterval(-14*24*60*60), recordType: HealthRecordType.checkup, recordDescription: "Genel sağlık kontrolü yapıldı", veterinarian: "Dr. Ayşe Demir", attachments: []),
                HealthRecordModel(identifier: UUID(), petId: karabasId, recordDate: Date().addingTimeInterval(-45*24*60*60), recordType: HealthRecordType.checkup, recordDescription: "Yıllık rutin kontrol", veterinarian: "Dr. Can Özkan", attachments: []),
                
                // Treatment examples
                HealthRecordModel(identifier: UUID(), petId: karabasId, recordDate: Date().addingTimeInterval(-30*24*60*60), recordType: HealthRecordType.treatment, recordDescription: "Kulak enfeksiyonu tedavisi", veterinarian: "Dr. Mehmet Kaya", attachments: []),
                HealthRecordModel(identifier: UUID(), petId: boncukId, recordDate: Date().addingTimeInterval(-60*24*60*60), recordType: HealthRecordType.treatment, recordDescription: "Deri alerjisi tedavisi başlatıldı", veterinarian: "Dr. Zeynep Acar", attachments: []),
                
                // Emergency examples
                HealthRecordModel(identifier: UUID(), petId: karabasId, recordDate: Date().addingTimeInterval(-3*24*60*60), recordType: HealthRecordType.emergency, recordDescription: "Acil müdahale - Zehirlenme şüphesi", veterinarian: "Dr. Emre Kılıç", attachments: []),
                HealthRecordModel(identifier: UUID(), petId: mavisId, recordDate: Date().addingTimeInterval(-90*24*60*60), recordType: HealthRecordType.emergency, recordDescription: "Trafik kazası sonrası acil müdahale", veterinarian: "Dr. Selin Yıldız", attachments: []),
                
                // Grooming examples
                HealthRecordModel(identifier: UUID(), petId: boncukId, recordDate: Date().addingTimeInterval(-10*24*60*60), recordType: HealthRecordType.grooming, recordDescription: "Tırnak kesimi ve tüy bakımı", veterinarian: "Bakım Uzmanı Aylin", attachments: []),
                HealthRecordModel(identifier: UUID(), petId: karabasId, recordDate: Date().addingTimeInterval(-35*24*60*60), recordType: HealthRecordType.grooming, recordDescription: "Diş temizliği ve ağız bakımı", veterinarian: "Dr. Oğuz Demir", attachments: []),
                
                // Surgery examples
                HealthRecordModel(identifier: UUID(), petId: karabasId, recordDate: Date().addingTimeInterval(-120*24*60*60), recordType: HealthRecordType.surgery, recordDescription: "Kısırlaştırma operasyonu", veterinarian: "Dr. Murat Şahin", attachments: []),
                HealthRecordModel(identifier: UUID(), petId: boncukId, recordDate: Date().addingTimeInterval(-200*24*60*60), recordType: HealthRecordType.surgery, recordDescription: "Tümör çıkarma operasyonu", veterinarian: "Dr. Elif Koç", attachments: []),
                
                // Medication examples
                HealthRecordModel(identifier: UUID(), petId: boncukId, recordDate: Date().addingTimeInterval(-5*24*60*60), recordType: HealthRecordType.medication, recordDescription: "Antibiyotik tedavisi başlatıldı", veterinarian: "Dr. Ayşe Demir", attachments: []),
                HealthRecordModel(identifier: UUID(), petId: mavisId, recordDate: Date().addingTimeInterval(-25*24*60*60), recordType: HealthRecordType.medication, recordDescription: "Ağrı kesici ilaç reçete edildi", veterinarian: "Dr. Kemal Arslan", attachments: []),
                
                // Other examples
                HealthRecordModel(identifier: UUID(), petId: karabasId, recordDate: Date().addingTimeInterval(-50*24*60*60), recordType: HealthRecordType.other, recordDescription: "Beslenme danışmanlığı alındı", veterinarian: "Beslenme Uzmanı Dr. Pınar", attachments: []),
                HealthRecordModel(identifier: UUID(), petId: mavisId, recordDate: Date().addingTimeInterval(-80*24*60*60), recordType: HealthRecordType.other, recordDescription: "Davranış terapisi seansı", veterinarian: "Davranış Uzmanı Dr. Cem", attachments: [])
            ]
        }
        
        if let petId = petId {
            return healthRecords.filter { $0.petId == petId }
        }
        return healthRecords
    }
    
    func deleteHealthRecord(_ healthRecord: HealthRecordModel) {
        healthRecords.removeAll { $0.identifier == healthRecord.identifier }
        print("Health record deleted: \(healthRecord.recordDescription)")
    }
    
    // MARK: - Appointment Operations
    func saveAppointment(_ appointment: AppointmentModel) {
        // For now, just add to mock data
        if let index = appointments.firstIndex(where: { $0.identifier == appointment.identifier }) {
            appointments[index] = appointment
        } else {
            appointments.append(appointment)
        }
        print("Appointment saved: \(appointment.reason)")
    }
    
    func fetchAppointments(for petId: UUID? = nil) -> [AppointmentModel] {
        // Return mock data for now
        if appointments.isEmpty {
            appointments = [
                AppointmentModel(identifier: UUID(), petId: UUID(), petName: "Boncuk", appointmentDate: Date().addingTimeInterval(24*60*60), veterinarian: "Dr. Ahmet Yılmaz", reason: "Kontrol", notes: "Genel sağlık kontrolü", status: AppointmentStatus.scheduled),
                AppointmentModel(identifier: UUID(), petId: UUID(), petName: "Karabaş", appointmentDate: Date().addingTimeInterval(3*24*60*60), veterinarian: "Dr. Ayşe Demir", reason: "Aşı", notes: "Kuduz aşısı", status: AppointmentStatus.scheduled),
                AppointmentModel(identifier: UUID(), petId: UUID(), petName: "Boncuk", appointmentDate: Date().addingTimeInterval(-7*24*60*60), veterinarian: "Dr. Mehmet Kaya", reason: "Tedavi", notes: "Kulak enfeksiyonu tedavisi", status: AppointmentStatus.completed),
                AppointmentModel(identifier: UUID(), petId: UUID(), petName: "Maviş", appointmentDate: Date().addingTimeInterval(-14*24*60*60), veterinarian: "Dr. Fatma Öz", reason: "Kontrol", notes: "Genel kontrol", status: AppointmentStatus.completed)
            ]
        }
        
        if let petId = petId {
            return appointments.filter { $0.petId == petId }
        }
        return appointments
    }
    
    func deleteAppointment(_ appointment: AppointmentModel) {
        appointments.removeAll { $0.identifier == appointment.identifier }
        print("Appointment deleted: \(appointment.reason)")
    }
    
    func updateAppointment(_ appointment: AppointmentModel) {
        if let index = appointments.firstIndex(where: { $0.identifier == appointment.identifier }) {
            appointments[index] = appointment
            print("Appointment updated: \(appointment.reason)")
        }
    }
    
    // MARK: - Reminder Operations
    func saveReminder(_ reminder: ReminderModel) {
        // For now, just add to mock data
        if let index = reminders.firstIndex(where: { $0.identifier == reminder.identifier }) {
            reminders[index] = reminder
        } else {
            reminders.append(reminder)
        }
        print("Reminder saved: \(reminder.title)")
    }
    
    func fetchReminders() -> [ReminderModel] {
        // Return mock data for now
        if reminders.isEmpty {
            reminders = [
                ReminderModel(identifier: UUID(), title: "Aşı Hatırlatması", reminderDate: Date().addingTimeInterval(7*24*60*60), reminderType: ReminderType.vaccination),
                ReminderModel(identifier: UUID(), title: "Kontrol Randevusu", reminderDate: Date().addingTimeInterval(3*24*60*60), reminderType: ReminderType.checkup),
                ReminderModel(identifier: UUID(), title: "İlaç Alma", reminderDate: Date().addingTimeInterval(12*60*60), reminderType: ReminderType.medication)
            ]
        }
        return reminders
    }
    
    func deleteReminder(_ reminder: ReminderModel) {
        reminders.removeAll { $0.identifier == reminder.identifier }
        print("Reminder deleted: \(reminder.title)")
    }
    
    // MARK: - Helper Methods
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

// MARK: - ReminderType Extension
extension ReminderType: RawRepresentable {
    public typealias RawValue = String
    
    public init?(rawValue: String) {
        switch rawValue {
        case "vaccination": self = .vaccination
        case "medication": self = .medication
        case "appointment": self = .appointment
        case "checkup": self = .checkup
        default: return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .vaccination: return "vaccination"
        case .medication: return "medication"
        case .appointment: return "appointment"
        case .checkup: return "checkup"
        }
    }
}

// MARK: - Design System
public struct DesignSystem {
    
    // MARK: - Colors
    public struct Colors {
        // Primary Colors - Tatlı ve canlı renkler
        public static let primary = UIColor(red: 0.98, green: 0.6, blue: 0.4, alpha: 1.0) // Somon pembe
        public static let primaryDark = UIColor(red: 0.9, green: 0.4, blue: 0.3, alpha: 1.0)
        public static let primaryLight = UIColor(red: 1.0, green: 0.8, blue: 0.7, alpha: 1.0)
        
        // Secondary Colors
        public static let secondary = UIColor(red: 0.4, green: 0.8, blue: 0.9, alpha: 1.0) // Açık mavi
        public static let secondaryDark = UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0)
        public static let secondaryLight = UIColor(red: 0.8, green: 0.95, blue: 1.0, alpha: 1.0)
        
        // Accent Colors - Hayvan temalı
        public static let accent1 = UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0) // Altın sarısı
        public static let accent2 = UIColor(red: 0.6, green: 0.9, blue: 0.4, alpha: 1.0) // Taze yeşil
        public static let accent3 = UIColor(red: 0.8, green: 0.4, blue: 0.9, alpha: 1.0) // Lavanta
        public static let accent4 = UIColor(red: 0.9, green: 0.5, blue: 0.7, alpha: 1.0) // Pembe
        
        // Background Colors
        public static let background = UIColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0)
        public static let cardBackground = UIColor.white
        public static let surfaceBackground = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
        
        // Text Colors
        public static let textPrimary = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        public static let textSecondary = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)
        public static let textLight = UIColor.white
        
        // Status Colors
        public static let success = UIColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1.0)
        public static let warning = UIColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 1.0)
        public static let error = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        public static let info = UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1.0)
    }
    
    // MARK: - Typography
    public struct Typography {
        // Headings
        public static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
        public static let title1 = UIFont.systemFont(ofSize: 28, weight: .bold)
        public static let title2 = UIFont.systemFont(ofSize: 22, weight: .bold)
        public static let title3 = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        // Body Text
        public static let headline = UIFont.systemFont(ofSize: 17, weight: .semibold)
        public static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
        public static let bodyBold = UIFont.systemFont(ofSize: 17, weight: .semibold)
        public static let callout = UIFont.systemFont(ofSize: 16, weight: .regular)
        public static let subheadline = UIFont.systemFont(ofSize: 15, weight: .regular)
        public static let footnote = UIFont.systemFont(ofSize: 13, weight: .regular)
        public static let caption1 = UIFont.systemFont(ofSize: 12, weight: .regular)
        public static let caption2 = UIFont.systemFont(ofSize: 11, weight: .regular)
        
        // Custom Fonts
        public static let cardTitle = UIFont.systemFont(ofSize: 18, weight: .bold)
        public static let cardSubtitle = UIFont.systemFont(ofSize: 14, weight: .medium)
        public static let buttonTitle = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    // MARK: - Spacing
    public struct Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 16
        public static let lg: CGFloat = 24
        public static let xl: CGFloat = 32
        public static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    public struct CornerRadius {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 12
        public static let large: CGFloat = 16
        public static let extraLarge: CGFloat = 24
        public static let round: CGFloat = 50
    }
    
    // MARK: - Shadow
    public struct Shadow {
        public static let small = ShadowStyle(
            color: UIColor.black,
            opacity: 0.1,
            offset: CGSize(width: 0, height: 2),
            radius: 4
        )
        
        public static let medium = ShadowStyle(
            color: UIColor.black,
            opacity: 0.15,
            offset: CGSize(width: 0, height: 4),
            radius: 8
        )
        
        public static let large = ShadowStyle(
            color: UIColor.black,
            opacity: 0.2,
            offset: CGSize(width: 0, height: 8),
            radius: 16
        )
    }
    
    public struct ShadowStyle {
        public let color: UIColor
        public let opacity: Float
        public let offset: CGSize
        public let radius: CGFloat
        
        public init(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
            self.color = color
            self.opacity = opacity
            self.offset = offset
            self.radius = radius
        }
    }
    
    // MARK: - Pet Type Colors
    public struct PetColors {
        public static func colorForPetType(_ petType: PetType) -> UIColor {
            switch petType {
            case .dog:
                return Colors.accent1 // Altın sarısı
            case .cat:
                return Colors.accent4 // Pembe
            case .bird:
                return Colors.accent2 // Taze yeşil
            case .fish:
                return Colors.secondary // Açık mavi
            case .rabbit:
                return Colors.accent3 // Lavanta
            case .hamster:
                return Colors.primary // Somon pembe
            case .other:
                return Colors.textSecondary
            }
        }
        
        public static func lightColorForPetType(_ petType: PetType) -> UIColor {
            return colorForPetType(petType).withAlphaComponent(0.15)
        }
    }
    
    // MARK: - Icons
    public struct Icons {
        // Pet Type Icons
        public static func iconForPetType(_ petType: PetType) -> String {
            switch petType {
            case .dog:
                return "pawprint.fill"
            case .cat:
                return "cat.fill"
            case .bird:
                return "bird.fill"
            case .fish:
                return "fish.fill"
            case .rabbit:
                return "hare.fill"
            case .hamster:
                return "pawprint.circle.fill"
            case .other:
                return "heart.fill"
            }
        }
        
        // Health Record Icons
        public static func iconForHealthRecord(_ recordType: HealthRecordType) -> String {
            switch recordType {
            case .checkup:
                return "stethoscope"
            case .emergency:
                return "exclamationmark.triangle.fill"
            case .grooming:
                return "scissors"
            case .medication:
                return "pills.fill"
            case .other:
                return "doc.text.fill"
            case .surgery:
                return "scissors"
            case .treatment:
                return "bandage.fill"
            case .vaccination:
                return "syringe.fill"
            }
        }
    }
}

// MARK: - UIView Extensions
public extension UIView {
    func applyShadow(_ shadow: DesignSystem.ShadowStyle) {
        layer.shadowColor = shadow.color.cgColor
        layer.shadowOpacity = shadow.opacity
        layer.shadowOffset = shadow.offset
        layer.shadowRadius = shadow.radius
        layer.masksToBounds = false
    }
    
    func applyCornerRadius(_ radius: CGFloat, corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        layer.masksToBounds = true
    }
    
    func applyGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        
        // Update frame when view bounds change
        DispatchQueue.main.async {
            gradientLayer.frame = self.bounds
        }
    }
}

// MARK: - UIButton Extensions
public extension UIButton {
    func applyPrimaryStyle() {
        backgroundColor = DesignSystem.Colors.primary
        setTitleColor(DesignSystem.Colors.textLight, for: .normal)
        titleLabel?.font = DesignSystem.Typography.buttonTitle
        layer.cornerRadius = DesignSystem.CornerRadius.medium
        layer.shadowColor = DesignSystem.Shadow.medium.color.cgColor
        layer.shadowOpacity = DesignSystem.Shadow.medium.opacity
        layer.shadowOffset = DesignSystem.Shadow.medium.offset
        layer.shadowRadius = DesignSystem.Shadow.medium.radius
    }
    
    func applySecondaryStyle() {
        backgroundColor = DesignSystem.Colors.secondary
        setTitleColor(DesignSystem.Colors.textLight, for: .normal)
        titleLabel?.font = DesignSystem.Typography.buttonTitle
        layer.cornerRadius = DesignSystem.CornerRadius.medium
        layer.shadowColor = DesignSystem.Shadow.small.color.cgColor
        layer.shadowOpacity = DesignSystem.Shadow.small.opacity
        layer.shadowOffset = DesignSystem.Shadow.small.offset
        layer.shadowRadius = DesignSystem.Shadow.small.radius
    }
    
    func applyOutlineStyle() {
        backgroundColor = UIColor.clear
        setTitleColor(DesignSystem.Colors.primary, for: .normal)
        titleLabel?.font = DesignSystem.Typography.buttonTitle
        layer.borderWidth = 2
        layer.borderColor = DesignSystem.Colors.primary.cgColor
        layer.cornerRadius = DesignSystem.CornerRadius.medium
    }
    
    func applyCardStyle(color: UIColor) {
        backgroundColor = color
        setTitleColor(DesignSystem.Colors.textLight, for: .normal)
        titleLabel?.font = DesignSystem.Typography.buttonTitle
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        layer.cornerRadius = DesignSystem.CornerRadius.large
        layer.shadowColor = DesignSystem.Shadow.medium.color.cgColor
        layer.shadowOpacity = DesignSystem.Shadow.medium.opacity
        layer.shadowOffset = DesignSystem.Shadow.medium.offset
        layer.shadowRadius = DesignSystem.Shadow.medium.radius
    }
}

// MARK: - UILabel Extensions
public extension UILabel {
    func applyTitleStyle() {
        font = DesignSystem.Typography.title2
        textColor = DesignSystem.Colors.textPrimary
    }
    
    func applyHeadlineStyle() {
        font = DesignSystem.Typography.headline
        textColor = DesignSystem.Colors.textPrimary
    }
    
    func applyBodyStyle() {
        font = DesignSystem.Typography.body
        textColor = DesignSystem.Colors.textPrimary
    }
    
    func applySubtitleStyle() {
        font = DesignSystem.Typography.subheadline
        textColor = DesignSystem.Colors.textSecondary
    }
    
    func applyCaptionStyle() {
        font = DesignSystem.Typography.caption1
        textColor = DesignSystem.Colors.textSecondary
    }
}

// MARK: - Cute Animations
public struct CuteAnimations {
    public static func bounceAnimation(for view: UIView, completion: (() -> Void)? = nil) {
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.allowUserInteraction], animations: {
            view.transform = .identity
        }, completion: { _ in
            completion?()
        })
    }
    
    public static func wiggleAnimation(for view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.values = [0, -0.1, 0.1, -0.1, 0.1, 0]
        animation.duration = 0.5
        animation.repeatCount = 1
        view.layer.add(animation, forKey: "wiggle")
    }
    
    public static func pulseAnimation(for view: UIView) {
        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: nil)
    }
    
    public static func slideInFromBottom(for view: UIView, delay: TimeInterval = 0) {
        view.transform = CGAffineTransform(translationX: 0, y: 50)
        view.alpha = 0
        
        UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            view.transform = .identity
            view.alpha = 1.0
        })
    }
} 
