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
        content.font(.largeTitle).foregroundColor(.blue)
    }
}


struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gameEnded = false
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    

    var body: some View {
        
        ZStack {
//            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
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
//                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flaggedTapped(number)
                            
                        } label : {
//                            Image(countries[number])
//                                .renderingMode(.original)
//                                .clipShape(Capsule())
//                                .shadow(radius: 5)
                            FlagImage(country: countries[number]) // Views and Modifiers challenge 2
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

            } .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        

        // Can we hide this?
        if gameEnded { Button("Restart Game", action: resetGame)
                .alert(isPresented: $gameEnded) {
                    Alert(title: Text("Game over"), message: Text("Congratulations you scored \(score) points"), dismissButton: .default(Text("Restart Game"), action: resetGame))
                }
        }

    }

    func flaggedTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            print(score)

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
