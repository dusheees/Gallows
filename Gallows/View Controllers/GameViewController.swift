//
//  GameViewController.swift
//  Gallows
//
//  Created by Андрей on 08.11.2021.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Properties
    var listOfWords: [String] = []
    var navigationTitle: String = ""
    let incorrectMovesAllowed = 7
    var totalWins: Int = 0 {
        didSet {
            newRound()
        }
    }
    var totalLosses: Int = 0 {
        didSet {
            newRound()
        }
    }
    var currentGame: Game!
    let size: CGSize!
    let factor: CGFloat!
    
    init?(coder: NSCoder, listOfWords: [String], navigationTitle: String, size: CGSize, factor: CGFloat){
        self.listOfWords = listOfWords
        self.navigationTitle = navigationTitle
        self.size = size
        self.factor = factor
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIProperties
    // game stack view
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameStackView: UIStackView!
    //result stack view
    @IBOutlet weak var resultStackView: UIStackView!
    @IBOutlet weak var finishedTextLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    // navigation
    @IBOutlet weak var navigationButton: UIBarButtonItem!
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        correctSize()
        resultStackView.isHidden = true
        navigationItem.title = navigationTitle
        navigationItem.hidesBackButton = true
        updateUI(to: view.bounds.size)
        newRound()
    }
    
    func correctSize() {
        for button in letterButtons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: factor / 20)
        }
        correctWordLabel.font = UIFont.systemFont(ofSize: factor / 12)
        scoreLabel.font = UIFont.systemFont(ofSize: factor / 16)
        
        finishedTextLabel.font = UIFont.systemFont(ofSize: factor / 16)
        resultLabel.font = UIFont.systemFont(ofSize: factor / 16)
        
        navigationButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.systemFont(ofSize: factor / 25)],
        for: [])
        
    }
    
    func enabledButtons(_ enable: Bool = true) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    func newRound() {
        guard !listOfWords.isEmpty else {
            enabledButtons(false)
            updateUI()
            gameStackView.isHidden = true
            resultLabel.text = scoreLabel.text
            resultStackView.isHidden = false
            return
        }
        let newWord = listOfWords.removeFirst()
        currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed)
        updateUI()
        enabledButtons()
    }
    
    func updateWordLabel() {
        var displayWord: [String] = []
        for letter in currentGame.guessedWord {
            displayWord.append(String(letter))
        }
        correctWordLabel.text = displayWord.joined(separator: " ")
    }
    
    func updateState() {
        if currentGame.incorrectMovesRemaining < 1 { // или == 0
            totalLosses += 1
        } else if currentGame.guessedWord == currentGame.word {
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    func updateUI() {
        let movesRemaining = currentGame.incorrectMovesRemaining
        //let imageNumber = movesRemaining < 0 ? 0 : movesRemaining < 8 ? movesRemaining : 7 // двойной тернарный оператор
        let imageNumber = (movesRemaining + 64) % 8
        let image = "Tree\(imageNumber)"
        treeImageView.image = UIImage(named: image)
        updateWordLabel()
        scoreLabel.text = ("Выигрыши: \(totalWins), проигрыши: \(totalLosses)")
    }
    
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
    @IBAction func letterButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letter = sender.title(for: .normal)!
        currentGame.playerGuest(letter: Character(letter))
        updateState()
    }
    
    
}
