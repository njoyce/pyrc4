from pyrc4 import RC4

key = 'foo.bar'
plain_text = 'Hello world'

e = RC4(key)
d = RC4(key)

encrypted = e.update(plain_text)

assert d.update(encrypted) == plain_text
