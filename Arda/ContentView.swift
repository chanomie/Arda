//
//  ContentView.swift
//  Arda
//
//  Created by Jordan on 2/5/20.
//  Copyright © 2020 Jordan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var statistics = Statistics()
    @State var pool = 0
    @State private var isSharePresented: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(statistics.statList, id:\.name) { stat in
                    StatView(statisticItem: stat, pool: self.$pool)
                }
                Section {
                    HStack {
                        Text("Pool")
                        Spacer()
                        Text(String(pool))
                    }
                }
            }
            .navigationBarTitle(Text("Stat Roller"))
            .navigationBarItems(
                leading:
                    Button("Reroll") {
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
        } .sheet(isPresented: $isSharePresented, onDismiss: {
                   print("Dismiss")
               }, content: {
                   ActivityViewController(activityItems: [URL(string: "https://www.apple.com")!])
               })
    }
    
    struct StatView: View {
        @ObservedObject var statisticItem: StatisticItem
        @Binding var pool: Int

        var body: some View {
            HStack{
                Text(statisticItem.name)
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
                        }
                    }) {
                        Image(systemName: "minus.square.fill")
                    }.buttonStyle(BorderlessButtonStyle())
                    .padding(7)
                    Button(action: {
                        if self.statisticItem.increasable() && self.pool > 0 {
                            self.statisticItem.modifier += 1
                            self.pool -= 1
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
        ContentView()
    }
}
