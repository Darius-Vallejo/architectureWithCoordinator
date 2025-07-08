//
//  YearLRUCache.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 29/01/25.
//


class YearLRUCache {
    private let capacity: Int
    private var data: [Int: [Expense]] = [:]
    private var usageOrder: [Int] = [] // store years in an LRU list

    init(capacity: Int = 30) {
        self.capacity = capacity
    }

    func clear() {
        data.removeAll()
        usageOrder.removeAll()
    }

    func get(year: Int) -> [Expense]? {
        guard let val = data[year] else { return nil }
        // Mark as most recently used
        if let idx = usageOrder.firstIndex(of: year) {
            usageOrder.remove(at: idx)
        }
        usageOrder.append(year)
        return val
    }

    func set(year: Int, expenses: [Expense]) {
        // If already in data, remove from usage
        if data[year] != nil, let idx = usageOrder.firstIndex(of: year) {
            usageOrder.remove(at: idx)
        }
        data[year] = expenses
        usageOrder.append(year)
        // If over capacity, remove the LRU
        if usageOrder.count > capacity {
            let oldest = usageOrder.removeFirst()
            data.removeValue(forKey: oldest)
        }
    }
}
