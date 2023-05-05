public struct StockServices {
    public static let repository: StocksRepository = DefaultStocksRepository()
    public static let user = UserRepository()
}
