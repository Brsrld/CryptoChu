public protocol ViewState: StoreState {}
public protocol StoreState : Equatable, CustomLogDescriptionConvertible {
    static var idle: Self { get }
}


public extension Equatable where Self: StoreState {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return false
    }
}

