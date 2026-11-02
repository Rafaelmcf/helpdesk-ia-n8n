#!/bin/bash
# Teste de escala: 200 chamados de 3 empresas fictícias (ACME, BETA, VIDA).
# Não manda e-mail (IDs começam com "carga": o workflow pula o Gmail).
# Uso: bash carga_200.sh [primeiro] [último] [pausa_em_segundos]
#   ex.: bash carga_200.sh 1 100 5   e no outro dia   bash carga_200.sh 101 200 5
# O workflow precisa estar ATIVO no n8n.
INI=${1:-1}; FIM=${2:-200}; PAUSA=${3:-5}
URL="http://localhost:5678/webhook/helpdesk-tally"
n=0
while IFS='|' read -r id emp nome email tipo impacto urg desc; do
  n=$((n+1))
  [ "$n" -lt "$INI" ] && continue
  [ "$n" -gt "$FIM" ] && break
  json=$(printf '{"eventType":"FORM_RESPONSE","data":{"responseId":"%s","fields":[{"label":"empresa","value":"%s"},{"label":"Nome completo","value":"%s"},{"label":"E-mail","value":"%s"},{"label":"Telefone (WhatsApp)","value":"+5511900000000"},{"label":"Tipo do problema","value":"%s"},{"label":"Quantas pessoas são afetadas?","value":"%s"},{"label":"Urgência","value":"%s"},{"label":"Descreva o problema","value":"%s"}]}}' "$id" "$emp" "$nome" "$email" "$tipo" "$impacto" "$urg" "$desc")
  curl -s -o /dev/null -w "$id ($emp): HTTP %{http_code}\n" -X POST "$URL" -H "Content-Type: application/json" -d "$json"
  sleep "$PAUSA"
done <<'EOF'
carga001|BETA|Lucas Martins|lucas.martins@betacontabil.example|Internet ou rede|Algumas pessoas|Alta: não consigo trabalhar|O Wi-Fi da sala 3 conecta mas não navega, 5 pessoas paradas
carga002|VIDA|Patrícia Ramos|patricia.ramos@clinicavida.example|Outro|Só eu|Baixa: posso esperar|Meu mouse está falhando o clique, preciso de um novo
carga003|ACME|Diego Rocha|diego.rocha@acme-logistica.example|Computador ou notebook|Setor ou empresa inteira|Baixa: posso esperar|Queremos trocar os monitores do setor no próximo trimestre
carga004|BETA|Olivia Freitas|olivia.freitas@betacontabil.example|Impressora|Algumas pessoas|Baixa: posso esperar|A impressora do segundo andar está saindo com folhas em branco
carga005|VIDA|Eduardo Farias|eduardo.farias@clinicavida.example|E-mail ou Office|Setor ou empresa inteira|Média: atrapalha, mas consigo trabalhar|Ninguém do comercial recebe e-mails de fora desde o almoço
carga006|ACME|Gabriela Torres|gabriela.torres@acme-logistica.example|E-mail ou Office|Algumas pessoas|Alta: não consigo trabalhar|Várias pessoas receberam e-mail falso do diretor pedindo uma transferência urgente
carga007|BETA|Sérgio Barros|sergio.barros@betacontabil.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Esqueci minha senha depois das férias e não consigo entrar em nada
carga008|VIDA|Larissa Cardoso|larissa.cardoso@clinicavida.example|Internet ou rede|Só eu|Média: atrapalha, mas consigo trabalhar|O Wi-Fi do meu notebook conecta mas não abre nenhum site
carga009|ACME|João Pereira|joao.pereira@acme-logistica.example|Acesso ou senha|Algumas pessoas|Média: atrapalha, mas consigo trabalhar|Eu e mais duas pessoas do RH não abrimos a pasta compartilhada da folha
carga010|BETA|Juliana Reis|juliana.reis@betacontabil.example|Sistema da empresa|Só eu|Baixa: posso esperar|Gostaria de acesso ao Power BI para ver os relatórios de vendas
carga011|VIDA|Bruno Lima|bruno.lima@clinicavida.example|Impressora|Só eu|Baixa: posso esperar|Meu notebook não encontra a impressora nova da sala de reunião
carga012|ACME|Mariana Dias|mariana.dias@acme-logistica.example|Computador ou notebook|Só eu|Média: atrapalha, mas consigo trabalhar|Notebook muito lento, demora 10 minutos para abrir o Excel
carga013|BETA|Rodrigo Pinto|rodrigo.pinto@betacontabil.example|Sistema da empresa|Setor ou empresa inteira|Alta: não consigo trabalhar|O sistema principal caiu para todos, dá erro 500 ao salvar
carga014|VIDA|Elisa Prado|elisa.prado@clinicavida.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Minha conta foi bloqueada depois de errar a senha 3 vezes
carga015|ACME|Paulo Henrique|paulo.henrique@acme-logistica.example|Internet ou rede|Só eu|Alta: não consigo trabalhar|Estou em home office e a VPN não conecta, dá tempo esgotado
carga016|BETA|Fernanda Melo|fernanda.melo@betacontabil.example|Outro|Só eu|Baixa: posso esperar|Preciso instalar o Zoom no meu computador
carga017|VIDA|Henrique Alves|henrique.alves@clinicavida.example|Impressora|Setor ou empresa inteira|Alta: não consigo trabalhar|A impressora de etiquetas da expedição parou e não sai nenhum pedido
carga018|ACME|Tatiane Moura|tatiane.moura@acme-logistica.example|Internet ou rede|Setor ou empresa inteira|Alta: não consigo trabalhar|O setor inteiro está sem internet desde as 9h
carga019|BETA|Thiago Moreira|thiago.moreira@betacontabil.example|Computador ou notebook|Só eu|Alta: não consigo trabalhar|Derrubei café no notebook e ele não liga mais
carga020|VIDA|Henrique Alves|henrique.alves@clinicavida.example|Impressora|Setor ou empresa inteira|Alta: não consigo trabalhar|Ainda sem solução: a impressora de etiquetas da expedição parou e não sai nenhum pedido
carga021|ACME|Marcos Teixeira|marcos.teixeira@acme-logistica.example|Acesso ou senha|Só eu|Média: atrapalha, mas consigo trabalhar|Troquei de celular e o autenticador não tem mais os códigos
carga022|BETA|Carla Mendes|carla.mendes@betacontabil.example|E-mail ou Office|Só eu|Média: atrapalha, mas consigo trabalhar|Meu Outlook parou de receber e-mails desde ontem
carga023|VIDA|Nelson Ribeiro|nelson.ribeiro@clinicavida.example|E-mail ou Office|Só eu|Baixa: posso esperar|Recebi um e-mail pedindo para confirmar minha senha num link estranho e cliquei
carga024|ACME|Camila Duarte|camila.duarte@acme-logistica.example|Acesso ou senha|Só eu|Baixa: posso esperar|Minha senha expira amanhã e eu queria trocar antes
carga025|BETA|Felipe Nunes|felipe.nunes@betacontabil.example|Internet ou rede|Algumas pessoas|Alta: não consigo trabalhar|O Wi-Fi da sala 3 conecta mas não navega, 5 pessoas paradas
carga026|VIDA|Renata Gomes|renata.gomes@clinicavida.example|Outro|Só eu|Baixa: posso esperar|Meu mouse está falhando o clique, preciso de um novo
carga027|ACME|Gustavo Araújo|gustavo.araujo@acme-logistica.example|Computador ou notebook|Setor ou empresa inteira|Baixa: posso esperar|Queremos trocar os monitores do setor no próximo trimestre
carga028|BETA|Isabela Costa|isabela.costa@betacontabil.example|Impressora|Algumas pessoas|Baixa: posso esperar|A impressora do segundo andar está saindo com folhas em branco
carga029|VIDA|Vitor Campos|vitor.campos@clinicavida.example|E-mail ou Office|Setor ou empresa inteira|Média: atrapalha, mas consigo trabalhar|Ninguém do comercial recebe e-mails de fora desde o almoço
carga030|ACME|Ana Souza|ana.souza@acme-logistica.example|E-mail ou Office|Algumas pessoas|Alta: não consigo trabalhar|Várias pessoas receberam e-mail falso do diretor pedindo uma transferência urgente
carga031|BETA|Lucas Martins|lucas.martins@betacontabil.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Esqueci minha senha depois das férias e não consigo entrar em nada
carga032|VIDA|Patrícia Ramos|patricia.ramos@clinicavida.example|Internet ou rede|Só eu|Média: atrapalha, mas consigo trabalhar|O Wi-Fi do meu notebook conecta mas não abre nenhum site
carga033|ACME|Diego Rocha|diego.rocha@acme-logistica.example|Acesso ou senha|Algumas pessoas|Média: atrapalha, mas consigo trabalhar|Eu e mais duas pessoas do RH não abrimos a pasta compartilhada da folha
carga034|BETA|Olivia Freitas|olivia.freitas@betacontabil.example|Sistema da empresa|Só eu|Baixa: posso esperar|Gostaria de acesso ao Power BI para ver os relatórios de vendas
carga035|VIDA|Eduardo Farias|eduardo.farias@clinicavida.example|Impressora|Só eu|Baixa: posso esperar|Meu notebook não encontra a impressora nova da sala de reunião
carga036|ACME|Gabriela Torres|gabriela.torres@acme-logistica.example|Computador ou notebook|Só eu|Média: atrapalha, mas consigo trabalhar|Notebook muito lento, demora 10 minutos para abrir o Excel
carga037|BETA|Sérgio Barros|sergio.barros@betacontabil.example|Sistema da empresa|Setor ou empresa inteira|Alta: não consigo trabalhar|O sistema principal caiu para todos, dá erro 500 ao salvar
carga038|VIDA|Larissa Cardoso|larissa.cardoso@clinicavida.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Minha conta foi bloqueada depois de errar a senha 3 vezes
carga039|ACME|João Pereira|joao.pereira@acme-logistica.example|Internet ou rede|Só eu|Alta: não consigo trabalhar|Estou em home office e a VPN não conecta, dá tempo esgotado
carga040|BETA|Sérgio Barros|sergio.barros@betacontabil.example|Sistema da empresa|Setor ou empresa inteira|Alta: não consigo trabalhar|Ainda sem solução: o sistema principal caiu para todos, dá erro 500 ao salvar
carga041|VIDA|Bruno Lima|bruno.lima@clinicavida.example|Impressora|Setor ou empresa inteira|Alta: não consigo trabalhar|A impressora de etiquetas da expedição parou e não sai nenhum pedido
carga042|ACME|Mariana Dias|mariana.dias@acme-logistica.example|Internet ou rede|Setor ou empresa inteira|Alta: não consigo trabalhar|O setor inteiro está sem internet desde as 9h
carga043|BETA|Rodrigo Pinto|rodrigo.pinto@betacontabil.example|Computador ou notebook|Só eu|Alta: não consigo trabalhar|Derrubei café no notebook e ele não liga mais
carga044|VIDA|Elisa Prado|elisa.prado@clinicavida.example|Sistema da empresa|Só eu|Média: atrapalha, mas consigo trabalhar|Não consigo abrir o prontuário no MedSys, aparece acesso negado
carga045|ACME|Paulo Henrique|paulo.henrique@acme-logistica.example|Acesso ou senha|Só eu|Média: atrapalha, mas consigo trabalhar|Troquei de celular e o autenticador não tem mais os códigos
carga046|BETA|Fernanda Melo|fernanda.melo@betacontabil.example|E-mail ou Office|Só eu|Média: atrapalha, mas consigo trabalhar|Meu Outlook parou de receber e-mails desde ontem
carga047|VIDA|Henrique Alves|henrique.alves@clinicavida.example|E-mail ou Office|Só eu|Baixa: posso esperar|Recebi um e-mail pedindo para confirmar minha senha num link estranho e cliquei
carga048|ACME|Tatiane Moura|tatiane.moura@acme-logistica.example|Acesso ou senha|Só eu|Baixa: posso esperar|Minha senha expira amanhã e eu queria trocar antes
carga049|BETA|Thiago Moreira|thiago.moreira@betacontabil.example|Internet ou rede|Algumas pessoas|Alta: não consigo trabalhar|O Wi-Fi da sala 3 conecta mas não navega, 5 pessoas paradas
carga050|VIDA|Karina Lopes|karina.lopes@clinicavida.example|Outro|Só eu|Baixa: posso esperar|Meu mouse está falhando o clique, preciso de um novo
carga051|ACME|Marcos Teixeira|marcos.teixeira@acme-logistica.example|Computador ou notebook|Setor ou empresa inteira|Baixa: posso esperar|Queremos trocar os monitores do setor no próximo trimestre
carga052|BETA|Carla Mendes|carla.mendes@betacontabil.example|Impressora|Algumas pessoas|Baixa: posso esperar|A impressora do segundo andar está saindo com folhas em branco
carga053|VIDA|Nelson Ribeiro|nelson.ribeiro@clinicavida.example|E-mail ou Office|Setor ou empresa inteira|Média: atrapalha, mas consigo trabalhar|Ninguém do comercial recebe e-mails de fora desde o almoço
carga054|ACME|Camila Duarte|camila.duarte@acme-logistica.example|E-mail ou Office|Algumas pessoas|Alta: não consigo trabalhar|Várias pessoas receberam e-mail falso do diretor pedindo uma transferência urgente
carga055|BETA|Felipe Nunes|felipe.nunes@betacontabil.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Esqueci minha senha depois das férias e não consigo entrar em nada
carga056|VIDA|Renata Gomes|renata.gomes@clinicavida.example|Internet ou rede|Só eu|Média: atrapalha, mas consigo trabalhar|O Wi-Fi do meu notebook conecta mas não abre nenhum site
carga057|ACME|Gustavo Araújo|gustavo.araujo@acme-logistica.example|Acesso ou senha|Algumas pessoas|Média: atrapalha, mas consigo trabalhar|Eu e mais duas pessoas do RH não abrimos a pasta compartilhada da folha
carga058|BETA|Isabela Costa|isabela.costa@betacontabil.example|Sistema da empresa|Só eu|Baixa: posso esperar|Gostaria de acesso ao Power BI para ver os relatórios de vendas
carga059|VIDA|Vitor Campos|vitor.campos@clinicavida.example|Impressora|Só eu|Baixa: posso esperar|Meu notebook não encontra a impressora nova da sala de reunião
carga060|ACME|Gustavo Araújo|gustavo.araujo@acme-logistica.example|Acesso ou senha|Algumas pessoas|Média: atrapalha, mas consigo trabalhar|Ainda sem solução: eu e mais duas pessoas do rh não abrimos a pasta compartilhada da folha
carga061|BETA|Lucas Martins|lucas.martins@betacontabil.example|Sistema da empresa|Setor ou empresa inteira|Alta: não consigo trabalhar|O sistema principal caiu para todos, dá erro 500 ao salvar
carga062|VIDA|Patrícia Ramos|patricia.ramos@clinicavida.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Minha conta foi bloqueada depois de errar a senha 3 vezes
carga063|ACME|Diego Rocha|diego.rocha@acme-logistica.example|Internet ou rede|Só eu|Alta: não consigo trabalhar|Estou em home office e a VPN não conecta, dá tempo esgotado
carga064|BETA|Olivia Freitas|olivia.freitas@betacontabil.example|Outro|Só eu|Baixa: posso esperar|Preciso instalar o Zoom no meu computador
carga065|VIDA|Eduardo Farias|eduardo.farias@clinicavida.example|Impressora|Setor ou empresa inteira|Alta: não consigo trabalhar|A impressora de etiquetas da expedição parou e não sai nenhum pedido
carga066|ACME|Gabriela Torres|gabriela.torres@acme-logistica.example|Internet ou rede|Setor ou empresa inteira|Alta: não consigo trabalhar|O setor inteiro está sem internet desde as 9h
carga067|BETA|Sérgio Barros|sergio.barros@betacontabil.example|Computador ou notebook|Só eu|Alta: não consigo trabalhar|Derrubei café no notebook e ele não liga mais
carga068|VIDA|Larissa Cardoso|larissa.cardoso@clinicavida.example|Sistema da empresa|Só eu|Média: atrapalha, mas consigo trabalhar|Não consigo abrir o prontuário no MedSys, aparece acesso negado
carga069|ACME|João Pereira|joao.pereira@acme-logistica.example|Acesso ou senha|Só eu|Média: atrapalha, mas consigo trabalhar|Troquei de celular e o autenticador não tem mais os códigos
carga070|BETA|Juliana Reis|juliana.reis@betacontabil.example|E-mail ou Office|Só eu|Média: atrapalha, mas consigo trabalhar|Meu Outlook parou de receber e-mails desde ontem
carga071|VIDA|Bruno Lima|bruno.lima@clinicavida.example|E-mail ou Office|Só eu|Baixa: posso esperar|Recebi um e-mail pedindo para confirmar minha senha num link estranho e cliquei
carga072|ACME|Mariana Dias|mariana.dias@acme-logistica.example|Acesso ou senha|Só eu|Baixa: posso esperar|Minha senha expira amanhã e eu queria trocar antes
carga073|BETA|Rodrigo Pinto|rodrigo.pinto@betacontabil.example|Internet ou rede|Algumas pessoas|Alta: não consigo trabalhar|O Wi-Fi da sala 3 conecta mas não navega, 5 pessoas paradas
carga074|VIDA|Elisa Prado|elisa.prado@clinicavida.example|Outro|Só eu|Baixa: posso esperar|Meu mouse está falhando o clique, preciso de um novo
carga075|ACME|Paulo Henrique|paulo.henrique@acme-logistica.example|Computador ou notebook|Setor ou empresa inteira|Baixa: posso esperar|Queremos trocar os monitores do setor no próximo trimestre
carga076|BETA|Fernanda Melo|fernanda.melo@betacontabil.example|Impressora|Algumas pessoas|Baixa: posso esperar|A impressora do segundo andar está saindo com folhas em branco
carga077|VIDA|Henrique Alves|henrique.alves@clinicavida.example|E-mail ou Office|Setor ou empresa inteira|Média: atrapalha, mas consigo trabalhar|Ninguém do comercial recebe e-mails de fora desde o almoço
carga078|ACME|Tatiane Moura|tatiane.moura@acme-logistica.example|E-mail ou Office|Algumas pessoas|Alta: não consigo trabalhar|Várias pessoas receberam e-mail falso do diretor pedindo uma transferência urgente
carga079|BETA|Thiago Moreira|thiago.moreira@betacontabil.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Esqueci minha senha depois das férias e não consigo entrar em nada
carga080|VIDA|Henrique Alves|henrique.alves@clinicavida.example|E-mail ou Office|Setor ou empresa inteira|Média: atrapalha, mas consigo trabalhar|Ainda sem solução: ninguém do comercial recebe e-mails de fora desde o almoço
carga081|ACME|Marcos Teixeira|marcos.teixeira@acme-logistica.example|Acesso ou senha|Algumas pessoas|Média: atrapalha, mas consigo trabalhar|Eu e mais duas pessoas do RH não abrimos a pasta compartilhada da folha
carga082|BETA|Carla Mendes|carla.mendes@betacontabil.example|Sistema da empresa|Só eu|Baixa: posso esperar|Gostaria de acesso ao Power BI para ver os relatórios de vendas
carga083|VIDA|Nelson Ribeiro|nelson.ribeiro@clinicavida.example|Impressora|Só eu|Baixa: posso esperar|Meu notebook não encontra a impressora nova da sala de reunião
carga084|ACME|Camila Duarte|camila.duarte@acme-logistica.example|Computador ou notebook|Só eu|Média: atrapalha, mas consigo trabalhar|Notebook muito lento, demora 10 minutos para abrir o Excel
carga085|BETA|Felipe Nunes|felipe.nunes@betacontabil.example|Sistema da empresa|Setor ou empresa inteira|Alta: não consigo trabalhar|O sistema principal caiu para todos, dá erro 500 ao salvar
carga086|VIDA|Renata Gomes|renata.gomes@clinicavida.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Minha conta foi bloqueada depois de errar a senha 3 vezes
carga087|ACME|Gustavo Araújo|gustavo.araujo@acme-logistica.example|Internet ou rede|Só eu|Alta: não consigo trabalhar|Estou em home office e a VPN não conecta, dá tempo esgotado
carga088|BETA|Isabela Costa|isabela.costa@betacontabil.example|Outro|Só eu|Baixa: posso esperar|Preciso instalar o Zoom no meu computador
carga089|VIDA|Vitor Campos|vitor.campos@clinicavida.example|Impressora|Setor ou empresa inteira|Alta: não consigo trabalhar|A impressora de etiquetas da expedição parou e não sai nenhum pedido
carga090|ACME|Ana Souza|ana.souza@acme-logistica.example|Internet ou rede|Setor ou empresa inteira|Alta: não consigo trabalhar|O setor inteiro está sem internet desde as 9h
carga091|BETA|Lucas Martins|lucas.martins@betacontabil.example|Computador ou notebook|Só eu|Alta: não consigo trabalhar|Derrubei café no notebook e ele não liga mais
carga092|VIDA|Patrícia Ramos|patricia.ramos@clinicavida.example|Sistema da empresa|Só eu|Média: atrapalha, mas consigo trabalhar|Não consigo abrir o prontuário no MedSys, aparece acesso negado
carga093|ACME|Diego Rocha|diego.rocha@acme-logistica.example|Acesso ou senha|Só eu|Média: atrapalha, mas consigo trabalhar|Troquei de celular e o autenticador não tem mais os códigos
carga094|BETA|Olivia Freitas|olivia.freitas@betacontabil.example|E-mail ou Office|Só eu|Média: atrapalha, mas consigo trabalhar|Meu Outlook parou de receber e-mails desde ontem
carga095|VIDA|Eduardo Farias|eduardo.farias@clinicavida.example|E-mail ou Office|Só eu|Baixa: posso esperar|Recebi um e-mail pedindo para confirmar minha senha num link estranho e cliquei
carga096|ACME|Gabriela Torres|gabriela.torres@acme-logistica.example|Acesso ou senha|Só eu|Baixa: posso esperar|Minha senha expira amanhã e eu queria trocar antes
carga097|BETA|Sérgio Barros|sergio.barros@betacontabil.example|Internet ou rede|Algumas pessoas|Alta: não consigo trabalhar|O Wi-Fi da sala 3 conecta mas não navega, 5 pessoas paradas
carga098|VIDA|Larissa Cardoso|larissa.cardoso@clinicavida.example|Outro|Só eu|Baixa: posso esperar|Meu mouse está falhando o clique, preciso de um novo
carga099|ACME|João Pereira|joao.pereira@acme-logistica.example|Computador ou notebook|Setor ou empresa inteira|Baixa: posso esperar|Queremos trocar os monitores do setor no próximo trimestre
carga100|BETA|Sérgio Barros|sergio.barros@betacontabil.example|Internet ou rede|Algumas pessoas|Alta: não consigo trabalhar|Ainda sem solução: o wi-fi da sala 3 conecta mas não navega, 5 pessoas paradas
carga101|VIDA|Bruno Lima|bruno.lima@clinicavida.example|E-mail ou Office|Setor ou empresa inteira|Média: atrapalha, mas consigo trabalhar|Ninguém do comercial recebe e-mails de fora desde o almoço
carga102|ACME|Mariana Dias|mariana.dias@acme-logistica.example|E-mail ou Office|Algumas pessoas|Alta: não consigo trabalhar|Várias pessoas receberam e-mail falso do diretor pedindo uma transferência urgente
carga103|BETA|Rodrigo Pinto|rodrigo.pinto@betacontabil.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Esqueci minha senha depois das férias e não consigo entrar em nada
carga104|VIDA|Elisa Prado|elisa.prado@clinicavida.example|Internet ou rede|Só eu|Média: atrapalha, mas consigo trabalhar|O Wi-Fi do meu notebook conecta mas não abre nenhum site
carga105|ACME|Paulo Henrique|paulo.henrique@acme-logistica.example|Acesso ou senha|Algumas pessoas|Média: atrapalha, mas consigo trabalhar|Eu e mais duas pessoas do RH não abrimos a pasta compartilhada da folha
carga106|BETA|Fernanda Melo|fernanda.melo@betacontabil.example|Sistema da empresa|Só eu|Baixa: posso esperar|Gostaria de acesso ao Power BI para ver os relatórios de vendas
carga107|VIDA|Henrique Alves|henrique.alves@clinicavida.example|Impressora|Só eu|Baixa: posso esperar|Meu notebook não encontra a impressora nova da sala de reunião
carga108|ACME|Tatiane Moura|tatiane.moura@acme-logistica.example|Computador ou notebook|Só eu|Média: atrapalha, mas consigo trabalhar|Notebook muito lento, demora 10 minutos para abrir o Excel
carga109|BETA|Thiago Moreira|thiago.moreira@betacontabil.example|Sistema da empresa|Setor ou empresa inteira|Alta: não consigo trabalhar|O sistema principal caiu para todos, dá erro 500 ao salvar
carga110|VIDA|Karina Lopes|karina.lopes@clinicavida.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Minha conta foi bloqueada depois de errar a senha 3 vezes
carga111|ACME|Marcos Teixeira|marcos.teixeira@acme-logistica.example|Internet ou rede|Só eu|Alta: não consigo trabalhar|Estou em home office e a VPN não conecta, dá tempo esgotado
carga112|BETA|Carla Mendes|carla.mendes@betacontabil.example|Outro|Só eu|Baixa: posso esperar|Preciso instalar o Zoom no meu computador
carga113|VIDA|Nelson Ribeiro|nelson.ribeiro@clinicavida.example|Impressora|Setor ou empresa inteira|Alta: não consigo trabalhar|A impressora de etiquetas da expedição parou e não sai nenhum pedido
carga114|ACME|Camila Duarte|camila.duarte@acme-logistica.example|Internet ou rede|Setor ou empresa inteira|Alta: não consigo trabalhar|O setor inteiro está sem internet desde as 9h
carga115|BETA|Felipe Nunes|felipe.nunes@betacontabil.example|Computador ou notebook|Só eu|Alta: não consigo trabalhar|Derrubei café no notebook e ele não liga mais
carga116|VIDA|Renata Gomes|renata.gomes@clinicavida.example|Sistema da empresa|Só eu|Média: atrapalha, mas consigo trabalhar|Não consigo abrir o prontuário no MedSys, aparece acesso negado
carga117|ACME|Gustavo Araújo|gustavo.araujo@acme-logistica.example|Acesso ou senha|Só eu|Média: atrapalha, mas consigo trabalhar|Troquei de celular e o autenticador não tem mais os códigos
carga118|BETA|Isabela Costa|isabela.costa@betacontabil.example|E-mail ou Office|Só eu|Média: atrapalha, mas consigo trabalhar|Meu Outlook parou de receber e-mails desde ontem
carga119|VIDA|Vitor Campos|vitor.campos@clinicavida.example|E-mail ou Office|Só eu|Baixa: posso esperar|Recebi um e-mail pedindo para confirmar minha senha num link estranho e cliquei
carga120|ACME|Gustavo Araújo|gustavo.araujo@acme-logistica.example|Acesso ou senha|Só eu|Média: atrapalha, mas consigo trabalhar|Ainda sem solução: troquei de celular e o autenticador não tem mais os códigos
carga121|BETA|Lucas Martins|lucas.martins@betacontabil.example|Internet ou rede|Algumas pessoas|Alta: não consigo trabalhar|O Wi-Fi da sala 3 conecta mas não navega, 5 pessoas paradas
carga122|VIDA|Patrícia Ramos|patricia.ramos@clinicavida.example|Outro|Só eu|Baixa: posso esperar|Meu mouse está falhando o clique, preciso de um novo
carga123|ACME|Diego Rocha|diego.rocha@acme-logistica.example|Computador ou notebook|Setor ou empresa inteira|Baixa: posso esperar|Queremos trocar os monitores do setor no próximo trimestre
carga124|BETA|Olivia Freitas|olivia.freitas@betacontabil.example|Impressora|Algumas pessoas|Baixa: posso esperar|A impressora do segundo andar está saindo com folhas em branco
carga125|VIDA|Eduardo Farias|eduardo.farias@clinicavida.example|E-mail ou Office|Setor ou empresa inteira|Média: atrapalha, mas consigo trabalhar|Ninguém do comercial recebe e-mails de fora desde o almoço
carga126|ACME|Gabriela Torres|gabriela.torres@acme-logistica.example|E-mail ou Office|Algumas pessoas|Alta: não consigo trabalhar|Várias pessoas receberam e-mail falso do diretor pedindo uma transferência urgente
carga127|BETA|Sérgio Barros|sergio.barros@betacontabil.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Esqueci minha senha depois das férias e não consigo entrar em nada
carga128|VIDA|Larissa Cardoso|larissa.cardoso@clinicavida.example|Internet ou rede|Só eu|Média: atrapalha, mas consigo trabalhar|O Wi-Fi do meu notebook conecta mas não abre nenhum site
carga129|ACME|João Pereira|joao.pereira@acme-logistica.example|Acesso ou senha|Algumas pessoas|Média: atrapalha, mas consigo trabalhar|Eu e mais duas pessoas do RH não abrimos a pasta compartilhada da folha
carga130|BETA|Juliana Reis|juliana.reis@betacontabil.example|Sistema da empresa|Só eu|Baixa: posso esperar|Gostaria de acesso ao Power BI para ver os relatórios de vendas
carga131|VIDA|Bruno Lima|bruno.lima@clinicavida.example|Impressora|Só eu|Baixa: posso esperar|Meu notebook não encontra a impressora nova da sala de reunião
carga132|ACME|Mariana Dias|mariana.dias@acme-logistica.example|Computador ou notebook|Só eu|Média: atrapalha, mas consigo trabalhar|Notebook muito lento, demora 10 minutos para abrir o Excel
carga133|BETA|Rodrigo Pinto|rodrigo.pinto@betacontabil.example|Sistema da empresa|Setor ou empresa inteira|Alta: não consigo trabalhar|O sistema principal caiu para todos, dá erro 500 ao salvar
carga134|VIDA|Elisa Prado|elisa.prado@clinicavida.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Minha conta foi bloqueada depois de errar a senha 3 vezes
carga135|ACME|Paulo Henrique|paulo.henrique@acme-logistica.example|Internet ou rede|Só eu|Alta: não consigo trabalhar|Estou em home office e a VPN não conecta, dá tempo esgotado
carga136|BETA|Fernanda Melo|fernanda.melo@betacontabil.example|Outro|Só eu|Baixa: posso esperar|Preciso instalar o Zoom no meu computador
carga137|VIDA|Henrique Alves|henrique.alves@clinicavida.example|Impressora|Setor ou empresa inteira|Alta: não consigo trabalhar|A impressora de etiquetas da expedição parou e não sai nenhum pedido
carga138|ACME|Tatiane Moura|tatiane.moura@acme-logistica.example|Internet ou rede|Setor ou empresa inteira|Alta: não consigo trabalhar|O setor inteiro está sem internet desde as 9h
carga139|BETA|Thiago Moreira|thiago.moreira@betacontabil.example|Computador ou notebook|Só eu|Alta: não consigo trabalhar|Derrubei café no notebook e ele não liga mais
carga140|VIDA|Henrique Alves|henrique.alves@clinicavida.example|Impressora|Setor ou empresa inteira|Alta: não consigo trabalhar|Ainda sem solução: a impressora de etiquetas da expedição parou e não sai nenhum pedido
carga141|ACME|Marcos Teixeira|marcos.teixeira@acme-logistica.example|Acesso ou senha|Só eu|Média: atrapalha, mas consigo trabalhar|Troquei de celular e o autenticador não tem mais os códigos
carga142|BETA|Carla Mendes|carla.mendes@betacontabil.example|E-mail ou Office|Só eu|Média: atrapalha, mas consigo trabalhar|Meu Outlook parou de receber e-mails desde ontem
carga143|VIDA|Nelson Ribeiro|nelson.ribeiro@clinicavida.example|E-mail ou Office|Só eu|Baixa: posso esperar|Recebi um e-mail pedindo para confirmar minha senha num link estranho e cliquei
carga144|ACME|Camila Duarte|camila.duarte@acme-logistica.example|Acesso ou senha|Só eu|Baixa: posso esperar|Minha senha expira amanhã e eu queria trocar antes
carga145|BETA|Felipe Nunes|felipe.nunes@betacontabil.example|Internet ou rede|Algumas pessoas|Alta: não consigo trabalhar|O Wi-Fi da sala 3 conecta mas não navega, 5 pessoas paradas
carga146|VIDA|Renata Gomes|renata.gomes@clinicavida.example|Outro|Só eu|Baixa: posso esperar|Meu mouse está falhando o clique, preciso de um novo
carga147|ACME|Gustavo Araújo|gustavo.araujo@acme-logistica.example|Computador ou notebook|Setor ou empresa inteira|Baixa: posso esperar|Queremos trocar os monitores do setor no próximo trimestre
carga148|BETA|Isabela Costa|isabela.costa@betacontabil.example|Impressora|Algumas pessoas|Baixa: posso esperar|A impressora do segundo andar está saindo com folhas em branco
carga149|VIDA|Vitor Campos|vitor.campos@clinicavida.example|E-mail ou Office|Setor ou empresa inteira|Média: atrapalha, mas consigo trabalhar|Ninguém do comercial recebe e-mails de fora desde o almoço
carga150|ACME|Ana Souza|ana.souza@acme-logistica.example|E-mail ou Office|Algumas pessoas|Alta: não consigo trabalhar|Várias pessoas receberam e-mail falso do diretor pedindo uma transferência urgente
carga151|BETA|Lucas Martins|lucas.martins@betacontabil.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Esqueci minha senha depois das férias e não consigo entrar em nada
carga152|VIDA|Patrícia Ramos|patricia.ramos@clinicavida.example|Internet ou rede|Só eu|Média: atrapalha, mas consigo trabalhar|O Wi-Fi do meu notebook conecta mas não abre nenhum site
carga153|ACME|Diego Rocha|diego.rocha@acme-logistica.example|Acesso ou senha|Algumas pessoas|Média: atrapalha, mas consigo trabalhar|Eu e mais duas pessoas do RH não abrimos a pasta compartilhada da folha
carga154|BETA|Olivia Freitas|olivia.freitas@betacontabil.example|Sistema da empresa|Só eu|Baixa: posso esperar|Gostaria de acesso ao Power BI para ver os relatórios de vendas
carga155|VIDA|Eduardo Farias|eduardo.farias@clinicavida.example|Impressora|Só eu|Baixa: posso esperar|Meu notebook não encontra a impressora nova da sala de reunião
carga156|ACME|Gabriela Torres|gabriela.torres@acme-logistica.example|Computador ou notebook|Só eu|Média: atrapalha, mas consigo trabalhar|Notebook muito lento, demora 10 minutos para abrir o Excel
carga157|BETA|Sérgio Barros|sergio.barros@betacontabil.example|Sistema da empresa|Setor ou empresa inteira|Alta: não consigo trabalhar|O sistema principal caiu para todos, dá erro 500 ao salvar
carga158|VIDA|Larissa Cardoso|larissa.cardoso@clinicavida.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Minha conta foi bloqueada depois de errar a senha 3 vezes
carga159|ACME|João Pereira|joao.pereira@acme-logistica.example|Internet ou rede|Só eu|Alta: não consigo trabalhar|Estou em home office e a VPN não conecta, dá tempo esgotado
carga160|BETA|Sérgio Barros|sergio.barros@betacontabil.example|Sistema da empresa|Setor ou empresa inteira|Alta: não consigo trabalhar|Ainda sem solução: o sistema principal caiu para todos, dá erro 500 ao salvar
carga161|VIDA|Bruno Lima|bruno.lima@clinicavida.example|Impressora|Setor ou empresa inteira|Alta: não consigo trabalhar|A impressora de etiquetas da expedição parou e não sai nenhum pedido
carga162|ACME|Mariana Dias|mariana.dias@acme-logistica.example|Internet ou rede|Setor ou empresa inteira|Alta: não consigo trabalhar|O setor inteiro está sem internet desde as 9h
carga163|BETA|Rodrigo Pinto|rodrigo.pinto@betacontabil.example|Computador ou notebook|Só eu|Alta: não consigo trabalhar|Derrubei café no notebook e ele não liga mais
carga164|VIDA|Elisa Prado|elisa.prado@clinicavida.example|Sistema da empresa|Só eu|Média: atrapalha, mas consigo trabalhar|Não consigo abrir o prontuário no MedSys, aparece acesso negado
carga165|ACME|Paulo Henrique|paulo.henrique@acme-logistica.example|Acesso ou senha|Só eu|Média: atrapalha, mas consigo trabalhar|Troquei de celular e o autenticador não tem mais os códigos
carga166|BETA|Fernanda Melo|fernanda.melo@betacontabil.example|E-mail ou Office|Só eu|Média: atrapalha, mas consigo trabalhar|Meu Outlook parou de receber e-mails desde ontem
carga167|VIDA|Henrique Alves|henrique.alves@clinicavida.example|E-mail ou Office|Só eu|Baixa: posso esperar|Recebi um e-mail pedindo para confirmar minha senha num link estranho e cliquei
carga168|ACME|Tatiane Moura|tatiane.moura@acme-logistica.example|Acesso ou senha|Só eu|Baixa: posso esperar|Minha senha expira amanhã e eu queria trocar antes
carga169|BETA|Thiago Moreira|thiago.moreira@betacontabil.example|Internet ou rede|Algumas pessoas|Alta: não consigo trabalhar|O Wi-Fi da sala 3 conecta mas não navega, 5 pessoas paradas
carga170|VIDA|Karina Lopes|karina.lopes@clinicavida.example|Outro|Só eu|Baixa: posso esperar|Meu mouse está falhando o clique, preciso de um novo
carga171|ACME|Marcos Teixeira|marcos.teixeira@acme-logistica.example|Computador ou notebook|Setor ou empresa inteira|Baixa: posso esperar|Queremos trocar os monitores do setor no próximo trimestre
carga172|BETA|Carla Mendes|carla.mendes@betacontabil.example|Impressora|Algumas pessoas|Baixa: posso esperar|A impressora do segundo andar está saindo com folhas em branco
carga173|VIDA|Nelson Ribeiro|nelson.ribeiro@clinicavida.example|E-mail ou Office|Setor ou empresa inteira|Média: atrapalha, mas consigo trabalhar|Ninguém do comercial recebe e-mails de fora desde o almoço
carga174|ACME|Camila Duarte|camila.duarte@acme-logistica.example|E-mail ou Office|Algumas pessoas|Alta: não consigo trabalhar|Várias pessoas receberam e-mail falso do diretor pedindo uma transferência urgente
carga175|BETA|Felipe Nunes|felipe.nunes@betacontabil.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Esqueci minha senha depois das férias e não consigo entrar em nada
carga176|VIDA|Renata Gomes|renata.gomes@clinicavida.example|Internet ou rede|Só eu|Média: atrapalha, mas consigo trabalhar|O Wi-Fi do meu notebook conecta mas não abre nenhum site
carga177|ACME|Gustavo Araújo|gustavo.araujo@acme-logistica.example|Acesso ou senha|Algumas pessoas|Média: atrapalha, mas consigo trabalhar|Eu e mais duas pessoas do RH não abrimos a pasta compartilhada da folha
carga178|BETA|Isabela Costa|isabela.costa@betacontabil.example|Sistema da empresa|Só eu|Baixa: posso esperar|Gostaria de acesso ao Power BI para ver os relatórios de vendas
carga179|VIDA|Vitor Campos|vitor.campos@clinicavida.example|Impressora|Só eu|Baixa: posso esperar|Meu notebook não encontra a impressora nova da sala de reunião
carga180|ACME|Gustavo Araújo|gustavo.araujo@acme-logistica.example|Acesso ou senha|Algumas pessoas|Média: atrapalha, mas consigo trabalhar|Ainda sem solução: eu e mais duas pessoas do rh não abrimos a pasta compartilhada da folha
carga181|BETA|Lucas Martins|lucas.martins@betacontabil.example|Sistema da empresa|Setor ou empresa inteira|Alta: não consigo trabalhar|O sistema principal caiu para todos, dá erro 500 ao salvar
carga182|VIDA|Patrícia Ramos|patricia.ramos@clinicavida.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Minha conta foi bloqueada depois de errar a senha 3 vezes
carga183|ACME|Diego Rocha|diego.rocha@acme-logistica.example|Internet ou rede|Só eu|Alta: não consigo trabalhar|Estou em home office e a VPN não conecta, dá tempo esgotado
carga184|BETA|Olivia Freitas|olivia.freitas@betacontabil.example|Outro|Só eu|Baixa: posso esperar|Preciso instalar o Zoom no meu computador
carga185|VIDA|Eduardo Farias|eduardo.farias@clinicavida.example|Impressora|Setor ou empresa inteira|Alta: não consigo trabalhar|A impressora de etiquetas da expedição parou e não sai nenhum pedido
carga186|ACME|Gabriela Torres|gabriela.torres@acme-logistica.example|Internet ou rede|Setor ou empresa inteira|Alta: não consigo trabalhar|O setor inteiro está sem internet desde as 9h
carga187|BETA|Sérgio Barros|sergio.barros@betacontabil.example|Computador ou notebook|Só eu|Alta: não consigo trabalhar|Derrubei café no notebook e ele não liga mais
carga188|VIDA|Larissa Cardoso|larissa.cardoso@clinicavida.example|Sistema da empresa|Só eu|Média: atrapalha, mas consigo trabalhar|Não consigo abrir o prontuário no MedSys, aparece acesso negado
carga189|ACME|João Pereira|joao.pereira@acme-logistica.example|Acesso ou senha|Só eu|Média: atrapalha, mas consigo trabalhar|Troquei de celular e o autenticador não tem mais os códigos
carga190|BETA|Juliana Reis|juliana.reis@betacontabil.example|E-mail ou Office|Só eu|Média: atrapalha, mas consigo trabalhar|Meu Outlook parou de receber e-mails desde ontem
carga191|VIDA|Bruno Lima|bruno.lima@clinicavida.example|E-mail ou Office|Só eu|Baixa: posso esperar|Recebi um e-mail pedindo para confirmar minha senha num link estranho e cliquei
carga192|ACME|Mariana Dias|mariana.dias@acme-logistica.example|Acesso ou senha|Só eu|Baixa: posso esperar|Minha senha expira amanhã e eu queria trocar antes
carga193|BETA|Rodrigo Pinto|rodrigo.pinto@betacontabil.example|Internet ou rede|Algumas pessoas|Alta: não consigo trabalhar|O Wi-Fi da sala 3 conecta mas não navega, 5 pessoas paradas
carga194|VIDA|Elisa Prado|elisa.prado@clinicavida.example|Outro|Só eu|Baixa: posso esperar|Meu mouse está falhando o clique, preciso de um novo
carga195|ACME|Paulo Henrique|paulo.henrique@acme-logistica.example|Computador ou notebook|Setor ou empresa inteira|Baixa: posso esperar|Queremos trocar os monitores do setor no próximo trimestre
carga196|BETA|Fernanda Melo|fernanda.melo@betacontabil.example|Impressora|Algumas pessoas|Baixa: posso esperar|A impressora do segundo andar está saindo com folhas em branco
carga197|VIDA|Henrique Alves|henrique.alves@clinicavida.example|E-mail ou Office|Setor ou empresa inteira|Média: atrapalha, mas consigo trabalhar|Ninguém do comercial recebe e-mails de fora desde o almoço
carga198|ACME|Tatiane Moura|tatiane.moura@acme-logistica.example|E-mail ou Office|Algumas pessoas|Alta: não consigo trabalhar|Várias pessoas receberam e-mail falso do diretor pedindo uma transferência urgente
carga199|BETA|Thiago Moreira|thiago.moreira@betacontabil.example|Acesso ou senha|Só eu|Alta: não consigo trabalhar|Esqueci minha senha depois das férias e não consigo entrar em nada
carga200|VIDA|Henrique Alves|henrique.alves@clinicavida.example|E-mail ou Office|Setor ou empresa inteira|Média: atrapalha, mas consigo trabalhar|Ainda sem solução: ninguém do comercial recebe e-mails de fora desde o almoço
EOF
echo "Pronto. Exporte a tabela Chamados em CSV e compare com gabarito_200.csv."
