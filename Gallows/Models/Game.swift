//
//  Game.swift
//  Gallows
//
//  Created by Андрей on 09.11.2021.
//

struct Game {
    var word: String
    var incorrectMovesRemaining: Int    // количество оставшихся попыток
    fileprivate var guessedLetters = [Character].init()   // fileprivate - доступно только в этом файле
    
    init(word: String, incorrectMovesRemaining: Int) {
        self.word = word
        self.incorrectMovesRemaining = incorrectMovesRemaining
    }
    
    var guessedWord: String {
        var wordToShow = ""
        for letter in word {
            if guessedLetters.contains(Character(letter.lowercased())) || letter == "-" || letter == " "{
                wordToShow += String(letter)
            } else {
                wordToShow += "_"
            }
        }
        return wordToShow
    }
    
    mutating func playerGuest(letter: Character) {
        let lowercasedLatter = Character(letter.lowercased())
        guessedLetters.append(lowercasedLatter)
        if !word.lowercased().contains(lowercasedLatter) {
            incorrectMovesRemaining -= 1
        }
    }
}
