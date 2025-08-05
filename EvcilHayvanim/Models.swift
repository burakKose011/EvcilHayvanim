//
//  Models.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import Foundation

// MARK: - Pet Models
struct Pet {
    let id: UUID
    var name: String
    var type: PetType
    var breed: String
    var birthDate: Date
    var weight: Double
    var gender: Gender
    var microchipNumber: String?
    var photoURL: URL?
}

enum PetType: String, CaseIterable {
    case dog = "Köpek"
    case cat = "Kedi"
    case bird = "Kuş"
    case fish = "Balık"
    case rabbit = "Tavşan"
    case hamster = "Hamster"
    case other = "Diğer"
    
    var iconName: String {
        switch self {
        case .dog: return "dog"
        case .cat: return "cat"
        case .bird: return "bird"
        case .fish: return "fish"
        case .rabbit: return "rabbit"
        case .hamster: return "hamster"
        case .other: return "pawprint"
        }
    }
}

enum Gender: String, CaseIterable {
    case male = "Erkek"
    case female = "Dişi"
}

// MARK: - Health Record Models
struct HealthRecord {
    let id: UUID
    let petId: UUID
    let date: Date
    let type: HealthRecordType
    let description: String
    let veterinarian: String?
    let attachments: [URL]
}

enum HealthRecordType: String, CaseIterable {
    case vaccination = "Aşı"
    case checkup = "Kontrol"
    case treatment = "Tedavi"
    case surgery = "Ameliyat"
    case medication = "İlaç"
    case other = "Diğer"
}

// MARK: - Appointment Models
struct Appointment {
    let id: UUID
    let petId: UUID
    let petName: String
    let date: Date
    let veterinarian: String
    let reason: String
    let notes: String?
    let status: AppointmentStatus
}

enum AppointmentStatus: String, CaseIterable {
    case scheduled = "Planlandı"
    case completed = "Tamamlandı"
    case cancelled = "İptal"
}

// MARK: - Reminder Models
struct Reminder {
    let id: UUID
    let title: String
    let date: Date
    let type: ReminderType
}

enum ReminderType {
    case vaccination
    case medication
    case appointment
    case checkup
} 