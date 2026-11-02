#!/bin/bash
# 9 chamados de demonstração (3 por empresa) com e-mail de verdade para a sua caixa.
# Uso: bash demo_9_chamados.sh seuemail   (a parte antes do @gmail.com)
U="$1"; URL="http://localhost:5678/webhook/helpdesk-tally"
[ -z "$U" ] && { echo "Uso: bash demo_9_chamados.sh seuemail"; exit 1; }
while IFS='|' read -r id emp nome tag tipo impacto urg desc; do
  json=$(printf '{"eventType":"FORM_RESPONSE","data":{"responseId":"%s","fields":[{"label":"empresa","value":"%s"},{"label":"Nome completo","value":"%s"},{"label":"E-mail","value":"%s+%s@gmail.com"},{"label":"Telefone (WhatsApp)","value":"+5511900000000"},{"label":"Tipo do problema","value":"%s"},{"label":"Quantas pessoas são afetadas?","value":"%s"},{"label":"Urgência","value":"%s"},{"label":"Descreva o problema","value":"%s"}]}}' "$id" "$emp" "$nome" "$U" "$id" "$tipo" "$impacto" "$urg" "$desc")
  curl -s -o /dev/null -w "$id ($emp): HTTP %{http_code}\n" -X POST "$URL" -H "Content-Type: application/json" -d "$json"
  sleep 6
done <<'EOF'
demo01|ACME|Bruno Lima|01|Acesso ou senha|Só eu|Baixa: posso esperar|Minha senha expira amanhã e eu queria trocar antes
demo02|ACME|Carla Mendes|02|Internet ou rede|Setor ou empresa inteira|Alta: não consigo trabalhar|O setor inteiro está sem internet desde as 9h
demo03|ACME|Diego Rocha|03|Internet ou rede|Só eu|Alta: não consigo trabalhar|Estou em home office e a VPN não conecta, dá tempo esgotado
demo04|BETA|Elisa Prado|04|Acesso ou senha|Só eu|Baixa: posso esperar|Minha senha expira amanhã e eu queria trocar antes
demo05|BETA|Felipe Nunes|05|Internet ou rede|Setor ou empresa inteira|Alta: não consigo trabalhar|O setor inteiro está sem internet desde as 9h
demo06|BETA|Gabriela Torres|06|Internet ou rede|Só eu|Alta: não consigo trabalhar|Estou em home office e a VPN não conecta, dá tempo esgotado
demo07|VIDA|Henrique Alves|07|Acesso ou senha|Só eu|Baixa: posso esperar|Minha senha expira amanhã e eu queria trocar antes
demo08|VIDA|Isabela Costa|08|Internet ou rede|Setor ou empresa inteira|Alta: não consigo trabalhar|O setor inteiro está sem internet desde as 9h
demo09|VIDA|João Pereira|09|Internet ou rede|Só eu|Alta: não consigo trabalhar|Estou em home office e a VPN não conecta, dá tempo esgotado
EOF
