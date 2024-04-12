//
//  GameRankProvider.swift
//  TowerForge
//
//  Created by Vanessa Mae on 08/04/24.
//

import Foundation
import FirebaseDatabaseInternal

enum RankType: String, CaseIterable {
    case TotalKill
    case TotalTime
    static var allCasesAsString: [String] {
        allCases.map { $0.rawValue }
    }

    func getSortingRule() -> Sorting {
        switch self {
        case .TotalKill:
            return .decreasing
        case .TotalTime:
            return .increasing
        }
    }
}

class GameRankProvider {
    private let ranksRef: DatabaseReference
    init(type: String) {
        self.ranksRef = FirebaseDatabaseReference(.Ranks).child(type)
    }
    func setNewRank(rank: GameRankData) {
        self.getHighScore(forPlayer: rank.userId) { result, _ in
            guard let oldResult = result else {
                let userRankData = ["username": rank.username, "score": rank.score] as [String: Any]
                self.ranksRef.child(rank.userId).setValue(userRankData)
                return
            }
            if rank.score > oldResult {
                let userRankData = ["username": rank.username, "score": rank.score] as [String: Any]
                self.ranksRef.child(rank.userId).setValue(userRankData)
            }
        }

    }
    private func getHighScore(forPlayer playerId: String, completion: @escaping (Double?, Error?) -> Void) {
        ranksRef.child(playerId).observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let score = userData["score"] as? Double {
                completion(score, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    func getTopRanks(increasingOrder: Sorting, completion: @escaping ([GameRankData]?, Error?) -> Void) {
        ranksRef.queryOrdered(byChild: "score").observeSingleEvent(of: .value) { snapshot in
            var topRanks: [GameRankData] = []
            for child in snapshot.children {
                if let rankSnapshot = child as? DataSnapshot,
                   let userData = rankSnapshot.value as? [String: Any],
                   let userId = rankSnapshot.key as? String,
                   let username = userData["username"] as? String,
                   let score = userData["score"] as? Double {
                    let rankData = GameRankData(userId: userId, username: username, score: score)
                    topRanks.append(rankData)
                }
            }

            if increasingOrder == .increasing {
                topRanks.sort { $0.score < $1.score }
            } else {
                topRanks.sort { $0.score > $1.score }
            }
            completion(topRanks, nil)
        }
    }
}
