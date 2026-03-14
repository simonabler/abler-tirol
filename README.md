# abler.tirol

Landing Page und Ökosystem-Überblick für alle Produkte unter `abler.tirol`.

Diese Seite ist der Einstiegspunkt in das abler.tirol-Produktökosystem – sie stellt die Person hinter den Produkten vor, zeigt alle aktiven Subdomains und verlinkt weiter.

---

## Ökosystem

| Subdomain | Beschreibung | Repo |
|---|---|---|
| **abler.tirol** | Landing Page · Überblick | ← dieses Repo |
| **api.abler.tirol** | Zentrale REST-API · Docs · Font-Server | [api-abler-tirol](https://github.com/simonabler/api-abler-tirol) |
| **barcode.abler.tirol** | QR-Code, Barcode & GS1 Generator | [barcode-abler-tirol](https://github.com/simonabler/barcode-abler-tirol) |
| **pdf.abler.tirol** | PDF Sign, Merge & Split | [pdf-abler-tirol](https://github.com/simonabler/pdf-abler-tirol) |
| **klara.abler.tirol** | Dokumentationstool für Lehrkräfte | [Klara](https://github.com/simonabler/Klara) |

---

## Tech Stack

- **Pure Static** — reines HTML/CSS/JS, kein Framework, kein Build-Step
- **nginx:alpine** — ausgeliefert via Docker
- **Fonts** — self-hosted über `api.abler.tirol/fonts/` (kein Google Fonts)
- **Zweisprachig** — DE / EN via CSS-Klassen, kein JS-Framework

---

## Lokale Entwicklung

```bash
# Repo klonen
git clone https://github.com/simonabler/abler-tirol.git
cd abler-tirol

# Mit Docker starten (Port 8080)
docker compose up
```

Anschließend unter [http://localhost:8080](http://localhost:8080) erreichbar.

`index.html` wird per Volume direkt eingebunden – Änderungen sind nach Browser-Reload sofort sichtbar, ohne neu zu bauen.

---

## Produktions-Build

```bash
# Image bauen
docker build -t abler-tirol .

# Container starten
docker run -p 80:80 abler-tirol
```

---

## Projektstruktur

```
abler-tirol/
├── index.html              # Gesamte Seite (single file)
├── nginx.conf              # nginx Server-Konfiguration
├── Dockerfile              # nginx:alpine Container
├── docker-compose.yml      # Lokale Entwicklung
├── DESIGN_PRINCIPLES.md    # Ökosystem-weites Design-System
└── README.md
```

---

## Design

Dieses Projekt folgt den in [`DESIGN_PRINCIPLES.md`](./DESIGN_PRINCIPLES.md) definierten Gestaltungsregeln, die für alle Subdomains des abler.tirol-Ökosystems gelten.

Kurzfassung:
- Schriften: `DM Serif Display` · `Inter` · `DM Mono`
- Farben: Neutral Slate als Anker, Akzentfarben pro Subdomain
- Buttons immer Pill-Form (`border-radius: 999px`)
- Kein Google Fonts, keine externen Abhängigkeiten

---

## Lizenz

© 2026 Simon Abler · [simon@abler.tirol](mailto:simon@abler.tirol)
