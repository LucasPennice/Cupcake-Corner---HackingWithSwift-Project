//
//  AddressView.swift
//  Cupcake Corner
//
//  Created by Lucas Pennice on 16/02/2024.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
                
            }
            
            Section{
                NavigationLink(destination: CheckoutView(order: order)){
                    Label {Text("Check Out")} icon: {
                        Image(systemName: "birthday.cake")
                            .foregroundColor(.orange)
                    }
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
