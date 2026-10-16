import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack { ControlsView().navigationTitle("Controls") }
                .tabItem { Label("Controls", systemImage: "slider.horizontal.3") }
            NavigationStack { PickersView().navigationTitle("Pickers") }
                .tabItem { Label("Pickers", systemImage: "calendar") }
            NavigationStack { PresentationView().navigationTitle("Presentation") }
                .tabItem { Label("Present", systemImage: "rectangle.stack") }
            NavigationStack { ListsView().navigationTitle("Lists") }
                .tabItem { Label("Lists", systemImage: "list.bullet") }
        }
    }
}

// MARK: - Controls

struct ControlsView: View {
    @State private var text = ""
    @State private var secret = ""
    @State private var multiline = "Multi-line\ntext editor"
    @State private var toggle = true
    @State private var slider = 0.5
    @State private var stepper = 3
    @State private var segment = 0
    @State private var progress = 0.4
    @State private var tapCount = 0
    @State private var rating = 3

    var body: some View {
        Form {
            Section("Buttons") {
                Button("Default Button") { tapCount += 1 }
                Button("Bordered") { tapCount += 1 }.buttonStyle(.bordered)
                Button("Bordered Prominent") { tapCount += 1 }.buttonStyle(.borderedProminent)
                Button("Destructive", role: .destructive) { tapCount += 1 }.buttonStyle(.bordered)
                Button { tapCount += 1 } label: { Label("With Icon", systemImage: "star.fill") }
                    .buttonStyle(.borderedProminent).tint(.orange)
                Text("Taps: \(tapCount)").foregroundStyle(.secondary)
            }

            Section("Text input") {
                TextField("Text field", text: $text)
                SecureField("Secure field", text: $secret)
                TextEditor(text: $multiline).frame(height: 80)
            }

            Section("Toggle, slider, stepper") {
                Toggle("Toggle", isOn: $toggle)
                VStack(alignment: .leading) {
                    Text("Slider: \(slider, specifier: "%.2f")")
                    Slider(value: $slider)
                }
                Stepper("Stepper: \(stepper)", value: $stepper, in: 0...10)
            }

            Section("Segmented & menu") {
                Picker("Segmented", selection: $segment) {
                    Text("One").tag(0); Text("Two").tag(1); Text("Three").tag(2)
                }.pickerStyle(.segmented)

                Menu("Menu (drop-down)") {
                    Button("Action 1", systemImage: "1.circle") {}
                    Button("Action 2", systemImage: "2.circle") {}
                    Divider()
                    Button("Delete", systemImage: "trash", role: .destructive) {}
                }
            }

            Section("Progress") {
                ProgressView(value: progress)
                ProgressView("Loading…")
                Gauge(value: progress) { Text("Gauge") }
                Button("Advance") { progress = min(1, progress + 0.1) }
                Button("Reset") { progress = 0 }
            }

            Section("Misc") {
                Link("Link to apple.com", destination: URL(string: "https://apple.com")!)
                ShareLink(item: "Hello from UI Showcase")
                HStack {
                    Text("Rating")
                    Spacer()
                    ForEach(1...5, id: \.self) { i in
                        Image(systemName: i <= rating ? "star.fill" : "star")
                            .foregroundStyle(.yellow)
                            .onTapGesture { rating = i }
                    }
                }
                LabeledContent("Labeled content", value: "Value")
                DisclosureGroup("Disclosure group") {
                    Text("Hidden content revealed.")
                }
            }
        }
    }
}

// MARK: - Pickers

struct PickersView: View {
    @State private var date = Date()
    @State private var time = Date()
    @State private var color = Color.blue
    @State private var fruit = "Apple"
    @State private var wheel = 1
    @State private var photo: PhotosPickerItem?
    @State private var multi = Set<String>()
    let fruits = ["Apple", "Banana", "Cherry", "Mango"]

    var body: some View {
        Form {
            Section("Date & time") {
                DatePicker("Compact date", selection: $date, displayedComponents: .date)
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                DatePicker("Graphical", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            Section("Selection") {
                Picker("Menu picker", selection: $fruit) {
                    ForEach(fruits, id: \.self) { Text($0) }
                }
                Picker("Wheel", selection: $wheel) {
                    ForEach(0..<10) { Text("Item \($0)").tag($0) }
                }.pickerStyle(.wheel)
                Picker("Inline", selection: $fruit) {
                    ForEach(fruits, id: \.self) { Text($0) }
                }.pickerStyle(.inline)
                ColorPicker("Colour", selection: $color)
                RoundedRectangle(cornerRadius: 12).fill(color).frame(height: 40)
            }
            Section("Photos") {
                PhotosPicker("Pick a photo", selection: $photo, matching: .images)
                if photo != nil { Text("Photo selected ✓") }
            }
        }
    }
}

// MARK: - Presentation

struct PresentationView: View {
    @State private var showAlert = false
    @State private var showConfirm = false
    @State private var showSheet = false
    @State private var showFull = false
    @State private var showPopover = false
    @State private var toast = false
    @State private var name = ""
    @State private var showPrompt = false

    var body: some View {
        List {
            Button("Alert") { showAlert = true }
            Button("Alert with text field") { showPrompt = true }
            Button("Confirmation dialog (action sheet)") { showConfirm = true }
            Button("Sheet") { showSheet = true }
            Button("Full-screen cover") { showFull = true }
            Button("Popover") { showPopover = true }
                .popover(isPresented: $showPopover) {
                    Text("Popover content").padding().presentationCompactAdaptation(.popover)
                }
            NavigationLink("Push navigation", destination: Text("Pushed screen").navigationTitle("Detail"))
            if toast { Text("Hello \(name)!").foregroundStyle(.green) }
        }
        .alert("Alert", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: { Text("This is a standard alert.") }
        .alert("Your name?", isPresented: $showPrompt) {
            TextField("Name", text: $name)
            Button("OK") { toast = true }
            Button("Cancel", role: .cancel) {}
        }
        .confirmationDialog("Choose", isPresented: $showConfirm) {
            Button("Option A") {}
            Button("Option B") {}
            Button("Delete", role: .destructive) {}
        }
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 16) {
                Text("Sheet").font(.title)
                Button("Dismiss") { showSheet = false }.buttonStyle(.borderedProminent)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showFull) {
            ZStack {
                Color.indigo.ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("Full screen").font(.largeTitle).foregroundStyle(.white)
                    Button("Close") { showFull = false }.buttonStyle(.borderedProminent).tint(.white)
                        .foregroundStyle(.indigo)
                }
            }
        }
    }
}

// MARK: - Lists

struct ListsView: View {
    @State private var items = ["Swipe me", "Reorder me", "Delete me", "Another row"]
    @State private var search = ""
    @State private var fav = Set<String>()

    var filtered: [String] {
        search.isEmpty ? items : items.filter { $0.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        List {
            Section("Rows (search, swipe, edit)") {
                ForEach(filtered, id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
                        if fav.contains(item) { Image(systemName: "heart.fill").foregroundStyle(.red) }
                    }
                    .swipeActions(edge: .leading) {
                        Button { fav.insert(item) } label: { Label("Fav", systemImage: "heart") }.tint(.pink)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) { items.removeAll { $0 == item } } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .contextMenu {
                        Button("Favourite", systemImage: "heart") { fav.insert(item) }
                        Button("Copy", systemImage: "doc.on.doc") { UIPasteboard.general.string = item }
                    }
                }
                .onMove { items.move(fromOffsets: $0, toOffset: $1) }
            }
            Section("Grid") {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                    ForEach(0..<8) { i in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hue: Double(i) / 8, saturation: 0.7, brightness: 0.9))
                            .frame(height: 50)
                    }
                }
            }
        }
        .searchable(text: $search)
        .toolbar { EditButton() }
    }
}
