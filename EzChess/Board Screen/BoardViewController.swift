//
//  BoardViewController.swift
//  EzChess
//
//  Created by Aniket Gupta on 22/10/2021.
//

import UIKit

class BoardViewController: UIViewController {

    private var game = Game()

        @IBOutlet var boardView: BoardView?
        @IBOutlet var whiteToggle: UISegmentedControl?
        @IBOutlet var blackToggle: UISegmentedControl?

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = Colors.blue
//
//            UIView.animate(withDuration: 0.5, delay: 0.2) {
//                self.view.backgroundColor = UIColor(red: 255/255, green: 251/255, blue: 229/255, alpha: 1)
//            }
//
            boardView?.delegate = self
            update()
        }

        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }

        @IBAction private func togglePlayerType() {
            update()
        }

        @IBAction private func resetGame() {
            game = Game()
            UIView.animate(withDuration: 0.4, animations: {
                self.boardView?.board = self.game.board
            }, completion: { [weak self] _ in
                self?.update()
            })
        }
    }

    extension BoardViewController: BoardViewDelegate {
        func boardView(_ boardView: BoardView, didTap position: Position) {
            guard let selection = boardView.selection else {
                if game.canSelectPiece(at: position) {
                    setSelection(position)
                }
                return
            }
            guard game.canMove(from: selection, to: position) else {
                if selection == position {
                    setSelection(nil)
                } else if game.canSelectPiece(at: position) {
                    setSelection(position)
                }
                return
            }
            makeMove(Move(from: selection, to: position))
        }

        private func playerIsHuman(_ color: Color) -> Bool {
            switch color {
            case .white:
                return whiteToggle?.selectedSegmentIndex == 0
            case.black:
                return blackToggle?.selectedSegmentIndex == 0
            }
        }

        private func update() {
            let gameState = game.state
            switch gameState {
            case .checkMate, .staleMate:
                let alert = UIAlertController(
                    title: "Game Over",
                    message: gameState == .staleMate ?
                        "Stalemate: Nobody wins" :
                        "Checkmate: \(game.turn.other) wins",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Play again", style: .default) { [weak self] _ in
                    self?.resetGame()
                })
                self.present(alert, animated: true)
            case .idle, .check:
                if !playerIsHuman(game.turn) {
                    makeMove(game.nextMove(for: game.turn))
                }
            }
        }

        private func setSelection(_ position: Position?) {
            let moves = position.map(game.movesForPiece(at:)) ?? []
            UIView.animate(withDuration: 0.2, animations: {
                self.boardView?.selection = position
                self.boardView?.moves = moves
            })
        }

        private func makeMove(_ move: Move) {
            let position = move.to
            guard let boardView = boardView else {
                return
            }
            let oldGame = game
            game.move(from: move.from, to: position)
            let board1 = game.board
            let wasInCheck = game.kingIsInCheck(for: oldGame.turn)
            let wasPromoted = !wasInCheck && game.canPromotePiece(at: position)
            if wasInCheck {
                game = oldGame
            } else if wasPromoted {
                game.promotePiece(at: position, to: .queen)
            }
            let board2 = game.board
            UIView.animate(withDuration: 0.4, animations: {
                boardView.selection = nil
                boardView.board = board1
                boardView.moves = []
            }, completion: { [weak self] _ in
                guard board2 == self?.game.board else { return }
                if wasInCheck {
                    UIView.animate(withDuration: 0.2, animations: {
                        boardView.board = board2
                    })
                    return
                }
                if wasPromoted {
                    UIView.animate(withDuration: 0.4, animations: {
                        boardView.board = board2
                    }, completion: { [weak self] _ in
                        guard board2 == self?.game.board else { return }
                        self?.update()
                    })
                    return
                }
                self?.update()
            })
        }

}
