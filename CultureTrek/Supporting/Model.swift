//
//  Model.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 7/14/24.
//

import Foundation

// MARK: Cities

struct GeonamesResponse: Decodable {
    let geonames: [City]
}

struct City: Decodable {
    let name: String
    let countryName: String
    var imageUrl: String?
}

// MARK: Photo

struct UnsplashResponse: Decodable {
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let urls: UnsplashPhotoURLs
}

struct UnsplashPhotoURLs: Decodable {
    let small: String
}

// MARK: Museum

struct FoursquareResponse: Decodable {
    let meta: Meta
    let response: Response?
}

struct Meta: Decodable {
    let code: Int
    let requestId: String
}

struct Response: Decodable {
    let venues: [Venue]?
}

struct Venue: Decodable {
    let id: String
    let name: String
}

// MARK: Artifact


// MARK: - Welcome
struct Welcome: Codable {
    let apikey: String
    let success: Bool
    let requestNumber, itemsCount, totalResults: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let completeness: Int
    let country, dataProvider: [String]
    let dcDescription: [String]?
    let dcDescriptionLangAware: DcDescriptionLangAware?
    let dcLanguage: [String]?
    let dcLanguageLangAware: DcLanguageLangAware?
    let dcTitleLangAware: DcTitleLangAware
    let edmConcept: [String]?
    let edmConceptLabel: [EdmLabel]?
    let edmConceptPrefLabelLangAware: [String: [String]]?
    let edmDatasetName: [String]
    let edmIsShownAt: [String]?
    let edmIsShownBy: [String]?
    let edmPlaceAltLabel: [EdmLabel]?
    let edmPlaceAltLabelLangAware: [String: [String]]?
    let edmPlaceLabel: [EdmLabel]?
    let edmPlaceLabelLangAware: [String: [String]]?
    let edmPlaceLatitude, edmPlaceLongitude: [String]?
    let edmPreview: [String]
    let edmTimespanLabel: [EdmLabel]?
    let edmTimespanLabelLangAware: [String: [String]]?
    let europeanaCollectionName: [String]
    let europeanaCompleteness: Int
    let guid: String
    let id: String
    let index: Int
    let language: [String]
    let link: String
    let previewNoDistribute: Bool
    let provider: [String]
    let rights: [String]
    let score: Double
    let timestamp: Int
    let timestampCreated: String
    let timestampCreatedEpoch: Int
    let timestampUpdate: String
    let timestampUpdateEpoch: Int
    let title: [String]
    let type: TypeEnum
    let ugc: [Bool]
    let dcCreator: [String]?
    let dcCreatorLangAware: DcCreatorLangAware?
    let year: [String]?

    enum CodingKeys: String, CodingKey {
        case completeness, country, dataProvider, dcDescription, dcDescriptionLangAware, dcLanguage, dcLanguageLangAware, dcTitleLangAware, edmConcept, edmConceptLabel, edmConceptPrefLabelLangAware, edmDatasetName, edmIsShownAt, edmIsShownBy, edmPlaceAltLabel, edmPlaceAltLabelLangAware, edmPlaceLabel, edmPlaceLabelLangAware, edmPlaceLatitude, edmPlaceLongitude, edmPreview, edmTimespanLabel, edmTimespanLabelLangAware, europeanaCollectionName, europeanaCompleteness, guid, id, index, language, link, previewNoDistribute, provider, rights, score, timestamp
        case timestampCreated = "timestamp_created"
        case timestampCreatedEpoch = "timestamp_created_epoch"
        case timestampUpdate = "timestamp_update"
        case timestampUpdateEpoch = "timestamp_update_epoch"
        case title, type, ugc, dcCreator, dcCreatorLangAware, year
    }
}

// MARK: - DcCreatorLangAware
struct DcCreatorLangAware: Codable {
    let ca: [String]?
    let def: [String]?
    let it: [String]?
}

// MARK: - DcDescriptionLangAware
struct DcDescriptionLangAware: Codable {
    let def, en, es, ca: [String]?
    let gl: [String]?
}

// MARK: - DcLanguageLangAware
struct DcLanguageLangAware: Codable {
    let def: [String]
}

// MARK: - DcTitleLangAware
struct DcTitleLangAware: Codable {
    let def, en, es, ca: [String]?
    let it, gl, de: [String]?
}

// MARK: - EdmLabel
struct EdmLabel: Codable {
    let def: String
}

enum TypeEnum: String, Codable {
    case image = "IMAGE"
}



// MARK: Error Enum

enum DataFetchError: Error {
    case decodeError(Error)
    case networkError(Error)
}

// MARK: Google Places API Model for Search Function

struct GooglePlacesResponse: Codable {
    let results: [GooglePlace]
}

struct GooglePlace: Codable {
    let name: String
    let formatted_address: String
}

struct Museum: Codable {
    let name: String
    let address: String
}

// MARK: Logging In User Object

struct User: Identifiable, Codable {
    var id: String
    var email: String
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, email: "")
}
