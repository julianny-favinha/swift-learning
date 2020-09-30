import UIKit

protocol Content {}

struct InfoBannerContent: Decodable, Content {
    let title: String
    let subtitle: String
}

struct ImageBannerContent: Decodable, Content {
    let url: String
}

struct Card: Decodable {
    enum Style: String, Decodable {
        case infoBanner = "INFO_BANNER"
        case imageBanner = "IMAGE_BANNER"
    }

    let type: Style
    let content: Content

    enum CodingKeys: String, CodingKey {
        case type
        case content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(Style.self, forKey: .type)

        switch type {
        case .infoBanner:
            content = try container.decode(InfoBannerContent.self, forKey: .content)
        case .imageBanner:
            content = try container.decode(ImageBannerContent.self, forKey: .content)
        }
    }
}

// TEST

let infoBannerJson = """
{
    "type": "INFO_BANNER",
    "content": {
        "title": "Foo title",
        "subtitle": "Foo subtitle"
    }
}
"""

let imageBannerJson = """
{
    "type": "IMAGE_BANNER",
    "content": {
        "url": "http://www.foo.com"
    }
}
"""

let infoCard = try! JSONDecoder().decode(Card.self, from: infoBannerJson.data(using: .utf8)!)
let imageCard = try! JSONDecoder().decode(Card.self, from: imageBannerJson.data(using: .utf8)!)
