# typed: strict

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `net-http-persistent` gem.
# Please instead update this file by running `bin/tapioca gem net-http-persistent`.

class Net::HTTP::Persistent
  def initialize(name: T.unsafe(nil), proxy: T.unsafe(nil), pool_size: T.unsafe(nil)); end

  def ca_file; end
  def ca_file=(file); end
  def ca_path; end
  def ca_path=(path); end
  def cert; end
  def cert=(certificate); end
  def cert_store; end
  def cert_store=(store); end
  def certificate; end
  def certificate=(certificate); end
  def ciphers; end
  def ciphers=(ciphers); end
  def connection_for(uri); end
  def debug_output; end
  def debug_output=(_arg0); end
  def escape(str); end
  def expired?(connection); end
  def finish(connection); end
  def generation; end
  def headers; end
  def http_version(uri); end
  def http_versions; end
  def idle_timeout; end
  def idle_timeout=(_arg0); end
  def keep_alive; end
  def keep_alive=(_arg0); end
  def key; end
  def key=(key); end
  def max_requests; end
  def max_requests=(_arg0); end
  def max_retries; end
  def max_retries=(retries); end
  def max_version; end
  def max_version=(max_version); end
  def min_version; end
  def min_version=(min_version); end
  def name; end
  def no_proxy; end
  def normalize_uri(uri); end
  def open_timeout; end
  def open_timeout=(_arg0); end
  def override_headers; end
  def pipeline(uri, requests, &block); end
  def pool; end
  def private_key; end
  def private_key=(key); end
  def proxy=(proxy); end
  def proxy_bypass?(host, port); end
  def proxy_from_env; end
  def proxy_uri; end
  def read_timeout; end
  def read_timeout=(_arg0); end
  def reconnect; end
  def reconnect_ssl; end
  def request(uri, req = T.unsafe(nil), &block); end
  def request_setup(req_or_uri); end
  def reset(connection); end
  def reuse_ssl_sessions; end
  def reuse_ssl_sessions=(_arg0); end
  def shutdown; end
  def socket_options; end
  def ssl(connection); end
  def ssl_generation; end
  def ssl_timeout; end
  def ssl_timeout=(ssl_timeout); end
  def ssl_version; end
  def ssl_version=(ssl_version); end
  def start(http); end
  def timeout_key; end
  def unescape(str); end
  def verify_callback; end
  def verify_callback=(callback); end
  def verify_depth; end
  def verify_depth=(verify_depth); end
  def verify_mode; end
  def verify_mode=(verify_mode); end
  def write_timeout; end
  def write_timeout=(_arg0); end

  class << self
    def detect_idle_timeout(uri, max = T.unsafe(nil)); end
  end
end

class Net::HTTP::Persistent::Connection
  def initialize(http_class, http_args, ssl_generation); end

  def finish; end
  def http; end
  def http=(_arg0); end
  def last_use; end
  def last_use=(_arg0); end
  def requests; end
  def requests=(_arg0); end
  def reset; end
  def ressl(ssl_generation); end
  def ssl_generation; end
  def ssl_generation=(_arg0); end
end

Net::HTTP::Persistent::DEFAULT_POOL_SIZE = T.let(T.unsafe(nil), Integer)
Net::HTTP::Persistent::EPOCH = T.let(T.unsafe(nil), Time)
class Net::HTTP::Persistent::Error < ::StandardError; end

class Net::HTTP::Persistent::Pool < ::ConnectionPool
  def initialize(options = T.unsafe(nil), &block); end

  def available; end
  def checkin(net_http_args); end
  def checkout(net_http_args); end
  def key; end
  def shutdown; end
end

class Net::HTTP::Persistent::TimedStackMulti < ::ConnectionPool::TimedStack
  def initialize(size = T.unsafe(nil), &block); end

  def empty?; end
  def length; end

  private

  def connection_stored?(options = T.unsafe(nil)); end
  def fetch_connection(options = T.unsafe(nil)); end
  def lru_update(connection_args); end
  def shutdown_connections; end
  def store_connection(obj, options = T.unsafe(nil)); end
  def try_create(options = T.unsafe(nil)); end

  class << self
    def hash_of_arrays; end
  end
end

Net::HTTP::Persistent::VERSION = T.let(T.unsafe(nil), String)
