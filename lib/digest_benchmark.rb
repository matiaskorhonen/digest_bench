require "zlib"
require "digest/sha1"
require "digest/sha2"
require "benchmark"

require "digest/xxhash"
require "murmurhash3"
require "cityhash"
require "tty-logger"

class Integer
  def to_filesize
    {
      'B'  => 1024,
      'KiB' => 1024 * 1024,
      'MiB' => 1024 * 1024 * 1024,
      'GiB' => 1024 * 1024 * 1024 * 1024,
      'TiB' => 1024 * 1024 * 1024 * 1024 * 1024
    }.each_pair { |e, s| return "#{(self.to_f / (s / 1024)).round(2)}#{e}" if self < s }
  end
end

module DigestBenchmark
  ITERATIONS = I = 100_000

  class << self
    def preamble
      logger.info "Ruby", version: RUBY_VERSION
      logger.info "digest-xxhash", version: Digest::XXHash::VERSION
      logger.info "MurmurHash3 version", version: MurmurHash3::VERSION
      logger.info "CityHash", version: CityHash::VERSION
    end

    def generate_random_data(bytes)
      logger.info "Generating random data", size: bytes.to_filesize
      File.read('/dev/urandom', bytes)
    end

    def run_single_benchmark(bytes)
      data = generate_random_data(bytes)

      logger.info "Running benchmarks", iterations: ITERATIONS

      Benchmark.bmbm do |bm|
        bm.report("Digest::MD5")            { I.times { Digest::MD5.hexdigest(data) } }
        bm.report("Digest::SHA1")           { I.times { Digest::SHA1.hexdigest(data) } }
        bm.report("Digest::SHA256")         { I.times { Digest::SHA256.hexdigest(data) } }
        bm.report("Digest::SHA512")         { I.times { Digest::SHA512.hexdigest(data) } }
        bm.report("Zlib.crc32")             { I.times { Zlib.crc32(data).to_s(16) } }
        bm.report("digest-xxhash (XXH32)")  { I.times { Digest::XXH32.hexdigest(data) } }
        bm.report("digest-xxhash (XXH64)")  { I.times { Digest::XXH64.hexdigest(data) } }
        bm.report("digest-xxhash (XXH3)")   { I.times { Digest::XXH3_128bits.hexdigest(data) } }
        bm.report("murmurhash3 (32)")      { I.times { MurmurHash3::V32.str_hexdigest(data) } }
        bm.report("murmurhash3 (128)")     { I.times { MurmurHash3::V128.str_hexdigest(data) } }
        bm.report("cityhash (32)")          { I.times { CityHash.hash64(data).to_s(16) } }
        bm.report("cityhash (64)")          { I.times { CityHash.hash64(data).to_s(16) } }
        bm.report("cityhash (128)")         { I.times { CityHash.hash128(data).to_s(16) } }
      end
    end

    def perform
      preamble
      results = run_single_benchmark(1* 1024 * 1024)  # 1 MiB

      logger.success "Benchmarking complete"

      results
    rescue => e
      logger.fatal e.message, error: e.class
      abort
    end

    def logger
      @logger ||= TTY::Logger.new
    end
  end
end
