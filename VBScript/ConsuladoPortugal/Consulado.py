# ---------------------------------------------------------------------------------------
# Name      : Automacao Consulado Portugal
# Author    : edmoura
# Desc      : Script para acessar o site do Consulado de Portugal
# Date      : 2016-09-28
# Changed   : 2016-11-21
# ---------------------------------------------------------------------------------------
# Copyright (C) 2016
# ---------------------------------------------------------------------------------------

import requests
import os

print('----BEGIN----')

USER_CPF = 'USER_CPF' # Substituir por dados reais
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

# Tabela de equivaldncia do campo rbtnhora
# rbtnhora	1		2		3		4		5		6		7		8		9		10		11		12		13		14		15		16		17		18		19		20		21		22		23		24		25		26		27		28		29		30		31		32		33
# Horario	08:00	08:15	08:30	08:45	09:00	09:15	09:30	09:45	10:00	10:15	10:30	10:45	11:00	11:15	11:30	11:45	12:00	12:15	12:30	12:45	13:00	13:15	13:30	13:45	14:00	14:15	14:30	14:45	15:00	15:15	15:30	15:45	16:00
	
# values = {
#     'modulo': 'modulo.servicos',
#     'acao': 'servico914',
#     'agendardia': '30/11/2016',
#     'idpedido': '376520',
#     'rbtnhora': '22'
# }

values = {
    'modulo': 'modulo.servicos',
    'acao': 'servico900'
}

r = s.post(url, data=values, stream=True)
r.raw
with open('response.html', 'wb') as fd:
    print('Output file: ' + os.path.join(os.getcwd(), fd.name))
    for chunk in r.iter_content():
        fd.write(chunk)
        break
    fd.close()
print('----END----')
