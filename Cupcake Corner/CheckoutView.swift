//
//  CheckoutView.swift
//  Cupcake Corner
//
//  Created by Lucas Pennice on 16/02/2024.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var confirmationAlert = false
    @State private var confirmationMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3){image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total cost is \(order.cost.formatted(.currency(code: "USD")))")
                    .font(.title)
                
                Button{
                    Task{await placeOrder()}
                } label: {
                    if isLoading{
                        ProgressView()
                    } else{
                        Text("Place Order")
                    }
                }
                    .padding()
                    .buttonStyle(.bordered)
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank you!", isPresented: $confirmationAlert){
            } message:{
                Text(confirmationMessage)
            }
    }
    
    func placeOrder() async {
        guard let encodedOrder = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        withAnimation{
            isLoading = true
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do{
            let (data, _) = try await URLSession.shared.upload(for: request, from: encodedOrder)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) is on its way!"
            confirmationAlert = true
        }catch{
            print("Check out failed: \(error.localizedDescription)")
        }
        
        withAnimation{
            isLoading = false
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
