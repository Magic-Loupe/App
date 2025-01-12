import FairApp
import JXHostUI

import AboutMe
import AnimalFarm
import DatePlanner
import PetStore

/// The main content view for the app. This is the starting point for customizing you app's behavior.
struct ContentView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        NavigationView {
            PlaygroundListView()
        }
    }
}

extension Store {
    /// The host environment for the current bundle, which is expected to contain the `Package.resolved` for the package's dependencies.
    static let host = try! JXHostBundle(bundle: .module)
}

struct PlaygroundListView: View {
    @EnvironmentObject var store: Store

    /// Returns the branches to display in the versions list, which will be contingent on development mode being enabled.
    var branches: [String] {
        store.developmentMode == true ? ["main"] : []
    }

    var body: some View {
        List {
            Section("Sample Apps") {
                entryLink(from: PetStoreModule.self, name: "Pet Store", symbol: "hare") { ctx in
                    PetStoreView(context: ctx)
                }
                entryLink(from: AnimalFarmModule.self, name: "Animal Farm", symbol: "pawprint") { ctx in
                    AnimalFarmView(context: ctx)
                }
                entryLink(from: AboutMeModule.self, name: "About Me", symbol: "person") { ctx in
                    AboutMeView(context: ctx)
                }
                entryLink(from: DatePlannerModule.self, name: "Date Planner", symbol: "calendar") { ctx in
                    DatePlannerView(context: ctx)
                }
                // add more applications here…
            }
            .symbolVariant(.fill)
        }
        .navigationTitle(Text("Showcase", bundle: .module, comment: "navigation title for view"))
    }


    @ViewBuilder func entryLink<M: JXDynamicModule, V: View>(from: M.Type, name: String, symbol: String, view: @escaping (JXContext) -> V) -> some View {
        M.moduleNavigationLink(host: Store.host, name: name, symbol: symbol, branches: branches, developmentMode: store.developmentMode, strictMode: store.strictMode, errorHandler: { store.reportError($0) }, view: view)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store())
    }
}
