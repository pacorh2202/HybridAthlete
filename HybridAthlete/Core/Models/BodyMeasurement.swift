import Foundation

struct BodyMeasurement: Identifiable, Codable {
    let id: String
    let userId: String
    let date: Date
    var weightKg: Float
    var waistCm: Float?
    var hipCm: Float?
    var chestCm: Float?
    var armCm: Float?
    var thighCm: Float?
    var neckCm: Float?
    var bodyFatPct: Float?
    var leanMassKg: Float?
    var notes: String?

    enum CodingKeys: String, CodingKey {
        case id, date, notes
        case userId = "user_id"
        case weightKg = "weight_kg"
        case waistCm = "waist_cm"
        case hipCm = "hip_cm"
        case chestCm = "chest_cm"
        case armCm = "arm_cm"
        case thighCm = "thigh_cm"
        case neckCm = "neck_cm"
        case bodyFatPct = "body_fat_pct"
        case leanMassKg = "lean_mass_kg"
    }

    init(
        id: String = UUID().uuidString,
        userId: String,
        date: Date = Date(),
        weightKg: Float,
        waistCm: Float? = nil,
        hipCm: Float? = nil,
        chestCm: Float? = nil,
        armCm: Float? = nil,
        thighCm: Float? = nil,
        neckCm: Float? = nil,
        bodyFatPct: Float? = nil,
        leanMassKg: Float? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.date = date
        self.weightKg = weightKg
        self.waistCm = waistCm
        self.hipCm = hipCm
        self.chestCm = chestCm
        self.armCm = armCm
        self.thighCm = thighCm
        self.neckCm = neckCm
        self.bodyFatPct = bodyFatPct
        self.leanMassKg = leanMassKg
        self.notes = notes
    }
}
