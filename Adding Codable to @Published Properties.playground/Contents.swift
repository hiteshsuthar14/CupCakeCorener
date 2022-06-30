/*
    Day 49
 
 
    If all the properties of a type conform to Codable, then the type        itself conform to Codable automatically.
    But this doesn’t work when we use property wrappers such as @Published

    Any property wrappper like @Published actually wraps the property inside another Struct named Published

    Swift has rules in place that say if an array contains Codable types then the whole array is Codable, and the same for dictionaries and sets. However, SwiftUI doesn’t provide the same functionality for its Published struct – it has no rule saying “if the published object is Codable, then the published struct itself is also Codable.”

    To have to make these property confrom to Codable on our own
