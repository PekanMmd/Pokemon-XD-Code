/// A hash that can be used to generate a message authentication code (MAC).
public
protocol MessageAuthenticationHash:RandomAccessCollection where Index == Int, Element == UInt8
{
    /// The natural block stride of this hash function.
    static
    var stride:Int { get }

    /// The output size, in bytes, of this hash function.
    static
    var count:Int { get }

    /// Computes an instance of this hash for the given message.
    init<Message>(hashing message:Message)
        where Message:Collection, Message.Element == UInt8 
}
extension MessageAuthenticationHash
{
    @inlinable public
    var endIndex:Int
    {
        self.startIndex + Self.count
    }
    @inlinable public
    var count:Int
    {
        Self.count
    }
}
extension MessageAuthenticationHash
{
    /// Computes a hash-based message authentication code (HMAC) for
    /// the given message using the given key.
    ///
    /// This initializer computes an instance of ``MessageAuthenticationKey``
    /// and uses it to generate an instance of ``Self``. If you are reusing
    /// the same `key` multiple times, it is more efficient to compute the
    /// message authentication key externally and call its
    /// ``MessageAuthenticationKey.authenticate(_:)`` method instead.
    @inlinable public
    init<Message, Key>(authenticating message:Message, key:Key)
        where   Message:Sequence, Message.Element == UInt8,
                Key:Collection, Key.Element == UInt8 
    {
        let key:MessageAuthenticationKey<Self> = .init(key)
        self = key.authenticate(message)
    }
}

extension MessageAuthenticationHash
{
    /// Derives an encryption key from a password and salt.
    /// This is a password-based key derivation function
    /// ([PBKDR2](https://en.wikipedia.org/wiki/PBKDF2)).
    @inlinable public static
    func pbkdf2<Password, Salt>(password:Password, salt:Salt, iterations:Int,
        blocks:Int = 1) -> [UInt8]
        where   Password:Collection, Password.Element == UInt8,
                Salt:Collection, Salt.Element == UInt8
    {
        let key:MessageAuthenticationKey<Self> = .init(password)
        return key.derive(salt: salt, iterations: iterations, blocks: blocks)
    }
}
