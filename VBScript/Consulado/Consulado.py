#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# ---------------------------------------------------------------------------------------
# Name      : Acessar Consulado
# Author    : eduardomourar
# Desc      : Script para acessar o site do Consulado
# Date      : 2016-09-28
# Changed   : 2016-12-31
# ---------------------------------------------------------------------------------------
# Copyright (C) 2016
# ---------------------------------------------------------------------------------------

import requests
import logging
import os

try:
    import http.client as http_client
except ImportError:
    # Python 2
    import httplib as http_client

print('----BEGIN----')

http_client.HTTPConnection.debuglevel = 1

logging.basicConfig()
logging.getLogger().setLevel(logging.DEBUG)
requests_log = logging.getLogger("requests.packages.urllib3")
requests_log.setLevel(logging.DEBUG)
requests_log.propagate = True

USER_CPF = 'USER_CPF' # Substituir por dados reais sem necessidade 
USER_NAME = 'USER_NAME'
USER_PASS = 'USER_PASS'

# URL de destino
url = 'http://www.consuladoportugalrjservicos.com/public_html/exec'

# Os campos enviados via POST
values = {
    'modulo': 'modulo.login',
    'acao': 'login001',
    'txtcpf': USER_CPF,
    'txtusuario': USER_NAME,
    'txtsenha': USER_PASS
}

s = requests.Session()
r = s.post(url, data=values)

# Tabela de equivalecia do campo rbtnhora
# rbtnhora  Manha    rbtnhora  Horario Tarde
# 1         08:00    17        12:00
# 2         08:15    18        12:15
# 3         08:30    19        12:30
# 4         08:45    20        12:45
# 5         09:00    21        13:00
# 6         09:15    22        13:15
# 7         09:30    23        13:30
# 8         09:45    24        13:45
# 9         10:00    25        14:00
# 10        10:15    26        14:15
# 11        10:30    27        14:30
# 12        10:45    28        14:45
# 13        11:00    29        15:00
# 14        11:15    30        15:15
# 15        11:30    31        15:30
# 16        11:45    32        15:45
#                    33        16:00

# Passaporte Normal (com entrega de Cartão de Cidadão)
# values = {
#     'modulo': 'modulo.servicos',
#     'acao': 'servico1902',
#     'idservico': '21',
#     'idsrv': '30',
#     'agendardia': '30/11/2016',
#     'rbtnhora': '22'
# }

values = {
    'modulo': 'modulo.servicos',
    'acao': 'servico900'
}

r = s.post(url, data=values, stream=True)
if r.status_code == 200:
    with open('response.html', 'wb') as fd:
        print('Output HTTP response to file: ' + os.path.join(os.getcwd(), fd.name))
        fd.write(r.content)
        fd.close()
print('----END----')
