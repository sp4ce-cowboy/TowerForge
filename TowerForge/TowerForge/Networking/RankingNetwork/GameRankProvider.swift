//
//  GameRankProvider.swift
//  TowerForge
//
//  Created by Vanessa Mae on 08/04/24.
//

import Foundation
import FirebaseDatabaseInternal

class GameRankProvider {
    private let ranksRef = FirebaseDatabaseReference(.Ranks)
    func setNewRank(rank: GameRankData) {
        let userRankData = ["username": rank.username, "score": rank.score] as [String: Any]
        ranksRef.child(rank.userId).setValue(userRankData)
    }
    func getTopRanks(completion: @escaping ([GameRankData]?, Error?) -> Void) {
        ranksRef.queryOrdered(byChild: "score").queryLimited(toLast: 10).observeSingleEvent(of: .value) { snapshot in
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

            topRanks.sort { $0.score > $1.score }
            completion(topRanks, nil)
        }
    }
}
