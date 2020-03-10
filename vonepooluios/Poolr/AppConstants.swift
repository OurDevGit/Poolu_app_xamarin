//
//  PlrConstants.swift
//  Poolr
//
//  Created by James Li on 7/29/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

struct AppConstants {
    static let pooluBaseURLString = "https://www.pooluapp.com/api/"
    static let accountURLString = AppConstants.pooluBaseURLString + "account/"
    static let mobileSubmitURLString = AppConstants.accountURLString + "mobile"
    static let mobileVerifyURLString = AppConstants.accountURLString + "verify"
    static let loginURLString = AppConstants.accountURLString + "login"
    static let passwordURLString = AppConstants.accountURLString + "password"
    
    static let profilePhotoURLString = AppConstants.pooluBaseURLString + "photo/profile"
    static let ticketPhotoURLString = AppConstants.pooluBaseURLString + "photo/ticket"
    
    static let poolDataURLString = AppConstants.pooluBaseURLString + "pools/"
    static let poolResultsURLString = AppConstants.poolDataURLString + "results"
    static let poolerPhotoDataURLString = AppConstants.poolDataURLString + "photos"
    static let poolerTicketPhotoDataURLString = AppConstants.poolDataURLString + "tickets"
    
    static let poolerPhotoBaseURLString = "https://poolrstorage.blob.core.windows.net/users/"
    static let poolerTicketPhotoBaseURLString = "https://poolrstorage.blob.core.windows.net/tickets/"
    
    static let ticketsURLString = AppConstants.pooluBaseURLString + "tickets"
    static let ticketLotteryNumbersURLString = AppConstants.ticketsURLString + "/numbers"

    static let poolLink = "https://www.pooluapp.com/AppStore.html"
    
    static let pooluHomeUrlString = "https://www.pooluapp.com"
    static let privacyPolicyUrlString = AppConstants.pooluHomeUrlString + "/PrivacyPolicy"
    static let termsAndConditionsUrlString = AppConstants.pooluHomeUrlString + "/TermsAndConditions"
    static let plainTalkUrlString = AppConstants.pooluHomeUrlString + "/PlainTalk"
    static let rulesToPoolUrlString = AppConstants.pooluHomeUrlString + "/RulesToPool"
    
    static let requestTimeoutInterval = 10.0 * 1000
    
    static let userPhotoUploadWidth = 64.0
    static let userPhotoUploadHight = 64.0
    static let userPhotoCompressionQuality = CGFloat(0.8)
    
    static let lotteryPhotoUploadWidth = 320.0
    static let lotteryPhotoUploadHeight = 360.0
    //static let lotteryCompressionQuality = CGFloat(1.0)

    static let lightGreen = UIColor(red: 126.0/255.0, green: 211.0/255.0, blue: 33.0/255.0, alpha: 1.0)
    static let lineColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    static let borderColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    static let poolInfoCellColor = UIColor(red: 126.0/255.0, green: 211.0/255.0, blue: 33.0/255.0, alpha: 0.2)
    
    static let tableViewCellHeight = CGFloat(73.0)
    
    static let textFieldBottomBoarderLoginViewColor = UIColor.white.cgColor
    static let textFieldBottomBoarderNormalColor = UIColor.darkGray.cgColor
    static let textFieldBottomBoarderErrorColor = UIColor.red.cgColor
    
    static let pooluSupportEmail = "support@pooluapp.com"
    
    static let emailValidationErrorMessage = "Invaild email address"
    static let emailAlreadyExistMessage = "Email already exist, please use a different one."
    static let emailDoesNotExistMessage = "Your email is incorrect"
    static let passwordIncorrectMessage = "Your password is incorrect"
    static let passwordValidationErrorMessage = "Passwords must be 8 character long"
    static let reEnterPasswordValidationErrorMessage = "Password do not match"
    static let firstNameValidationErrorMessage = "Invalid first name"
    static let lastNameValidationErrorMessage = "invalid last name"
    static let zipCodeValidationErrorMessage = "Invalid zip code"
    static let phoneNumberValidationErrorMessage = "Invalid phone number"
    static let verificationCodeValidationErrorMessage = "Invalid verification code"
    
    static let smsSendSuccessMessage = "An SMS message containing a verfication code has been sent to your mobile device. Please enter the verifcation code to continue."
    
    static let joinPoolrComfirmMessage = "By pressing the Join Poolr button below, you confirm that you are at least 18 years of age and agree to Poolr’s Terms and Conditions and Privacy Policy."
    
    static let lotteryTicketUploadSuccessMessage = "Your ticket is currently pending, it'll take up to 5 minutes to approve. In the meantime view all players and tickets in your pool, share on social media, and add more tickets to increase your share of the winnings! Never throw a ticket away!"
    
    static let leavePoolMessage = "Leaving the pool means you will be losing all your chances of winning in this pool. Your chances of winning will be greatly reduced by leaving.\nAre you sure you want to leave this pool?"
    
    static let sharePoolMessage = "Spread the word about pools! Copy this link and paste it into your social media sites and text directly to your friends!"
    
    static let photoTakenInstruction = "Put ticket on a dark background in good lighting. Make sure all 4 corners are visible. The camera will extract the information automatically. If it doesn't work adjust the ticket. DO NOT LOSE YOUR TICKET!"
    
    static let generalErrorMessage = "There is error occured, please come back later."
}
