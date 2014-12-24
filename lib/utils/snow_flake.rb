# -*- encoding : utf-8 -*-
=begin
Pure ruby independent ID generator like the twitter's SnowFlake
@see https://github.com/twitter/snowflake
@example Genenate ID
 generator_id = 1
 i = SnowFlake.new(generator_id)
 i.generate
 => 522167874144443932
@example Parse for the Flaked ID
 SnowFlake.parse(522167874144443932)
 => {:sequence=>3612, :generator_id=>1, :ts_w_millis=>124494522606}
@example Get time in the Flaked ID
 SnowFlake.parse(522167874144443932)
 => 2014-10-15 08:31:37 +0900

@example Max value
  puts SnowFlake.parse((1<<63) - 1)
  puts SnowFlake.time((1<<63) - 1)
=end

class SnowFlake
  attr_reader :seq

  # Offset epoch value of the timestamp computation caluculation
  # Start at 2014-12-24 01:57:26 +0000
  OFFSET_EPOCH_TS_W_MILLIS = 1419386246911
  
  # structure
  TS_WIDTH = 41
  GEN_ID_WIDTH = 10
  SEQ_WIDTH = 12

  # @param [Integer] generator_id e.g.) 0 ~ 1023
  def initialize(generator_id, init_seq = 0)
    @last_ts = now_w_millis
    @generator_id = generator_id
    @seq = init_seq
    
    flake @last_ts, @generator_id, @seq # run once for parameter check
  end

  # Generate to the Flake ID
  # @return [Integer] e.g.) 522167874144443932
  # @raise [InvalidSystemClockError] If the system clock has drifted in the past then is a possibility of generate duplicate ID.
  def generate
    ts = now_w_millis
    raise InvalidSystemClockError, "Last timestamp was bigger than now" if ts < @last_ts
    @last_ts = ts
    @seq = (@seq + 1) % (1 << SEQ_WIDTH) # prevention of overflow
    
    flake ts, @generator_id, @seq
  end

  # Parse for the Flaked ID
  # @param [Integer] flake_id Flaked ID
  # @return [Hash] e.g.) { :sequence=>0, :generator_id=>36, :ts_w_millis=>124453219396 }
  # @example
  #  SnowFlake.parse(521994635925667840)
  def self.parse(flake_id)
    r = {}
    r[:ts_w_millis] = flake_id >> (SEQ_WIDTH + GEN_ID_WIDTH)
    r[:generator_id] = (flake_id >> SEQ_WIDTH).to_s(2)[-GEN_ID_WIDTH, GEN_ID_WIDTH].to_i(2)
    r[:sequence] = flake_id.to_s(2)[-SEQ_WIDTH, SEQ_WIDTH].to_i(2)
    r
  end

  # Get time in the Flaked ID
  # @param [Integer] flake_id Flaked ID
  # @return [Time] e.g.) 2014-10-14 21:03:14 +0900
  # @example
  #  SnowFlake.time(521994635925667840)
  def self.time(flake_id)
    ts = (self.parse(flake_id)[:ts_w_millis] + OFFSET_EPOCH_TS_W_MILLIS) / 1000.0
    Time.at(ts)
  end

  private
  def flake(ts_w_millis, generator_id, sequence)
    raise OverflowError, "Timestamp limit is 2084-08-29 17:45:02 +0000"  if ts_w_millis > (1 << TS_WIDTH) - 1
    t = (ts_w_millis - OFFSET_EPOCH_TS_W_MILLIS) << (GEN_ID_WIDTH + SEQ_WIDTH)
    raise OverflowError, "Generator ID limit is between 0 and 1023" if generator_id > (1 << GEN_ID_WIDTH) - 1
    m = generator_id << SEQ_WIDTH
    s = sequence % (1 << SEQ_WIDTH)
    t + m + s
  end

  def now_w_millis
    Time.now.strftime("%s%L").to_i
  end
end

class SnowFlake::OverflowError < StandardError ; end
class SnowFlake::InvalidSystemClockError < StandardError ; end
