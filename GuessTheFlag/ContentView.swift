//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Eugene on 11/08/2023.
//
// Project 2 (Day 20)

import SwiftUI


// Views and modifiers challenge 3
extension View {
     func blueFontStyle() -> some View {
         modifier(BlueFont())
     }
 }

struct FlagImage: View {
    
    var country: String
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)

        
    }
}

struct BlueFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.largeTitle).foregroundColor(.cyan)
    }
}


struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gameEnded = false
    
    @State private var animationAmount = 0.0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var selectedFlag = -1
    
    var body: some View {
        
        ZStack {

            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Text("Guess the flag")
                    .blueFontStyle()
                    
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            animationAmount += 360
                            selectedFlag = number
                            flaggedTapped(number)
                            
                        } label : {
                            FlagImage(country: countries[number])  // Views and Modifiers challenge 2
                                .rotation3DEffect(.degrees(selectedFlag == number ? animationAmount : 0 ), axis: (x: 0, y: 1, z: 0))  // Animations challenge 1.
                                // Do not need the withAnimation closure in the button to wrap the addition to the
                                // animationAmount as we are animating the label not the button itself.  Adding the closure results in animating all 3 at the same time, not just the one tapped
                                .opacity(((selectedFlag == number) || (selectedFlag == -1)) ? 1.0 : 0.25) // Animations challenge 2, change opacity to 0.25 for non tapped flags.  Better solution?
                                .scaleEffect((selectedFlag == -1) ? 1 : ((selectedFlag == number ) ? 1.1 : 0.5))
                                // Animation challenge 3, add more animations to non tapped flags.  Do not need additional .animation modifier for it to work
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                           
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()

                Text("Score \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()

            }
            .padding()
            .alert(isPresented: $gameEnded) {
                Alert(title: Text("Game over"), message: Text("Congratulations you scored \(score) points"), dismissButton: .default(Text("Restart Game"), action: resetGame))
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        

    }

    func flaggedTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1

        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        if score > 7 {
            gameEnded = true
        } else {
            showingScore = true
            
        }
       
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
        
    }
    
    func resetGame() {
        gameEnded = false
        score = 0;
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
