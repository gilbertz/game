#!/usr/bin/env ruby

require 'qiniu'

Qiniu.establish_connection! :access_key => 'gBlgwMtgrEBgCTpjfXobrI9JN9JJEgqnrgqjGr-3',
                            :secret_key => 'gVkfU39Juj8Qynu7zrh8R9VMg-pv7k_MyR3JmQkq',
                            :block_size      => 1024*1024*4,
                            :chunk_size      => 1024*256,
                            :tmpdir          => Dir.tmpdir + File::SEPARATOR + 'Qiniu',
                            :enable_debug    => true,
                            :auto_reconnect  => true,
                            :max_retry_times => 3