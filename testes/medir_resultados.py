#!/usr/bin/env python3
"""Mede o teste de escala do helpdesk.

Uso:
  1. No Airtable, tabela Chamados: menu da visualização > Download CSV  (salve como chamados.csv)
  2. python3 medir_resultados.py chamados.csv gabarito_200.csv

Mostra: tempo médio, acerto da IA (categoria, artigo, duplicado), prioridade,
taxa de resolução automática, erros, custo estimado por chamado e números por empresa.
Só usa a biblioteca padrão do Python.
"""
import csv
import sys
from collections import defaultdict

# Preço de referência para estimar custo SE fosse plano pago (US$ por 1 milhão de tokens).
# Referência: gemini-3.5-flash-lite (out/2026: US$ 0,30 entrada e US$ 2,50 saída; média ~0,60).
# Confira o preço atual na página de preços da Gemini API e ajuste aqui.
PRECO_US_POR_MILHAO = 0.60
DOLAR_EM_REAIS = 5.50


def ler(caminho):
    with open(caminho, encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def marcado(v):
    return str(v).strip().lower() in ("checked", "true", "1", "sim", "x")


def num(v):
    try:
        return float(str(v).replace(",", "."))
    except ValueError:
        return None


def pct(a, b):
    return f"{a}/{b} ({a / b:.0%})" if b else "0/0"


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(1)
    chamados = [c for c in ler(sys.argv[1]) if c.get("ID Tally", "").startswith("carga")]
    gabarito = {g["ID Tally"]: g for g in ler(sys.argv[2])}
    hd_para_tally = {c["ID"]: c["ID Tally"] for c in chamados}

    if not chamados:
        print("Nenhum chamado de carga no CSV. Confira se exportou a tabela Chamados.")
        sys.exit(1)

    tempos, tokens = [], []
    ok_cat = ok_art = ok_pri = 0
    dup_esperados = dup_pegos = dup_falsos = 0
    auto = auto_esperado = auto_certo = 0
    erros = []
    por_emp = defaultdict(lambda: {"n": 0, "auto": 0, "revisao": 0, "cat": 0, "tempo": []})

    for c in chamados:
        g = gabarito.get(c["ID Tally"])
        if not g:
            continue
        e = por_emp[c.get("Código empresa") or g["Empresa"]]
        e["n"] += 1
        t = num(c.get("Tempo de triagem (s)", ""))
        if t is not None:
            tempos.append(t)
            e["tempo"].append(t)
        k = num(c.get("Tokens estimados", ""))
        if k is not None:
            tokens.append(k)

        if c.get("Categoria IA") == g["Categoria esperada"]:
            ok_cat += 1
            e["cat"] += 1
        art = c.get("Artigo KB") or "nenhum"
        if art == g["Artigo esperado"]:
            ok_art += 1
        if c.get("Prioridade") == g["Prioridade esperada"]:
            ok_pri += 1

        aceitos = [x for x in g["Duplicado de"].split(";") if x]
        marcado_dup = hd_para_tally.get(c.get("Duplicado de", ""), "")
        if aceitos:
            dup_esperados += 1
            if marcado_dup in aceitos:
                dup_pegos += 1
        elif marcado_dup:
            dup_falsos += 1

        foi_auto = marcado(c.get("Resolvido automaticamente", ""))
        if foi_auto:
            auto += 1
            e["auto"] += 1
        if g["Resolve sozinho?"] == "sim":
            auto_esperado += 1
            if foi_auto:
                auto_certo += 1
        if marcado(c.get("Revisão humana", "")):
            e["revisao"] += 1

        motivo = c.get("Motivo IA", "")
        if motivo.startswith("IA não respondeu"):
            erros.append(c["ID Tally"])

    n = sum(e["n"] for e in por_emp.values())
    faltando = len(gabarito) - n
    print(f"\nChamados medidos: {n} (faltando no Airtable: {faltando})")
    if tempos:
        tempos.sort()
        print(f"Tempo de triagem: média {sum(tempos) / len(tempos):.1f} s, "
              f"mediana {tempos[len(tempos) // 2]:.1f} s, pior {tempos[-1]:.1f} s")
    print(f"Prioridade igual ao gabarito (regra): {pct(ok_pri, n)}")
    print(f"Categoria certa (IA): {pct(ok_cat, n)}")
    print(f"Artigo da KB certo (IA): {pct(ok_art, n)}")
    print(f"Duplicados e incidentes coletivos agrupados: {pct(dup_pegos, dup_esperados)}"
          f"  | marcados sem motivo: {dup_falsos}")
    print(f"Resolvidos automaticamente: {pct(auto, n)}"
          f"  | dos que deveriam: {pct(auto_certo, auto_esperado)}")
    print(f"Erros (IA não respondeu): {len(erros)}" + (f"  ex.: {', '.join(erros[:5])}" if erros else ""))
    if tokens:
        media = sum(tokens) / len(tokens)
        custo = media / 1_000_000 * PRECO_US_POR_MILHAO
        print(f"Tokens por chamado (estimado): {media:.0f}  | custo se fosse pago: "
              f"US$ {custo:.5f} (R$ {custo * DOLAR_EM_REAIS:.4f}) por chamado, "
              f"R$ {custo * DOLAR_EM_REAIS * 1000:.2f} por mil chamados")

    print("\nPor empresa")
    print(f"{'Empresa':<8}{'Chamados':>9}{'Auto':>7}{'Revisão':>9}{'Categoria ok':>14}{'Tempo médio':>13}")
    for cod in sorted(por_emp):
        e = por_emp[cod]
        tm = f"{sum(e['tempo']) / len(e['tempo']):.1f} s" if e["tempo"] else "-"
        print(f"{cod:<8}{e['n']:>9}{e['auto']:>7}{e['revisao']:>9}"
              f"{(str(round(100 * e['cat'] / e['n'])) + '%') if e['n'] else '-':>14}{tm:>13}")


if __name__ == "__main__":
    main()
