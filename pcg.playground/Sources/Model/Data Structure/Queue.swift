import Foundation

/**
 A generic `Queue` class whose elements are first-in, first-out.
 */
struct Queue<T> {

    private var array: [T]

    init() {
        self.array = [T]()
    }

    init(_ items: [T]) {
        self.array = [T]()
        for item in items {
            array.append(item)
        }
    }

    /// Adds an element to the tail of the queue.
    /// - Parameter item: The element to be added to the queue
    mutating func enqueue(_ item: T) {
        array.append(item)
    }

    /// Removes an element from the head of the queue and return it.
    /// - Returns: item at the head of the queue
    mutating func dequeue() -> T? {
        guard let head = array.first else {
            return nil
        }
        array.removeFirst()
        return head
    }

    /// Returns, but does not remove, the element at the head of the queue.
    /// - Returns: item at the head of the queue
    func peek() -> T? {
        return array.first
    }

    /// The number of elements currently in the queue.
    var count: Int {
        return array.count
    }

    /// Whether the queue is empty.
    var isEmpty: Bool {
        return array.isEmpty
    }

    /// Adds all items to queue.
    mutating func addItems(_ items: [T]) {
        for item in items {
            array.append(item)
        }
    }

    /// Removes all elements in the queue.
    mutating func removeAll() {
        array.removeAll()
    }

    /// Returns an array of the elements in their respective dequeue order, i.e.
    /// first element in the array is the first element to be dequeued.
    /// - Returns: array of elements in their respective dequeue order
    func toArray() -> [T] {
        return array
    }
}
