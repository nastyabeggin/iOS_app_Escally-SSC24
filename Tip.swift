import SwiftUI
import TipKit

struct AddRouteTip: Tip {
    var title: Text {
        Text("Add new route")
    }

    var message: Text? {
        Text("Tap here to add new route")
    }

    var image: Image? {
        Image(systemName: "mountain.2")
    }
}

struct AddImageTip: Tip {
    var title: Text {
        Text("Add image")
    }

    var message: Text? {
        Text("Tap here to add image to the route")
    }

    var image: Image? {
        Image(systemName: "photo")
    }
}

struct ViewDetailedRouteInfoTip: Tip {
    var title: Text {
        Text("View and edit routes")
    }

    var message: Text? {
        Text("Tap to view and edit added route")
    }
}

struct EditImageTip: Tip {
    var title: Text {
        Text("Edit image")
    }

    var message: Text? {
        Text("Tap here to edit added image and add marks")
    }

    var image: Image? {
        Image(systemName: "pencil")
    }
}

struct ViewMarkedRouteTip: Tip {
    var title: Text {
        Text("View marked route")
    }

    var message: Text? {
        Text("Tap here to view and add marks on your route")
    }
}
