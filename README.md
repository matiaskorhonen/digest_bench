# Hashing benchmarks for Ruby

Benchmarks of various hash algorithms.

## Algorithms

* Ruby stdlib:
  * [MD5][]
  * [SHA1][]/[SHA256][SHA2]/[SHA512][SHA2]
  * [Zlib CRC32][]
* Gems:
  * [digest-xxhash][] (XXH32/XXH64/XXH3)
  * [murmurhash3][] (32/128)
  * [cityhash][] (32/54/128)

These algorithms are not all equivalent so don't just blindly pick the fastest one!

[MD5]: https://docs.ruby-lang.org/en/3.3/Digest/MD5.html
[SHA1]: https://docs.ruby-lang.org/en/3.3/Digest/SHA1.html
[SHA2]: https://docs.ruby-lang.org/en/3.3/Digest/SHA256.html
[SHA1]: https://docs.ruby-lang.org/en/3.3/Digest/SHA1.html
[Zlib CRC32]: https://docs.ruby-lang.org/en/3.3/Zlib.html#method-c-crc32
[digest-xxhash]: https://rubygems.org/gems/digest-xxhash
[murmurhash3]: https://rubygems.org/gems/murmurhash3
[cityhash]: https://rubygems.org/gems/cityhash
