# ---------------------------------------------------------------------------------------
# Name      : Automação Consulado Portugal
# Author    : edmoura
# Desc      : Script para acessar o site do Consulado de Portugal
# Date      : 2016-09-28
# Changed   : 2016-09-28
# ---------------------------------------------------------------------------------------
# Copyright (C) 2016
# ---------------------------------------------------------------------------------------


from urllib import urlencode
from urllib2 import Request, urlopen
import lxml.html

# Set destination URL here
url = 'http://www.consuladoportugalrjservicos.com/public_html/exec'

# Set POST fields here
values = {
    'modulo': 'modulo.servicos',
    'acao': 'servico902',
    'opcao': '',
    'idpedido': '376520',
    'indexboleto': '0'
}

data = urlencode(values)
headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Content-Length': str(len(data)),
    'Cookie': 'JSESSIONID=122FD45D1B35ABD18992B24680C19B37'
}

request = Request(url, data, headers)

response = urlopen(request).read()

root = lxml.html.fromstring(response)
print(response)
for elem in root.cssselect('elem.class'):
    print(elem.tag)
    print(elem.get('dtycampo'))
