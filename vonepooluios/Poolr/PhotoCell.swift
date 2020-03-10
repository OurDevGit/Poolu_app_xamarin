//
//  PhotoCell.swift
//  Poolr
//
//  Created by James Li on 2/5/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var ticketStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spinner.activityIndicatorViewStyle = .whiteLarge
        
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
        //self.ticketStatusLabel.isHidden = true
    }
    
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
            imageView.layer.borderWidth = 1.0
            imageView.layer.borderColor = AppConstants.borderColor.cgColor
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    func showTicketStats(ticketStatus: String) {
        ticketStatusLabel.isHidden = false
        
        if ticketStatus != " " {
            ticketStatusLabel.backgroundColor = getTicketStatusLabelColor(ticketStatus)
            ticketStatusLabel.text = "Ticket " + ticketStatus
        } else {
            ticketStatusLabel.backgroundColor = getTicketStatusLabelColor("Approved")
            ticketStatusLabel.text = "Ticket Approved"
        }
        
        imageView.addSubview(ticketStatusLabel)
    }
    
    func getTicketStatusLabelColor(_ status: String) -> UIColor {
        switch status {
        case "Pending":
            return UIColor(red: 255.0/255.0, green: 211.0/255.0, blue: 0.0/255.0, alpha: 0.9)
        case "Declined":
            return UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 0.8)
        case "Approved":
            return UIColor(red: 126.0/255.0, green: 211.0/255.0, blue: 33.0/255.0, alpha: 0.8)
        default:
            return UIColor.clear
        }
    }

}


