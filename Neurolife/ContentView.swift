import SwiftUI
import Speech
import AVFoundation

// MARK: - MoodLevel Enum

enum MoodLevel: String, CaseIterable, Codable {
    case veryUnpleasant = "Very Unpleasant"
    case unpleasant = "Unpleasant"
    case neutral = "Neutral"
    case pleasant = "Pleasant"
    case veryPleasant = "Very Pleasant"

    static func fromScore(_ score: Double) -> MoodLevel {
        switch score {
        case 1...2.5: return .veryUnpleasant
        case 2.6...4.5: return .unpleasant
        case 4.6...6.5: return .neutral
        case 6.6...8.5: return .pleasant
        case 8.6...10: return .veryPleasant
        default: return .neutral
        }
    }

    var emoji: String {
        switch self {
        case .veryUnpleasant: return "😫"
        case .unpleasant: return "🙁"
        case .neutral: return "😐"
        case .pleasant: return "🙂"
        case .veryPleasant: return "😊"
        }
    }

    var displayText: String {
        "\(emoji) \(rawValue)"
    }
}

// MARK: - Emergency Help View (moved to top level)

// MARK: - Emergency Help View (with Personal Info)
struct MedicationEntry: Identifiable, Codable {
    var id = UUID()
    var name: String
    var time: Date
}


struct EmergencyHelpView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isCopilotActive = false
    @AppStorage("userMedicationsData") private var savedMedicationsData: Data = Data()
    @State private var medicationList: [MedicationEntry] = []
    @State private var newMedicationName: String = ""
    @State private var newMedicationTime: Date = Date()


    // Store personal info using @AppStorage for persistence
    @AppStorage("userName") private var name: String = ""
    @AppStorage("userAge") private var age: String = ""
    @AppStorage("userGender") private var gender: String = ""
    @AppStorage("userConditions") private var conditions: String = ""
    @AppStorage("userAllergies") private var allergies: String = ""
    @AppStorage("userMedications") private var medications: String = ""
    

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("🚨 Emergency info")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)

                Text("Here you can provide emergency contacts, coping tips, or a quick contact form.")
                    .font(.body)
                    .padding(.bottom)

                Divider().padding(.vertical)

                Text("🧾 Personal Info")
                    .font(.title2)
                    .bold()

                Group {
                    TextField("Name", text: $name)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    TextField("Gender", text: $gender)
                    TextField("Medical Conditions", text: $conditions)
                    TextField("Allergies", text: $allergies)
                    TextField("Medications", text: $medications)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

                Button(action: {
                    dismiss() // Info is auto-saved due to @AppStorage
                }) {
                    Text("✅ Save Info")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                Divider().padding(.vertical)

                Text("🛟 Emergency Copilot")
                    .font(.title2)
                    .bold()

                Text("Detects signs of distress using voice, text, and biometric cues. This feature helps trigger alerts or prepare emergency info if distress is detected. Please turn this feature on if you are working out,hiking or participating in any physical activity.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                Button(action: {
                    // Placeholder action for now
                    print("Emergency Copilot activated")
                }) {
                    Text("🎙️ Start Monitoring")
                
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

            }
            .padding()
        }
        .navigationTitle("Emergency")
        .navigationBarBackButtonHidden(false)
    }
}


// MARK: - Main Home View

struct ContentView: View {
    @State private var showLogOptions = false
    @State private var navigateToEmergency = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let minY = geometry.frame(in: .global).minY
                let height = geometry.size.height / 2.0

                ZStack {
                    Image("homescreenbg1")
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 4)
                      

                    Color.black
                        .opacity(CGFloat(max(0, minY) / height))

                    ScrollView {
                        VStack(alignment: .center, spacing: 20) {
                            Text("What's on Your Mind Today?")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)

                            Text("Your Unified Cognitive lifestyle Assistant")
                                .font(.title3)
                                .multilineTextAlignment(.center)

                            // Replaced Rectangle() with a custom view
                            VStack(spacing: 16) {
                                Button(action: {
                                    // Action for the first rectangle
                                }) {
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                                        .edgesIgnoringSafeArea(.horizontal)
                                        .overlay(
                                            Text("Content1")
                                                .foregroundColor(.white)
                                                .font(.headline)
                                        )
                                }

                                Button(action: {
                                    // Action for the second rectangle
                                }) {
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                                        .edgesIgnoringSafeArea(.horizontal)
                                        .overlay(
                                            Text("Content 2")
                                                .foregroundColor(.white)
                                                .font(.headline)
                                        )
                                }
                            }

                            Button(action: {
                                showLogOptions = true
                            }) {
                                Text("📊 Daily Mood Analysis")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }

                            Button(action: {
                                navigateToEmergency = true
                            }) {
                                Text("🚨 Emergency Info")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }

                            NavigationLink(destination: FinanceFlowView()) {
                                Text("💸 Finance Flow")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }

                            ChatBotView()
                                .padding(.top, 20)

                            Spacer()
                        }
                        .padding(.top, 60)
                    }
                }
            }
            .navigationTitle("Home")
            // Apply safeArea to the NavigationStack
            .sheet(isPresented: $showLogOptions) {
                MoodLoggingChoiceView()
            }
            .navigationDestination(isPresented: $navigateToEmergency) {
                EmergencyHelpView()
            }
        }
    }
}
struct ChatBotView: View {
    @State private var message = ""
    @State private var chatMessages: [String] = []
    @State private var isRecording = false
    @State private var speechRecognizer = SpeechRecognizer()

    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatMessages, id: \.self) { message in
                    Text(message)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        .foregroundColor(message.starts(with: "You:") ? .black : .white)
                }
            }
            .padding()

            HStack {
                Button(action: {
                    isRecording.toggle()
                    if isRecording {
                        speechRecognizer.startRecording { text in
                            message = text
                        }
                    } else {
                        speechRecognizer.stopRecording()
                    }
                }) {
                    Image(systemName: isRecording ? "stop.circle" : "mic.circle")
                        .font(.title2)
                }
                
                TextField("Type a message", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.black)
                
                Button(action: {
                    // Send message logic here
                    chatMessages.append("You: \(message)")
                    // Simulate chat bot response
                    chatMessages.append("Bot: Response to \(message)")
                    message = ""
                }) {
                    Text("Send")
                        .foregroundColor(.white) // Changed to white
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                }
                .background(Color.blue.opacity(0.8))
                .cornerRadius(8)
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("Chat with Us")
    }
}

class SpeechRecognizer: NSObject, ObservableObject {
    @Published var isRecording = false
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var onTextUpdate: ((String) -> Void)?

    func startRecording(onTextUpdate: @escaping (String) -> Void) {
        self.onTextUpdate = onTextUpdate
        isRecording = true
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let text = result.bestTranscription.formattedString
                onTextUpdate(text)
            }
            if error != nil || result?.isFinal == true {
                self.stopRecording()
            }
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }

    func stopRecording() {
        isRecording = false
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
    }
}

// MARK: - Logging Type Selection View
struct FinanceFlowView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showExpenseSheet = false
    @State private var showEarningsSheet = false

    var body: some View {
        VStack(spacing: 30) {
            Text("💰 Finance Tracker")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            Text("Manage your daily finances by logging your expenses and earnings.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)

            Button(action: { showExpenseSheet = true }) {
                Text("➖ Log Expense")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Button(action: { showEarningsSheet = true }) {
                Text("➕ Log Earning")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showExpenseSheet) {
            ExpenseLoggingView()
        }
        .sheet(isPresented: $showEarningsSheet) {
            EarningsLoggingView()
        }
        .navigationTitle("Finance Flow")
    }
}
struct ExpenseLoggingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Category (e.g., Food, Transport)", text: $category)
                    TextField("Notes (Optional)", text: $notes)
                }

                Button("Save Expense") {
                    // Save logic here
                    dismiss()
                }
                .disabled(amount.isEmpty || category.isEmpty)
            }
            .navigationTitle("Log Expense")
        }
    }
}

struct EarningsLoggingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var amount: String = ""
    @State private var source: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Earning Details")) {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Source (e.g., Freelance, Gifts)", text: $source)
                    TextField("Notes (Optional)", text: $notes)
                }

                Button("Save Earning") {
                    // Save logic here
                    dismiss()
                }
                .disabled(amount.isEmpty || source.isEmpty)
            }
            .navigationTitle("Log Earning")
        }
    }
}

struct MoodLoggingChoiceView: View {
    @Environment(\.dismiss) var dismiss
    @State private var moodData: [(Date, Double)] = [
        (Date().addingTimeInterval(-(86400 * 6)), 3),
        (Date().addingTimeInterval(-(86400 * 5)), 4),
        (Date().addingTimeInterval(-(86400 * 4)), 2),
        (Date().addingTimeInterval(-(86400 * 3)), 1),
        (Date().addingTimeInterval(-(86400 * 2)), 1),
        (Date().addingTimeInterval(-(86400)), 4),
        (Date(), 5)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Select Logging Type")
                    .font(.title)
                    .bold()

                NavigationLink(destination: MoodAnalysisView(loggingType: "Today", timestamp: Date())) {
                    Text("🕒 Log for Today")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: MoodAnalysisView(loggingType: "Week", timestamp: nil)) {
                    Text("📅 Log for This Week")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                LineChart(data: moodData)
                    .frame(height: 200)

                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)

                Spacer()
            }
            .padding()
        }
    }
}

struct LineChart: View {
    let data: [(Date, Double)]

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let xScale = geometry.size.width / CGFloat(data.count - 1)
                let yScale = geometry.size.height / 5 // Assuming 5 is the max value on the y-axis

                path.move(to: CGPoint(x: 0, y: geometry.size.height - CGFloat(data[0].1) * yScale))

                for (index, point) in data.enumerated() {
                    let x = CGFloat(index) * xScale
                    let y = geometry.size.height - CGFloat(point.1) * yScale
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}

// MARK: - Mood Analysis View with Feeling Tags

struct MoodAnalysisView: View {
    @Environment(\.dismiss) var dismiss
    let loggingType: String
    let timestamp: Date?
    
    @State private var moodValue: Double = 5
    @State private var selectedFeelings: Set<String> = []
    @State private var aiResponse: String = "Your AI result will appear here."
    
    let feelingsByMood: [MoodLevel: [String]] = [
        .veryUnpleasant: ["Hopeless", "Exhausted", "Angry", "Panicked", "Irritable", "Ashamed", "Worried", "Grieving"],
        .unpleasant: ["Tired", "Anxious", "Frustrated", "Sad", "Stressed", "Disappointed", "Lonely"],
        .neutral: ["Bored", "Meh", "Indifferent", "Calm", "Blank", "Okay", "Relaxed"],
        .pleasant: ["Content", "Motivated", "Inspired", "Optimistic", "Grateful", "Excited", "Focused"],
        .veryPleasant: ["Euphoric", "Joyful", "Energetic", "Elated", "Proud", "Confident", "Connected"]
    ]
    
    var allFeelings: [String] {
        Array(Set(feelingsByMood.values.flatMap { $0 })).sorted()
    }
    
    var moodLevel: MoodLevel {
        MoodLevel.fromScore(moodValue)
    }
    
    var recommendedFeelings: [String] {
        feelingsByMood[moodLevel] ?? []
    }
    
    var formattedTimestamp: String {
        guard let date = timestamp else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, h:mm a"
        return formatter.string(from: date)
    }
    
    func dynamicMoodColor() -> Color {
        switch moodLevel {
        case .veryUnpleasant:
            let opacity = 1 - ((moodValue - 1) / (2.5 - 1)) * 0.6
            return Color.orange.opacity(opacity)
        case .unpleasant:
            let opacity = 0.4 - ((moodValue - 2.6) / (4.5 - 2.6)) * 0.3
            return Color.orange.opacity(opacity)
        case .neutral:
            let opacity = 0.3 + ((moodValue - 4.6) / (6.5 - 4.6)) * 0.7
            return Color.blue.opacity(opacity)
        case .pleasant:
            let opacity = 0.5 + ((moodValue - 6.6) / (8.5 - 6.6)) * 0.5
            return Color.green.opacity(opacity)
        case .veryPleasant:
            return Color.green.opacity(1)
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.blue.opacity(0.3))
                .background(
                    Color.blue.opacity(0.15)
                        .blur(radius: 10)
                )
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 20) {
                    Text("Mood Analysis (\(loggingType))")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    if loggingType == "Today" {
                        Text("🕒 Time: \(formattedTimestamp)")
                            .font(.subheadline)
                            .foregroundColor(Color.white.opacity(0.8))
                    }

                    Text("How are you feeling today?")
                        .font(.title2)
                        .foregroundColor(.white)
                        
                    
                    Slider(value: $moodValue, in: 1...10, step: 2)
                        .accentColor(.white)

                    Text("Mood Level: \(moodLevel.displayText)")
                        .font(.headline)
                        .foregroundColor(.white)

                    if !recommendedFeelings.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Recommended feelings:")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)

                            feelingsGrid(for: recommendedFeelings)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("All feelings:")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)

                        feelingsGrid(for: allFeelings)
                    }

                    Button("Analyze Mood") {
                        analyzeMood()
                    }
                    .disabled(selectedFeelings.isEmpty)
                    .padding()
                    .background(selectedFeelings.isEmpty ? Color.white.opacity(0.2) : Color.white.opacity(0.4))
                    .foregroundColor(.blue)
                    .cornerRadius(10)

                    Text(aiResponse)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 600)
                        .foregroundColor(.white)

                }
                .padding()
            }
        }
        .navigationTitle("Mood Analysis")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    dismiss()
                }
            }
        }
    }

    func feelingsGrid(for feelings: [String]) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 12)], spacing: 12) {
            ForEach(feelings, id: \.self) { feeling in
                Button(action: {
                    if selectedFeelings.contains(feeling) {
                        selectedFeelings.remove(feeling)
                    } else {
                        selectedFeelings.insert(feeling)
                    }
                }) {
                    Text(feeling)
                        .lineLimit(1)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            selectedFeelings.contains(feeling)
                                ? dynamicMoodColor()
                                : dynamicMoodColor().opacity(0.3)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    func analyzeMood() {
        let selected = selectedFeelings.sorted().joined(separator: ", ")
        aiResponse = "🧠 Analyzing \(loggingType) mood: \(moodLevel.rawValue)\n🧾 Feelings: \(selected)"
        if loggingType == "Today", let _ = timestamp {
            aiResponse += "\n🕒 Logged at: \(formattedTimestamp)"
        }
    }
}
