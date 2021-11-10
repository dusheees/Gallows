//
//  Game.swift
//  Gallows
//
//  Created by Андрей on 09.11.2021.
//

struct MultiGame {
    
    // MARK: - Properties
    var word: String
    var incorrectMovesRemainingFirstPlayer: Int // количество оставшихся попыток у первого игрока
    var incorrectMovesRemainingSecondPlayer: Int // количество оставшихся попыток у второго игрока
    var guessedLettersFirstPlayer = [Character].init() // список нажатых кнопок у первого игрока
    var guessedLettersSecondPlayer = [Character].init() // список нажатых кнопок у второго игрока
    var playerTurn: Int
    
    init(word: String, incorrectMovesRemainingFirstPlayer: Int, incorrectMovesRemainingSecondPlayer: Int, playerTurn: Int) {
        self.word = word
        self.incorrectMovesRemainingFirstPlayer = incorrectMovesRemainingFirstPlayer
        self.incorrectMovesRemainingSecondPlayer = incorrectMovesRemainingSecondPlayer
        self.playerTurn = playerTurn
    }
    
    var guessedWordFirstPlayer: String {
        return forGuessedWord(guessedLetters: guessedLettersFirstPlayer)
    }
    
    var guessedWordSecondPlayer: String {
        return forGuessedWord(guessedLetters: guessedLettersSecondPlayer)
    }
    
    // MARK: - Methods
    func forGuessedWord(guessedLetters: [Character]) -> String {
        var wordToShow = ""
        for letter in word {
            if guessedLetters.contains(Character(letter.lowercased())) || letter == "-" || letter == " " {
                wordToShow += String(letter)
            } else {
                wordToShow += "_"
            }
        }
        return wordToShow
    }
    
    mutating func playerGuest(letter: Character) {
        let lowercasedLatter = Character(letter.lowercased())
        switch playerTurn {
        case 0:
            guessedLettersFirstPlayer.append(lowercasedLatter)
            if !word.lowercased().contains(lowercasedLatter) {
                incorrectMovesRemainingFirstPlayer -= 1
            }
        case 1:
            guessedLettersSecondPlayer.append(lowercasedLatter)
            if !word.lowercased().contains(lowercasedLatter) {
                incorrectMovesRemainingSecondPlayer -= 1
            }
        default:
            print("fatal error")
        }
    }
    
}
