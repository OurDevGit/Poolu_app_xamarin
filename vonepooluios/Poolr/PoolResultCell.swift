//
//  PoolUpdateCell.swift
//  Poolr
//
//  Created by James Li on 1/19/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit

protocol PoolResultCellDelegate : class {
    func PoolResultCellViewMyTicketsTapped(_ sender: PoolResultCell)
    func poolResultCellViewPlayerAndTicketsTapped(_ sender: PoolResultCell)
}

class PoolResultCell: UITableViewCell {
    weak var delegate: PoolResultCellDelegate?
    
    @IBOutlet weak var poolNameLabel: UILabel!
    @IBOutlet weak var drawDateLabel: UILabel!
    @IBOutlet weak var winningNumbersLabel: UILabel!
    @IBOutlet weak var jackpotLabel: UILabel!
    @IBOutlet weak var amoutWonLabel: UILabel!
    @IBOutlet weak var poolWinJackpotLabel: UILabel!
    @IBOutlet weak var jackpotShareLabel: UILabel!
    @IBOutlet weak var poolShareLabel: UILabel!
    @IBOutlet weak var myWinningsLabel: UILabel!
    @IBOutlet weak var viewMyTicketsLabel: UIButton!
    @IBOutlet weak var allPlayersAndTicketsLabel: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for poolResult: PoolResult) {
        selectionStyle = .none
        poolNameLabel.text = poolResult.poolName
        drawDateLabel.text = poolResult.drawDate
        winningNumbersLabel.attributedText = ViewControllerHelper().formatLotteryNumbers(numbers: poolResult.winningNumbers)
        jackpotLabel.text = poolResult.jackpot
        
        if poolResult.isNewUser {
            myWinningsLabel.isHidden = true
            amoutWonLabel.isHidden = true
            viewMyTicketsLabel.isHidden = true
            allPlayersAndTicketsLabel.isHidden = true
        } else {
            myWinningsLabel.isHidden = false
            amoutWonLabel.isHidden = false
            amoutWonLabel.text = poolResult.winningPrize
            viewMyTicketsLabel.isHidden = false
            allPlayersAndTicketsLabel.isHidden = false
        }
        
        poolWinJackpotLabel.text = "No"
        jackpotShareLabel.text = "$0"
        poolShareLabel.text = "$0"
    }
    
    @IBAction func viewMyTickets(_ sender: Any) {
        delegate?.PoolResultCellViewMyTicketsTapped(self)
    }
    
    @IBAction func viewPlayersAndTickets(_ sender: Any) {
        delegate?.poolResultCellViewPlayerAndTicketsTapped(self)
    }
}

