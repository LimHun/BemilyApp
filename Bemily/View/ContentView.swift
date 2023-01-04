//
//  ContentView.swift
//  Bemily
//
//  Created by 임훈 on 2023/01/02.
//

import SwiftUI

struct ContentView: View {
    
    @State var naxtPage: Bool = false
    @State var viewModel = APIManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(isActive: $naxtPage) {
                    BemilyDetailView()
                        .environmentObject(viewModel)
                        .navigationBarBackButtonHidden()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    
                                } label: {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("투데이")
                                    }
                                    .foregroundColor(.blue)
                                }
                            }
                        }
                } label: {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                }
                Spacer()
            }
            .padding()
        }
        .onAppear {
            viewModel.getApp()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation{
                    naxtPage.toggle()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
