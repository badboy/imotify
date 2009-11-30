#!/usr/bin/env ruby
#  Copyright (c) 2009, Benedikt Müller <linopolus@xssn.at>
#  edited by Jan-Erik Rediger
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'net/imap'

OPTIONS = {
  :server => 'mail.yourserver.de',   # your mail server          String
  :ssl => { :verify_mode => OpenSSL::SSL::VERIFY_NONE },
  :authtype => 'PLAIN',

  :user => 'user',
  :password => 'password'
}

# if you have to use plain auth instead of login…
class ImapPlainAuthenticator
  def process(data)
    return "#{@user}\0#{@user}\0#{@password}"
  end
      
  def initialize(user, password)
    @user = user
    @password = password
  end
end
Net::IMAP::add_authenticator('PLAIN', ImapPlainAuthenticator)

imap = Net::IMAP.new(OPTIONS[:server], { :ssl => OPTIONS[:ssl] })
imap.authenticate(OPTIONS[:authtype], OPTIONS[:user], OPTIONS[:password])

puts imap.list("", "INBOX*").inject(0) { |count, elem|
  count + imap.status(elem.name, ['UNSEEN'])['UNSEEN']
}
imap.disconnect
