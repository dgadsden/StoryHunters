import FirebaseFirestore
import FirebaseFirestoreSwift

struct Recommendation: Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var recommendedBy: String?
    var recommendedTo: String?
    var date: Date?  // Use Date instead of Timestamp
    var likedByUser: Bool?
    var dislikedByUser: Bool?

    // Custom initializer to handle Timestamp conversion
    init(id: String, title: String, description: String, recommendedBy: String, recommendedTo: String, date: Timestamp?, likedByUser: Bool? = nil, dislikedByUser: Bool? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.recommendedBy = recommendedBy
        self.recommendedTo = recommendedTo
        self.date = date?.dateValue()  // Convert Timestamp to Date
        self.likedByUser = likedByUser
        self.dislikedByUser = dislikedByUser
    }
}
