//
//  ContentView.swift
//  Arda
//
//  Created by Jordan on 2/5/20.
//  Copyright © 2020 Jordan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let generator = UINotificationFeedbackGenerator()
    
    @ObservedObject var statistics = Statistics()
    @State var pool = 0
    @State private var isSharePresented: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text(LocalizedStringKey("roller.pool"))
                        Spacer()
                        Text(String(pool))
                    }
                }
                ForEach(statistics.statList, id:\.name) { stat in
                    StatView(statisticItem: stat, pool: self.$pool)
                }
                Section {
                    Group {
                        Image("Arda-Icon-Launch").resizable().frame(width: 100, height: 100)
                        .onTapGesture {
                            self.statistics.reroll()
                            self.pool = 0
                            
                            let impactLight = UIImpactFeedbackGenerator(style: .medium)
                            impactLight.impactOccurred()
                        }
                    }.position(x: UIScreen.main.bounds.width/2, y:50)
                }
            }
            .navigationBarTitle(Text(LocalizedStringKey("application.title")))
            .navigationBarItems(
                leading:
                    Button(LocalizedStringKey("roller.reroll")) {
                        self.statistics.reroll()
                        self.pool = 0
                    },
                trailing:
                    Button(action: {
                        self.isSharePresented = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
            )
        }.navigationViewStyle(StackNavigationViewStyle())
         .sheet(isPresented: $isSharePresented, onDismiss: {
                   // dismissed
               }, content: {
                ActivityViewController(activityItems: [self.statistics.description])
               })
    }
    
    struct StatView: View {
        @ObservedObject var statisticItem: StatisticItem
        @Binding var pool: Int

        var body: some View {
            HStack{
                Text(LocalizedStringKey(statisticItem.name))
                    .frame(width: 150, alignment: .topLeading)
                Text(String(statisticItem.startValue))
                    .frame(width: 50, alignment: .topLeading)
                Text(String(statisticItem.startValue+statisticItem.modifier))
                    .frame(width: 50, alignment: .topLeading)
                HStack() {
                    Button(action: {
                        if self.statisticItem.decreasable() {
                            self.statisticItem.modifier -= 1
                            self.pool += 1
                            let impactLight = UIImpactFeedbackGenerator(style: .light)
                            impactLight.impactOccurred()
                        }

                    }) {
                        Image(systemName: "minus.square.fill")
                    }.buttonStyle(BorderlessButtonStyle())
                    .padding(7)
                    Button(action: {
                        if self.statisticItem.increasable() && self.pool > 0 {
                            self.statisticItem.modifier += 1
                            self.pool -= 1
                            let impactLight = UIImpactFeedbackGenerator(style: .light)
                            impactLight.impactOccurred()
                        }
                    }) {
                        Image(systemName: "plus.square.fill")
                    }.buttonStyle(BorderlessButtonStyle())
                    .padding(7)
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .bottomTrailing)
            }
        }
    }
}

// https://stackoverflow.com/questions/56533564/showing-uiactivityviewcontroller-in-switui
struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.locale, .init(identifier: "es"))
    }
}
