import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    var name: String
    var birthDate: Date?
    var sex: String? // "male", "female", "other"
    var heightCm: Float?
    var weightKg: Float?
    var goal: String? // "muscle_gain", "fat_loss", "recomp", "performance"
    var experienceLevel: String? // "beginner", "intermediate", "advanced"
    let createdAt: Date
    var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, email, name
        case birthDate = "birth_date"
        case sex
        case heightCm = "height_cm"
        case weightKg = "weight_kg"
        case goal
        case experienceLevel = "experience_level"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(
        id: String,
        email: String,
        name: String = "",
        birthDate: Date? = nil,
        sex: String? = nil,
        heightCm: Float? = nil,
        weightKg: Float? = nil,
        goal: String? = nil,
        experienceLevel: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.birthDate = birthDate
        self.sex = sex
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.goal = goal
        self.experienceLevel = experienceLevel
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
