# 🩺 Linux System Health Check

Script em Bash que faz uma verificação diária do estado de um sistema Linux, incluindo diagnóstico de rede. O resultado é mostrado no terminal e guardado num ficheiro de relatório.

## 📋 O que verifica

| Área | Comando usado | Descrição |
|------|---------------|-----------|
| Disco | `df -h` | Utilização das partições |
| Memória | `free -h` | RAM e swap em uso |
| Carga do CPU | `uptime` | Médias de carga a 1/5/15 minutos |
| Serviços | `systemctl --failed` | Serviços systemd com falhas |
| Processos (CPU) | `ps` | Top 5 processos que mais CPU consomem |
| Processos (RAM) | `ps` | Top 5 processos que mais memória consomem |
| Uptime | `uptime -p` | Há quanto tempo o sistema está ligado |
| Logs de erro | `journalctl -b -p 3` | Últimos 10 erros (prioridade 3 ou superior) do boot atual |
| Interfaces de rede | `ip a` | Interfaces e endereços IP |
| Rotas | `ip route` | Tabela de encaminhamento |
| Portas abertas | `ss -tulnp` | Portas TCP/UDP em escuta |
| Conectividade | `ping` | Testa internet (`8.8.8.8`) e resolução DNS (`google.com`) |

## ⚙️ Requisitos

- Linux com **systemd** (`systemctl`, `journalctl`)
- Bash
- Pacotes habituais: `coreutils`, `procps`, `iproute2`, `iputils-ping`
- Permissões de `root` (ou `sudo`) para ver todos os logs e os processos associados às portas em escuta

## 🚀 Utilização

```bash
# 1. Clonar o repositório
git clone https://github.com/<o-teu-utilizador>/<nome-do-repo>.git
cd <nome-do-repo>

# 2. Dar permissões de execução
chmod +x health-check.sh

# 3. Executar
bash health-check.sh
# ou, para ver todos os logs e portas:
sudo bash health-check.sh
```

O relatório é guardado em `~/health-report.txt` (podes alterar a variável `LOGFILE` no início do script).

## 🕒 Execução automática (cron)

Para correr o script todos os dias às 08:00:

```bash
crontab -e
```

```cron
0 8 * * * /bin/bash /caminho/para/health-check.sh
```

## 📄 Exemplo de output

```
=================================================================================
 System Health Report
 HOST: meu-servidor
 DATA: 2026-10-11 08:00:00
=================================================================================

[+] Disk Usage:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        50G   21G   27G  44% /
...

[+] Connectivity Check:
  Pinging 8.8.8.8 (internet)...
  Internet connectivity: OK
  Pinging google.com (DNS resolution)...
  DNS resolution: OK
```

## 🗂️ Estrutura do projeto

```
.
├── health-check.sh   # Script principal
└── README.md
```

## 🛠️ Possíveis melhorias

- Alertas por email/Telegram quando um teste falha
- Limiares configuráveis (ex.: avisar se o disco passar de 90%)
- Exportação do relatório em JSON/HTML
- Rotação de relatórios por data

## 📜 Licença

Distribuído sob a licença MIT. Consulta o ficheiro `LICENSE` para mais informações.

## 👤 Autor

**MOISES MIGUEL** — [GitHub](https://github.com/moises08)
