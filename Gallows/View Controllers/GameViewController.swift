//
//  GameViewController.swift
//  Gallows
//
//  Created by Андрей on 08.11.2021.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Properties
    // game fields
    var listOfWords: [String] = []
    var navigationTitle: String = ""
    // for singlegame
    let incorrectMovesAllowed = 7
    var totalWins: Int = 0 {
        didSet {
            forDidSetSingleplayer(totalWins: totalWins, totalLosses: totalLosses)
        }
    }
    var totalLosses: Int = 0 {
        didSet {
            forDidSetSingleplayer(totalWins: totalWins, totalLosses: totalLosses)
        }
    }
    var currentSingleGame: SingleGame!
    // for multigame
    var wordsForGame = WordsForGame()
    var listOfWordsFirstPlayer = [String].init()
    var listOfWordsSecondPlayer = [String].init()
    let incorrectMovesAllowedFirstPlayer = 7
    let incorrectMovesAllowedSecondPlayer = 7
    var forScoreLabelFirstPlayer: String = ("Выигрыши: 0, проигрыши: 0")
    var forScoreLabelSecondPlayer: String = ("Выигрыши: 0, проигрыши: 0")
    var totalWinsFirstPlayer: Int = 0 {
        didSet {
            forDidSetMultiplayer(totalWins: totalWinsFirstPlayer, totalLosses: totalLossesFirstPlayer)
        }
    }
    var totalLossesFirstPlayer: Int = 0 {
        didSet {
            forDidSetMultiplayer(totalWins: totalWinsFirstPlayer, totalLosses: totalLossesFirstPlayer)
        }
    }
    var totalWinsSecondPlayer: Int = 0 {
        didSet {
            forDidSetMultiplayer(totalWins: totalWinsSecondPlayer, totalLosses: totalLossesSecondPlayer)
        }
    }
    var totalLossesSecondPlayer: Int = 0 {
        didSet {
            forDidSetMultiplayer(totalWins: totalWinsSecondPlayer, totalLosses: totalLossesSecondPlayer)
        }
    }
    var currentMultiGame: MultiGame!
    var buttontag: Int = 0
    var playerTurn: Int = 0 {
        didSet {
            switch playerTurn {
            case 0:
                titleForNumberOfPlayer = "First player"
            case 1:
                titleForNumberOfPlayer = "Second player"
            default:
                print("fatal error")
            }
        }
    }
    // for correct item size
    let size: CGSize!
    let factor: CGFloat!
    
    init?(coder: NSCoder, listOfWords: [String], wordsForGame: WordsForGame, navigationTitle: String, size: CGSize, factor: CGFloat, buttontag: Int){
        self.listOfWords = listOfWords
        self.wordsForGame = wordsForGame
        self.navigationTitle = navigationTitle
        self.size = size
        self.factor = factor
        self.buttontag = buttontag
        switch listOfWords {
        case wordsForGame.cities:
            listOfWordsFirstPlayer = wordsForGame.cities.shuffled()
            listOfWordsSecondPlayer = wordsForGame.cities.shuffled()
        case wordsForGame.movies:
            listOfWordsFirstPlayer = wordsForGame.movies.shuffled()
            listOfWordsSecondPlayer = wordsForGame.movies.shuffled()
        default:
            print("fatal error")
        }
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // title for number of player
    var titleForNumberOfPlayer = "First player"
    
    // MARK: - UIProperties
    // game stack view
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameStackView: UIStackView!
    // intermediate stack view
    @IBOutlet weak var intermediateStackView: UIStackView!
    @IBOutlet weak var goLabel: UILabel!
    @IBOutlet weak var goScoreLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    // result stack view
    @IBOutlet weak var resultStackView: UIStackView!
    @IBOutlet weak var finishedTextLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    // result stack view for multiplayer
    @IBOutlet weak var resultStackViewForMultiPlayer: UIStackView!
    @IBOutlet weak var textResultsLabel: UILabel!
    @IBOutlet weak var resultLabelFirstPlayer: UILabel!
    @IBOutlet weak var resultLabelSecondPlayer: UILabel!
    // navigation
    @IBOutlet weak var navigationButton: UIBarButtonItem!
    @IBOutlet weak var numberOfPlayer: UIBarButtonItem!
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        correctSize()
        
        resultStackView.isHidden = true
        resultStackViewForMultiPlayer.isHidden = true
        intermediateStackView.isHidden = true
        gameStackView.isHidden = false
        
        numberOfPlayer.title = titleForNumberOfPlayer
        numberOfPlayer.isEnabled = false
        
        navigationItem.title = navigationTitle
        navigationItem.hidesBackButton = true
        
        updateUI(to: view.bounds.size)
        if buttontag == 0 {
            numberOfPlayer.title = ""
        }
        
        newRound()
    }
    
    // functions for change wins and losses values
    func forDidSetSingleplayer(totalWins: Int, totalLosses: Int) {
        scoreLabel.text = ("Выигрыши: \(totalWins), проигрыши: \(totalLosses)")
        newRound()
    }
    
    func forDidSetMultiplayer(totalWins: Int, totalLosses: Int) {
        goScoreLabel.text = ("Выигрыши: \(totalWins), проигрыши: \(totalLosses)")
        switch playerTurn {
        case 0:
            forScoreLabelFirstPlayer = goScoreLabel.text!
        case 1:
            forScoreLabelSecondPlayer = goScoreLabel.text!
        default:
            print("fatal error")
        }
        playerTurn = (playerTurn + 1) % 2
        goLabel.text = ("Следующий ход игрока №\(playerTurn + 1)")
        intermediateStackView.isHidden = false
        gameStackView.isHidden = true
        numberOfPlayer.title = ""
        newRound()
    }
    
    // function for correct item size
    func correctSize() {
        for button in letterButtons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: factor / 20)
        }
        correctWordLabel.font = UIFont.systemFont(ofSize: factor / 16)
        scoreLabel.font = UIFont.systemFont(ofSize: factor / 16)
        
        goLabel.font = UIFont.systemFont(ofSize: factor / 16)
        goScoreLabel.font = UIFont.systemFont(ofSize: factor / 16)
        goButton.titleLabel?.font = UIFont.systemFont(ofSize: factor / 12)
        
        guard let coefficient = size.height / size.width < 2 && size.height / size.width > 0.5 ? 0.75 : 1 else {
            return
        }
        finishedTextLabel.font = UIFont.systemFont(ofSize: coefficient * factor / 16)
        resultLabel.font = UIFont.systemFont(ofSize: coefficient * factor / 16)
        textResultsLabel.font = UIFont.systemFont(ofSize: factor / 16)
        resultLabelFirstPlayer.font = UIFont.systemFont(ofSize: coefficient * factor / 17)
        resultLabelSecondPlayer.font = UIFont.systemFont(ofSize: coefficient * factor / 17)
        
        navigationButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.systemFont(ofSize: coefficient * factor / 25)], for: [])
        numberOfPlayer.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: coefficient * factor / 25)], for: .disabled)
        
    }
    
    func enabledButtons(_ enable: Bool = true) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    func newRound() {
        if listOfWords.isEmpty || listOfWordsSecondPlayer.isEmpty {
            enabledButtons(false)
            intermediateStackView.isHidden = true
            gameStackView.isHidden = true
            resultStackView.isHidden = false
            resultLabel.text = scoreLabel.text
            if buttontag == 1 {
                if totalWinsFirstPlayer > totalWinsSecondPlayer {
                    resultLabel.text = "Победил игрор №1"
                } else if totalWinsFirstPlayer < totalWinsSecondPlayer {
                    resultLabel.text = "Победил игрор №2"
                } else {
                    resultLabel.text = "Ничья"
                }
                
                resultLabel.textColor = .red
                resultLabelFirstPlayer.textColor = .systemBlue
                resultLabelSecondPlayer.textColor = .systemBlue
                resultLabelFirstPlayer.text = "№1: " + forScoreLabelFirstPlayer
                resultLabelSecondPlayer.text = "№2: " + forScoreLabelSecondPlayer
                resultStackViewForMultiPlayer.isHidden = false
            }
            updateUI()
            return
        } else {
            switch buttontag {
            case 0:
                currentSingleGame = SingleGame(word: listOfWords.removeFirst(), incorrectMovesRemaining: incorrectMovesAllowed)
            case 1:
                switch playerTurn {
                case 0:
                    currentMultiGame = MultiGame(word: listOfWordsFirstPlayer.removeFirst(), incorrectMovesRemainingFirstPlayer: incorrectMovesAllowedFirstPlayer, incorrectMovesRemainingSecondPlayer: incorrectMovesAllowedSecondPlayer, playerTurn: playerTurn)
                case 1:
                    currentMultiGame = MultiGame(word: listOfWordsSecondPlayer.removeFirst(), incorrectMovesRemainingFirstPlayer: incorrectMovesAllowedFirstPlayer, incorrectMovesRemainingSecondPlayer: incorrectMovesAllowedSecondPlayer, playerTurn: playerTurn)
                default:
                    print("fatal error")
                }
                
            default:
                print("fatal error")
            }
            updateUI()
            enabledButtons()
        }
    }
    
    // for correct word representation
    func updateWordLabel(guessedWord: String) {
        var displayWord: [String] = []
        for letter in guessedWord {
            displayWord.append(String(letter))
        }
        correctWordLabel.text = displayWord.joined(separator: " ")
    }
    
    // update wins and losses
    func updateState() {
        switch buttontag {
        case 0:
            if currentSingleGame.incorrectMovesRemaining < 1 { // или == 0
                totalLosses += 1
            } else if currentSingleGame.guessedWord == currentSingleGame.word {
                totalWins += 1
            } else {
                updateUI()
            }
        case 1:
            switch playerTurn {
            case 0:
                if currentMultiGame.incorrectMovesRemainingFirstPlayer < 1 {
                    totalLossesFirstPlayer += 1
                } else if currentMultiGame.guessedWordFirstPlayer == currentMultiGame.word {
                    totalWinsFirstPlayer += 1
                } else {
                    updateUI()
                }
            case 1:
                if currentMultiGame.incorrectMovesRemainingSecondPlayer < 1 {
                    totalLossesSecondPlayer += 1
                } else if currentMultiGame.guessedWordSecondPlayer == currentMultiGame.word {
                    totalWinsSecondPlayer += 1
                } else {
                    updateUI()
                }
            default:
                print("fatal error")
            }
        default:
            print("fatal error")
        }
    }
    
    func updateUI() {
        switch buttontag {
        case 0:
            let movesRemaining = currentSingleGame.incorrectMovesRemaining
            let imageNumber = (movesRemaining + 64) % 8
            let image = "Tree\(imageNumber)"
            treeImageView.image = UIImage(named: image)
            scoreLabel.text = ("Выигрыши: \(totalWins), проигрыши: \(totalLosses)")
            updateWordLabel(guessedWord: currentSingleGame.guessedWord)
        case 1:
            let movesRemainingFirstPlayer = currentMultiGame.incorrectMovesRemainingFirstPlayer
            let movesRemainingSecondPlayer = currentMultiGame.incorrectMovesRemainingSecondPlayer
            let imageNumberFirstPlayer = (movesRemainingFirstPlayer + 64) % 8
            let imagenumberSecondPlayer = (movesRemainingSecondPlayer + 64) % 8
            
            switch playerTurn {
            case 0:
                let imageFirstPlayer = "Tree\(imageNumberFirstPlayer)"
                treeImageView.image = UIImage(named: imageFirstPlayer)
                scoreLabel.text = forScoreLabelFirstPlayer
                updateWordLabel(guessedWord: currentMultiGame.guessedWordFirstPlayer)
            case 1:
                let imageSecondPlayer = "Tree\(imagenumberSecondPlayer)"
                treeImageView.image = UIImage(named: imageSecondPlayer)
                scoreLabel.text = forScoreLabelSecondPlayer
                updateWordLabel(guessedWord: currentMultiGame.guessedWordSecondPlayer)
            default:
                print("fatal error")
            }
        default:
            print("fatal error")
        }
    }
    
    // for correct change of size
    func updateUI(to size: CGSize) {
        gameStackView.axis = size.height < size.width ? .horizontal : .vertical
        gameStackView.frame = CGRect(x: 8, y: 8, width: size.width - 16, height: size.height - 16)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        gameStackView.axis = size.height < size.width ? .horizontal : .vertical
        gameStackView.frame = CGRect(x: 8, y: 8, width: size.width - 16, height: size.height - 16)
    }
    
    // MARK: - Actions
    @IBAction func goPressed(_ sender: Any) {
        intermediateStackView.isHidden = true
        gameStackView.isHidden = false
        numberOfPlayer.title = titleForNumberOfPlayer
    }
    
    
    @IBAction func letterButtonPressed(_ sender: UIButton) {
        let letter = sender.title(for: .normal)!
        switch buttontag {
        case 0:
            sender.isEnabled = false
            currentSingleGame.playerGuest(letter: Character(letter))
        case 1:
            currentMultiGame.playerGuest(letter: Character(letter))
            currentMultiGame.playerTurn = playerTurn
            for `button` in letterButtons {
                switch playerTurn {
                case 0:
                    if currentMultiGame.guessedLettersFirstPlayer.contains(Character((`button`.title(for: .normal)?.lowercased())!)) {
                        `button`.isEnabled = false
                    } else {
                        `button`.isEnabled = true
                    }
                case 1:
                    if currentMultiGame.guessedLettersSecondPlayer.contains(Character((`button`.title(for: .normal)?.lowercased())!)) {
                        `button`.isEnabled = false
                    } else {
                        `button`.isEnabled = true
                    }
                default:
                    print("fatal error")
                }
            }
        default:
            print("fatal error")
        }
        
        updateState()
    }
    
}
