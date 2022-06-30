//
//  CheckoutView.swift
//  CupCake Corner
//
//  Created by Hitesh Suthar on 27/06/22.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 233) //fixed height for both placeholder and upcoming image

                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                Button("Place Order") {
                    Task { //We cant use .task in action because we cant use method in an action so we have "Task"
                        await placeOrder() //await is used in every async function
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    } //----- Sending Data to the server -----
    func placeOrder() async {
        // 1. Convert our current order object into some JSON data that can be sent.
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        //2. Letting know server
        //2.1 what type of data we are sending 2.2 which HTTP method (e.g POST)
        let url = URL(string: "https://reqres.in/api/cupcakes")! // ! force unwraps the URL(string:) means if this url doesnt exitst just crash the code
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") //Type of data
        request.httpMethod = "POST" // HTTP method
        
        // 3. Creating network request
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            //Reqres will mirror this data i.e send it back
            //data from Reqres
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            
        } catch {
            print("Checkout failed.")
        }
        
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
