extension Base64 
{
    /// An abstraction over text input, which discards characters that are not
    /// valid base-64 digits.
    ///
    /// Iteration over an instance of this type will halt upon encountering the
    /// first [`'='`]() padding character, even if the underlying sequence contains
    /// more characters.
    @frozen public
    struct Values<ASCII> where ASCII:Sequence, ASCII.Element == UInt8
    {
        public
        var iterator:ASCII.Iterator

        @inlinable public
        init(_ ascii:ASCII)
        {
            self.iterator = ascii.makeIterator()
        }
    }
}
extension Base64.Values:Sequence, IteratorProtocol
{
    public
    typealias Iterator = Self

    @inlinable public mutating
    func next() -> UInt8?
    {
        while let digit:UInt8 = self.iterator.next(), digit != 0x3D // '='
        {
            switch digit
            {
            case 0x41 ... 0x5a: // A-Z
                return digit - 0x41
            case 0x61 ... 0x7a: // a-z
                return digit - 0x61 + 26
            case 0x30 ... 0x39: // 0-9
                return digit - 0x30 + 52
            case 0x2b: // +
                return 62
            case 0x2f: // /
                return 63
            default:
                continue
            }
        }
        return nil
    }
}
