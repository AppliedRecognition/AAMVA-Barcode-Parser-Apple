//
//  IntellicheckDocumentData.swift
//  AAMVABarcodePaser
//
//  Created by Jakub Dolejs on 20/12/2019.
//  Copyright © 2019 Applied Recognition Inc. All rights reserved.
//

import Foundation

@objc public class IntellicheckDocumentData: DocumentData, Decodable {
    
    public enum Result: String {
        case documentProcessOK = "DocumentProcessOK",
             documentUnknown = "DocumentUnknown",
             documentBadRead = "DocumentBadRead",
             documentBadDevice = "DocumentBadDevice",
             documentFinancial = "DocumentFinancial",
             document1DDocument = "Document1DDocument",
             errorBadConfiguration = "ErrorBadConfiguration",
             unexpectedError = "UnexpectedError"
    }
    
    public enum ExtendedResultCode: String {
        case b = "B", uee = "UEE", f = "F", c = "C", t = "T", u = "U", l = "L", lawP = "LawP", lawS = "LawS", lawD = "LawD", y = "Y", ivc = "IVC", inc = "INC", ik = "IK", imb = "IMB", il = "IL", it = "IT", it1 = "IT1", it2 = "IT2", it3 = "IT3", iak = "IAK", idb = "IDB", ncf = "NCF", one = "1", rcf = "RCF", eml = "EML"
    }
    
    enum DocDataCodingKeys: String, CodingKey {
        case processResult, extendedResultCode, firstName, middleName, lastName, address1, address2, city, state, postalCode, dateOfBirth, heightCentimeters, heightFeetInches, weightKilograms, weightPounds, eyeColor, hairColor, gender, socialSecurity, testCard, dLIDNumberRaw, dLIDNumberFormatted, restrictions, endorsements, driverClass, organDonor, expirationDate, issueDate, issuingJurisdictionCvt, issuingJurisdictionAbbrv
    }
    
    public let resultCode: Result
    public let extendedResultCode: ExtendedResultCode
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DocDataCodingKeys.self)
        guard let result = Result(rawValue: try container.decode(String.self, forKey: .processResult)), let xrc = ExtendedResultCode(rawValue: try container.decode(String.self, forKey: .extendedResultCode)) else {
            // TODO
            throw NSError()
        }
        self.resultCode = result
        self.extendedResultCode = xrc
        super.init()
        if let firstName = try container.decodeIfPresent(String.self, forKey: .firstName), !firstName.isEmpty {
            self.fields["firstName"] = DataField(description: "First name", originalValue: firstName, parsedValue: firstName)
        }
        if let middleName = try container.decodeIfPresent(String.self, forKey: .middleName), !middleName.isEmpty {
            self.fields["middleName"] = DataField(description: "Middle name", originalValue: middleName, parsedValue: middleName)
        }
        if let lastName = try container.decodeIfPresent(String.self, forKey: .lastName), !lastName.isEmpty {
            self.fields["lastName"] = DataField(description: "Last name", originalValue: lastName, parsedValue: lastName)
        }
        if let address1 = try container.decodeIfPresent(String.self, forKey: .address1), !address1.isEmpty {
            self.fields["address1"] = DataField(description: "Address", originalValue: address1, parsedValue: address1)
        }
        if let address2 = try container.decodeIfPresent(String.self, forKey: .address2), !address2.isEmpty {
            self.fields["address2"] = DataField(description: "Address", originalValue: address2, parsedValue: address2)
        }
        if let city = try container.decodeIfPresent(String.self, forKey: .city), !city.isEmpty {
            self.fields["city"] = DataField(description: "City", originalValue: city, parsedValue: city)
        }
        if let state = try container.decodeIfPresent(String.self, forKey: .state), !state.isEmpty {
            self.fields["state"] = DataField(description: "State/province", originalValue: state, parsedValue: state)
        }
        if let postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode), !postalCode.isEmpty {
            self.fields["postalCode"] = DataField(description: "Postal code", originalValue: postalCode, parsedValue: postalCode)
        }
        let dateParser = DateFormatter()
        dateParser.dateFormat = "MM/dd/yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        if let dateOfBirth = try container.decodeIfPresent(String.self, forKey: .dateOfBirth) {
            var dob = dateOfBirth
            if let date = dateParser.date(from: dateOfBirth) {
                dob = dateFormatter.string(from: date)
            }
            if !dob.isEmpty {
                self.fields["dateOfBirth"] = DataField(description: "Date of birth", originalValue: dateOfBirth, parsedValue: dob)
            }
        }
        if let dateOfExpiry = try container.decodeIfPresent(String.self, forKey: .expirationDate), !dateOfExpiry.isEmpty {
            var doe = dateOfExpiry
            if let date = dateParser.date(from: dateOfExpiry) {
                doe = dateFormatter.string(from: date)
            }
            if !doe.isEmpty {
                self.fields["dateOfExpiry"] = DataField(description: "Date of expiry", originalValue: dateOfExpiry, parsedValue: doe)
            }
        }
        if let dateOfIssue = try container.decodeIfPresent(String.self, forKey: .issueDate), !dateOfIssue.isEmpty {
            var doi = dateOfIssue
            if let date = dateParser.date(from: dateOfIssue) {
                doi = dateFormatter.string(from: date)
            }
            if !doi.isEmpty {
                self.fields["dateOfIssue"] = DataField(description: "Date of issue", originalValue: dateOfIssue, parsedValue: doi)
            }
        }
        let docNumberRaw = try container.decodeIfPresent(String.self, forKey: .dLIDNumberRaw)
        let docNumberFormatted = try container.decodeIfPresent(String.self, forKey: .dLIDNumberFormatted)
        if docNumberRaw != nil && !docNumberRaw!.isEmpty && docNumberFormatted != nil && !docNumberFormatted!.isEmpty {
            self.fields["documentNumber"] = DataField(description: "Document number", originalValue: docNumberRaw!, parsedValue: docNumberFormatted!)
        } else if docNumberRaw != nil && !docNumberRaw!.isEmpty {
            self.fields["documentNumber"] = DataField(description: "Document number", originalValue: docNumberRaw!, parsedValue: docNumberRaw!)
        } else if docNumberFormatted != nil && !docNumberFormatted!.isEmpty {
            self.fields["documentNumber"] = DataField(description: "Document number", originalValue: docNumberFormatted!, parsedValue: docNumberFormatted!)
        }
        let isTestCard = try container.decode(Bool.self, forKey: .testCard) ? "Yes" : "No"
        self.fields["testCard"] = DataField(description: "Test card", originalValue: isTestCard, parsedValue: isTestCard)
        if let gender = try container.decodeIfPresent(String.self, forKey: .gender), !gender.isEmpty {
            self.fields["gender"] = DataField(description: "Sex", originalValue: gender, parsedValue: gender)
        }
        if let heightCm = try container.decodeIfPresent(String.self, forKey: .heightCentimeters), !heightCm.isEmpty {
            self.fields["heightCm"] = DataField(description: "Height (cm)", originalValue: heightCm, parsedValue: heightCm)
        }
        if var heightIn = try container.decodeIfPresent(String.self, forKey: .heightFeetInches), !heightIn.isEmpty {
            heightIn = heightIn.replacingOccurrences(of: "\\", with: "")
            self.fields["heightIn"] = DataField(description: "Height (ft, in)", originalValue: heightIn, parsedValue: heightIn)
        }
        if let weightKg = try container.decodeIfPresent(String.self, forKey: .weightKilograms), !weightKg.isEmpty {
            self.fields["weightKg"] = DataField(description: "Weight (kg)", originalValue: weightKg, parsedValue: weightKg)
        }
        if let weightLb = try container.decodeIfPresent(String.self, forKey: .weightPounds), !weightLb.isEmpty {
            self.fields["weightLb"] = DataField(description: "Weight (lb)", originalValue: weightLb, parsedValue: weightLb)
        }
        if let eyeColour = try container.decodeIfPresent(String.self, forKey: .eyeColor), !eyeColour.isEmpty {
            self.fields["eyeColour"] = DataField(description: "Eye colour", originalValue: eyeColour, parsedValue: eyeColour)
        }
        if let hairColour = try container.decodeIfPresent(String.self, forKey: .hairColor), !hairColour.isEmpty {
            self.fields["hairColour"] = DataField(description: "Hair colour", originalValue: hairColour, parsedValue: hairColour)
        }
        if let socialSecurity = try container.decodeIfPresent(String.self, forKey: .socialSecurity), !socialSecurity.isEmpty {
            self.fields["socialSecurity"] = DataField(description: "Social security number", originalValue: socialSecurity, parsedValue: socialSecurity)
        }
        if let restrictions = try container.decodeIfPresent(String.self, forKey: .restrictions), !restrictions.isEmpty {
            self.fields["restrictions"] = DataField(description: "Restrictions", originalValue: restrictions, parsedValue: restrictions)
        }
        if let endorsements = try container.decodeIfPresent(String.self, forKey: .endorsements), !endorsements.isEmpty {
            self.fields["endorsements"] = DataField(description: "Endorsements", originalValue: endorsements, parsedValue: endorsements)
        }
        if let driverClass = try container.decodeIfPresent(String.self, forKey: .driverClass), !driverClass.isEmpty {
            self.fields["driverClass"] = DataField(description: "Driver class", originalValue: driverClass, parsedValue: driverClass)
        }
        if let organDonor = try container.decodeIfPresent(String.self, forKey: .organDonor), !organDonor.isEmpty {
            self.fields["organDonor"] = DataField(description: "Organ donor", originalValue: organDonor, parsedValue: organDonor)
        }
        let issuingJurisdictionCvt = try container.decodeIfPresent(String.self, forKey: .issuingJurisdictionCvt)
        let issuingJurisdictionAbbrvt = try container.decodeIfPresent(String.self, forKey: .issuingJurisdictionAbbrv)
        if issuingJurisdictionAbbrvt != nil && issuingJurisdictionCvt != nil && !issuingJurisdictionAbbrvt!.isEmpty && !issuingJurisdictionCvt!.isEmpty {
            self.fields["issuingJurisdiction"] = DataField(description: "Issuing jurisdiction", originalValue: issuingJurisdictionAbbrvt!, parsedValue: issuingJurisdictionCvt!)
        } else if issuingJurisdictionAbbrvt != nil && !issuingJurisdictionAbbrvt!.isEmpty {
            self.fields["issuingJurisdiction"] = DataField(description: "Issuing jurisdiction", originalValue: issuingJurisdictionAbbrvt!, parsedValue: issuingJurisdictionAbbrvt!)
        } else if issuingJurisdictionCvt != nil && !issuingJurisdictionCvt!.isEmpty {
            self.fields["issuingJurisdiction"] = DataField(description: "Issuing jurisdiction", originalValue: issuingJurisdictionCvt!, parsedValue: issuingJurisdictionCvt!)
        }
    }
    
    open override var firstName: String? {
        self["firstName"]
    }
    
    public override var lastName: String? {
        self["lastName"]
    }
    
    public override var address: String? {
        var address: [String] = []
        if let address1 = self["address1"], !address1.isEmpty {
            address.append(address1)
        }
        if let address2 = self["address2"], !address2.isEmpty {
            address.append(address2)
        }
        if let city = self["city"], !city.isEmpty {
            address.append(city)
        }
        if let state = self["state"], !state.isEmpty {
            address.append(state)
        }
        if let postalCode = self["postalCode"], !postalCode.isEmpty {
            address.append(postalCode)
        }
        if address.isEmpty {
            return nil
        }
        return address.joined(separator: "\n")
    }
    
    public override var dateOfBirth: String? {
        self["dateOfBirth"]
    }
    
    public override var dateOfExpiry: String? {
        self["dateOfExpiry"]
    }
    
    public override var dateOfIssue: String? {
        self["dateOfIssue"]
    }
    
    public override var documentNumber: String? {
        self["documentNumber"]
    }
    
    public override var sex: String? {
        self["gender"]
    }
}
