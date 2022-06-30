//
//  Order.swift
//  CupCake Corner
//
//  Created by Hitesh Suthar on 27/06/22.
//

import SwiftUI
class Order: ObservableObject, Codable {
    
    // To send data to the server we have to convert them into JSON but we cant convert @Published proprties directly using Codable .. Hence need to make them able to conform
    
    //---Process ---
    // 1. List all the properties which needed to be coded into using "enum with CodingKey protocol"
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    
    static let types = ["Vanilla", "Strawberry", "Cocolate", "Rainbow"] //static means this array can not be changed or override
    
    @Published var type = 0
    @Published var quantity = 3
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false // @Published can not be archived with Codable protocol so need to make them codable using Codable keys
    
    //----- Checkout page -----
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    //----- Cost Calculation -----
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(type) / 2)

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }

        return cost
    }

    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
    // 4. initalizer for object creation of Order class in Content view -----Done-----
    init() {}
    
    //2. Create encode(to:) method that creates a container using the coding keys enum, then writes out all the properties attached to their respective key.
    func encode(to encoder: Encoder) throws { // Instance method for Encodable protocol(protocol = Class) which comes under Codable (Type alias of Encodable and Decodable) i.e thats what Codable do  behind the scenes. here we did this manually
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)

        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)

        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    // We dont need catch for try because of throws, any problems will automatically propagate upwards and be handled elsewhere.
    // If the value fails to encode anything, encoder will encode an empty keyed container in its place.
    // This function throws an error if any values are invalid for the given encoder’s format.
    }
    
    //3. Implement a "required init" to decode an instance of Order from some archived data. This is pretty much the reverse of encoding, and even benefits from the same throws functionality
    required init(from decoder: Decoder) throws { // Conforming to decodable protocol
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)

        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)

        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
}
