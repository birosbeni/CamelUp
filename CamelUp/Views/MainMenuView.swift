import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink("Új játék kezdete", destination: NewGameSetupView())
                NavigationLink("Régi statisztikák megfigyelése", destination: Text("Később jön"))
            }
            .navigationTitle("Camel Up")
        }
    }
}
