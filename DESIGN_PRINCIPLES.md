# abler.tirol — Design Principles

> Dieses Dokument definiert die gestalterische und technische Grundlage für alle Produkte unter `abler.tirol`.  
> Jede Subdomain darf eine eigene Farbidentität haben – der Wiedererkennungswert entsteht durch geteilte Struktur, Typografie und Haltung.

---

## 1. Grundphilosophie

**Weniger, aber besser.**  
Jedes visuelle Element auf einer Seite muss einen Grund haben. Dekoration ohne Funktion wird vermieden. Das Design soll Vertrauen erzeugen – nicht durch Lautstärke, sondern durch Präzision und Klarheit.

Drei Prinzipien gelten für alle Produkte im Ökosystem:

- **Sicher gedacht** – Sicherheit und Datenschutz sind keine nachträglichen Features, sondern prägen schon das Design. Keine dunklen Muster, keine versteckten Elemente, keine irreführenden CTAs.
- **Reduziert gestaltet** – Weißraum ist kein leerer Raum, sondern ein Gestaltungsmittel. Wenige, bewusste Akzente statt visueller Lautstärke.
- **Technisch präzise** – Interfaces sollen nicht nur gut aussehen, sondern nachvollziehbar funktionieren. Beschriftungen sind eindeutig, Zustände klar erkennbar.

---

## 2. Systemarchitektur

### Überblick

```
abler.tirol          → Landing Page · Ökosystem-Überblick
│
├── api.abler.tirol  → Zentrale REST-API · Docs · Swagger · Auth · Font-Serving
│   │                  CORS: * (öffentlich nutzbar)
│   │
│   ├── /api/qr
│   ├── /api/barcode
│   ├── /api/barcode/gs1
│   ├── /api/pdf/sign
│   ├── /api/pdf/merge
│   ├── /api/pdf/split
│   ├── /api/crypto
│   ├── /api/watermark
│   ├── /api/utils
│   └── /fonts/*         ← Self-hosted Fonts (siehe Abschnitt 3)
│
├── barcode.abler.tirol  → Pure Frontend · fetcht api.abler.tirol
├── pdf.abler.tirol      → Pure Frontend · fetcht api.abler.tirol
├── klara.abler.tirol    → Eigenständiges Fullstack-Produkt (eigenes Backend + DB)
└── [weitere Produkte]
```

### Produkt-Typen

| Typ | Beschreibung | Beispiele |
|---|---|---|
| **Pure Frontend** | Statisches Frontend, kein eigenes Backend. Alle Daten kommen von `api.abler.tirol`. | `barcode`, `pdf` |
| **Fullstack** | Eigenes Backend, eigene Datenbank, eigene Auth. API-unabhängig. | `klara` |
| **API + Minimal-Frontend** | Backend mit schlanker eigener UI (Docs, Status, Playground). | `api` |
| **Landing** | Statische Seite, kein API-Zugriff nötig. | `abler.tirol` |

### CORS-Policy (`api.abler.tirol`)

```
Access-Control-Allow-Origin: *
```

Die API ist **öffentlich nutzbar** – kein CORS-Blocking für Frontends oder externe Entwickler. Rate-Limiting und API-Key-Pflicht für sensible Endpunkte bleiben davon unberührt.

### Git-Repositories

Jede Subdomain ist ein **eigenständiges Git-Projekt**. Es gibt kein Monorepo.

```
github.com/simonabler/abler-tirol        → abler.tirol (Landing)
github.com/simonabler/api-abler-tirol    → api.abler.tirol (Backend + Font-Server)
github.com/simonabler/barcode-abler-tirol → barcode.abler.tirol (Frontend)
github.com/simonabler/pdf-abler-tirol    → pdf.abler.tirol (Frontend)
github.com/simonabler/Klara              → klara.abler.tirol (Fullstack)
```

Geteilte Ressourcen (Fonts, Design Tokens) werden **nicht** als NPM-Package oder Git-Submodule verwaltet – sie werden über `api.abler.tirol` ausgeliefert und per URL referenziert.

---

## 3. Typografie

Typografie ist das stärkste Werkzeug für Wiedererkennung. Alle Subdomains verwenden dieselbe Schriftfamilie – in unterschiedlichen Gewichtungen je nach Charakter des Produkts.

### Schriftfamilien

| Rolle | Familie | Verwendung |
|---|---|---|
| **Display / Headlines** | `DM Serif Display` | Große Überschriften, Hero-Titel |
| **Interface / Body** | `Inter` | Fließtext, UI-Elemente, Labels |
| **Code / Monospace** | `DM Mono` | Terminal, Code, Tags, Badges, technische Labels |

### Self-Hosted Fonts via `api.abler.tirol`

Fonts werden **nicht von Google Fonts** geladen. Alle Font-Dateien liegen auf `api.abler.tirol` und werden von dort ausgeliefert. Das gilt für alle Subdomains ohne Ausnahme.

**Warum Self-Hosted:**
- Keine Datenweitergabe an Google (DSGVO-konform by default)
- Keine externe Abhängigkeit – Seiten funktionieren auch wenn Google Fonts nicht erreichbar ist
- Konsistente Ladezeiten, da Font-Server und API-Server identisch sind
- Volle Kontrolle über Caching-Header und Komprimierung

**Font-Endpunkt:**

```
https://api.abler.tirol/fonts/dm-serif-display.css
https://api.abler.tirol/fonts/inter.css
https://api.abler.tirol/fonts/dm-mono.css
```

Oder als kombinierter Einzel-Import:

```
https://api.abler.tirol/fonts/abler-stack.css
```

**Einbindung in allen Projekten (HTML):**

```html
<link rel="preconnect" href="https://api.abler.tirol" />
<link rel="stylesheet" href="https://api.abler.tirol/fonts/abler-stack.css" />
```

**`abler-stack.css` liefert (Beispiel-Struktur):**

```css
/* DM Serif Display */
@font-face {
  font-family: 'DM Serif Display';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url('https://api.abler.tirol/fonts/files/dm-serif-display-400.woff2') format('woff2');
}
@font-face {
  font-family: 'DM Serif Display';
  font-style: italic;
  font-weight: 400;
  font-display: swap;
  src: url('https://api.abler.tirol/fonts/files/dm-serif-display-400-italic.woff2') format('woff2');
}

/* Inter */
@font-face {
  font-family: 'Inter';
  font-weight: 300 600;   /* Variable Font Range */
  font-display: swap;
  src: url('https://api.abler.tirol/fonts/files/inter-variable.woff2') format('woff2');
}

/* DM Mono */
@font-face {
  font-family: 'DM Mono';
  font-weight: 400;
  font-display: swap;
  src: url('https://api.abler.tirol/fonts/files/dm-mono-400.woff2') format('woff2');
}
@font-face {
  font-family: 'DM Mono';
  font-weight: 500;
  font-display: swap;
  src: url('https://api.abler.tirol/fonts/files/dm-mono-500.woff2') format('woff2');
}
```

> **Hinweis:** `font-display: swap` ist Pflicht – verhindert unsichtbaren Text während des Ladens.

### Font-Regeln

- **Headings** verwenden `DM Serif Display` mit `font-weight: 400` (normal) oder Italic für Betonung
- **Body-Text** verwendet `Inter` mit `font-weight: 300` (light) für Fließtext, `400` für Labels, `500–600` für Aktionselemente
- **Tags, Badges, Code-Snippets** verwenden immer `DM Mono`
- **Keine System-Fonts** (`Arial`, `system-ui`, `Roboto`) in Produktoberflächen
- **Letter-Spacing** für Eyebrows / Labels: `0.18–0.24em`, immer `uppercase`
- **Zeilenhöhe** Fließtext: `1.7–1.8`, Headlines: `1.05–1.15`

### Größenraster (Richtwerte)

```
Display:   clamp(3rem, 8vw, 6rem)
H1:        clamp(2.2rem, 5vw, 3.75rem)
H2:        clamp(1.8rem, 3.5vw, 3rem)
H3:        1.25rem – 1.5rem
Body:      0.95rem – 1.05rem
Small:     0.8rem – 0.88rem
Label:     0.7rem – 0.75rem (monospace, uppercase)
```

---

## 4. Farbe

### Prinzip: geteilte Struktur, eigene Identität

Alle Produkte teilen dieselben **neutralen Farben** (Hintergrund, Text, Borders) und dasselbe **Farbsystem**. Was variiert, ist die **Akzentfarbe** und die **Primärpalette** jeder Subdomain.

### Geteilte Neutrals (alle Produkte)

```css
--white:      #ffffff
--bg-light:   #f7f7f4   /* Helles Off-White, kein reines Weiß */
--bg-subtle:  #fbfbf9   /* Cards, subtle backgrounds */
--ink:        #0f172a   /* Haupttext, Buttons dark */
--ink-2:      #475569   /* Body-Text, Descriptions */
--ink-3:      #94a3b8   /* Labels, Placeholders, Muted */
--border:     #e2e8f0   /* Alle Borders, Divider */
--border-sub: rgba(226,232,240,0.7)
```

### Akzentfarben pro Subdomain

Jede Subdomain bekommt eine **primäre** und eine **sekundäre** Identitätsfarbe. Sie werden verwendet für:
- Gradient-Tops auf Cards
- Aktive Zustände / CTAs
- Tags und Badges mit Produkt-Bezug
- Hover-Akzente

---

#### `abler.tirol` — Neutral / Anker

```css
--accent-primary:   #0f172a   /* Slate 900 – dunkel, neutral */
--accent-secondary: #334155   /* Slate 700 */
```

Charakter: sachlich, übergeordnet, verbindend. Kein starker Farbakzent – die Subdomains bringen Farbe.

---

#### `api.abler.tirol` — Blue-Slate / Tech-Dark

```css
--accent-primary:   #0f172a   /* Slate 900 */
--accent-secondary: #1e3a5f   /* Deep Blue-Slate */
--accent-highlight: #5bffc3   /* Terminal Green – Code, Cursor, Live-Indikatoren */
--accent-code:      #3b8fff   /* Code Blue – Syntax-Highlighting */
--bg-dark:          #0b0d11   /* Hero / Terminal backgrounds */
```

Charakter: technisch, präzise, terminal-nah. Dunkles Hero. `DM Mono` dominiert sichtbarer als bei anderen Produkten.

---

#### `barcode.abler.tirol` — Amber / Industrie

```css
--accent-primary:   #78350f   /* Amber 900 */
--accent-secondary: #92400e   /* Amber 800 */
--accent-highlight: #f59e0b   /* Amber 500 – Scan-Indikator, aktive Zustände */
--accent-light:     #fef3c7   /* Amber 100 – subtile Hintergründe */
```

Charakter: industriell, präzise, physisch-nah. Erinnert an Etiketten, Scanner, Lagerlogistik. Helles Layout mit Amber-Akzenten.

---

#### `pdf.abler.tirol` — Indigo / Büro

```css
--accent-primary:   #1e1b4b   /* Indigo 950 */
--accent-secondary: #312e81   /* Indigo 900 */
--accent-highlight: #6366f1   /* Indigo 500 – aktive Elemente */
--accent-light:     #eef2ff   /* Indigo 50 – subtile Hintergründe */
```

Charakter: professionell, büro-nah, vertrauenswürdig. Für Notare, Verwaltung, Lehrkräfte. Ruhiger als api, formaler als klara.

---

#### `klara.abler.tirol` — Emerald / Menschlich-Warm

```css
--accent-primary:   #064e3b   /* Emerald 900 */
--accent-secondary: #065f46   /* Emerald 800 */
--accent-highlight: #10b981   /* Emerald 500 – aktive Elemente, Icons */
--accent-light:     #ecfdf5   /* Emerald 50 – subtile Hintergründe */
```

Charakter: ruhig, warm, menschlich. Betont Vertrauen und Datenschutz. Helles Layout, Serif-Titel (kursiv), wenig technischer Jargon.

---

### Farbregeln (alle Produkte)

1. **Maximal zwei Akzentfarben** pro Seite gleichzeitig sichtbar – primary und highlight.
2. **Kein reines Schwarz** (`#000000`) oder reines Weiß (`#ffffff`) als Hintergrund – immer `--bg-light` oder `--bg-subtle`.
3. **Kein Lila oder violettes Gradient auf Weiß** – dieser Look wird aktiv vermieden (generisch).
4. **Akzentfarbe als Gradient** nur für Card-Tops und Hero-Elemente, nicht für Fließtext-Hintergründe.
5. **Dark Mode**: wird pro Subdomain optional eingeführt. `api` hat einen dauerhaften Dark Hero. Für andere Produkte gilt: light-first.

---

## 5. Layout & Spacing

### Grundraster

- **Max-Width Content**: `72rem` (`max-w-6xl`)
- **Seitenabstand**: `1.5rem` Mobile, `2.5rem` Tablet, automatisch bei großem Viewport
- **Section-Padding**: `5rem` vertikal (Desktop), `3rem` Mobile

### Spacing-Skala

```
4px   — Intra-Element (Icon zu Text)
8px   — Zwischen kleinen Elementen (Tags, Badges)
12px  — Kompakte Abstände
16px  — Standard-Gap
24px  — Zwischen Gruppen
32px  — Zwischen Sektionen innerhalb einer Section
48px  — Zwischen großen Blöcken
80px  — Zwischen Sections (Desktop)
```

### Border Radius

```
999px    — Buttons, Badges, Pills (immer rund)
0.5rem   — Kleine Tags, Code-Snippets
1rem     — Kleine Cards
1.5rem   — Mittlere Cards, Inputs
2rem     — Große Cards, Hero-Widgets (Haupt-Radius)
```

---

## 6. Komponenten

### Buttons

| Typ | Verwendung | Stil |
|---|---|---|
| **Primary** | Haupt-CTA | `background: --accent-primary`, `color: white`, `border-radius: 999px` |
| **Outline** | Sekundär-Aktion | `background: white`, `border: 1px solid --border`, `color: --ink-2` |
| **Ghost** | Tertiär / Navigation | Kein Border, kein Background, `color: --ink-2` |

Buttons haben **immer** `border-radius: 999px` (Pill-Form). Keine eckigen Buttons.

### Cards

- **Light Card**: `background: white`, `border: 1px solid --border`, `border-radius: 2rem`, `box-shadow: 0 1px 3px rgba(15,23,42,0.06)`
- **Dark Card**: `background: --accent-primary` (subdomain-spezifisch), `color: white`, gleicher Radius

Hover-Zustand immer: `transform: translateY(-4px)` + verstärkter Shadow.

### Tags & Badges

```css
/* Standard Tag */
border: 1px solid var(--border);
color: var(--ink-2);
font-family: 'DM Mono', monospace;
font-size: 0.73rem;
padding: 0.28rem 0.75rem;
border-radius: 999px;

/* Eyebrow Label */
font-family: 'DM Mono', monospace;
font-size: 0.72rem;
letter-spacing: 0.18em;
text-transform: uppercase;
color: var(--ink-3);
```

### Navigation

- Sticky, `z-index: 50`
- Hintergrund: `linear-gradient(white → bg-light)` + `backdrop-filter: blur` beim Scrollen
- Logo: `DM Mono`, `uppercase`, `letter-spacing: 0.24em`
- Sprach-Toggle: Pill-Form, `DM Mono`, Dark-Active-State
- Max. 4–5 Einträge

### Formularelemente

- `border-radius: 0.75rem`
- `border: 1px solid var(--border)`
- Focus: `outline: 2px solid var(--accent-highlight)`, `outline-offset: 2px`

---

## 7. Animationen

Animationen dienen der **Orientierung**, nicht der Unterhaltung.

### Erlaubte Animationen

```css
/* Page Load – Hero-Elemente mit Stagger */
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(18px); }
  to   { opacity: 1; transform: translateY(0); }
}
/* Stagger: je 0.05s – 0.15s zwischen Elementen */

/* Hover – Cards */
transition: transform 0.25s ease, box-shadow 0.25s ease;
/* transform: translateY(-4px) */

/* Hover – Buttons */
transition: background 0.18s, transform 0.15s;
/* transform: translateY(-1px) */

/* Hover – Arrow-Links */
transition: gap 0.2s;
/* gap: 0.35rem → 0.65rem */

/* Terminal Cursor (nur api.abler.tirol) */
@keyframes blink { 50% { opacity: 0; } }
animation: blink 1.1s step-end infinite;
```

### Verboten

- Scroll-basierte Parallax-Effekte
- Bounce- oder Elastic-Easing
- Animationen auf reinen Text-Paragraphen
- `animation-duration > 0.7s` für UI-Feedback

---

## 8. Zweisprachigkeit (DE / EN)

Alle Subdomains sind standardmäßig **zweisprachig** (Deutsch / Englisch).

### Implementierung

```html
<body class="de"> <!-- oder "en" -->

<!-- Blockelemente -->
<p data-lang="de">Deutscher Text</p>
<p data-lang="en">English text</p>

<!-- Inline -->
<span data-lang="de">Projekte</span>
<span data-lang="en">Projects</span>
```

```css
[data-lang],
span[data-lang]                  { display: none !important; }

body.de [data-lang="de"],
body.de span[data-lang="de"]     { display: revert !important; }

body.en [data-lang="en"],
body.en span[data-lang="en"]     { display: revert !important; }

/* Inline-Spans brauchen explizit inline */
body.de span[data-lang="de"]     { display: inline !important; }
body.en span[data-lang="en"]     { display: inline !important; }
```

```js
function setLang(lang) {
  document.body.className = lang;
  document.documentElement.lang = lang; // <html lang=""> mitsetzen
  document.querySelectorAll('.lang-toggle button').forEach((btn, i) => {
    btn.classList.toggle('active', (i === 0 && lang === 'de') || (i === 1 && lang === 'en'));
  });
}
```

### Regeln

- Standardsprache ist **Deutsch** (`<body class="de">`)
- Der Toggle ist immer **oben rechts**, Pill-Form, `DM Mono`
- Keine automatische Spracherkennung via Browser – der Nutzer wählt bewusst
- Übersetzungen sind inhaltlich äquivalent, nicht wörtlich – Ton und Kürze passen sich an
- `<html lang="">` wird via JavaScript aktualisiert

---

## 9. Produktcharakter-Tabelle

| | `abler.tirol` | `api` | `barcode` | `pdf` | `klara` |
|---|---|---|---|---|---|
| **Farbwelt** | Neutral Slate | Dark Slate + Terminal Green | Amber + Industrial | Indigo + Office | Emerald + Warm |
| **Hero-Stil** | Hell, ausgewogen | Dark Hero + Terminal | Hell + Amber-Akzent | Hell + Indigo-Akzent | Hell, viel Weißraum |
| **Typografie-Gewicht** | Ausgewogen | Mono-lastig | Serif + Sans | Sans-dominant | Serif-dominant (kursiv) |
| **Primäre Zielgruppe** | Alle / Überblick | Developer | Logistik, Handel | Büro, Verwaltung | Lehrkräfte |
| **Ton** | Klar, übergeordnet | Technisch, präzise | Direkt, industriell | Professionell, sachlich | Ruhig, menschlich |
| **Backend** | Nein (static) | Ja (NestJS) | Nein (Pure Frontend) | Nein (Pure Frontend) | Ja (eigenes NestJS + DB) |
| **API-Abhängigkeit** | Nein | — (ist die API) | `api.abler.tirol` | `api.abler.tirol` | Keine |
| **Terminal-Widget** | Nein | Ja | Nein | Nein | Nein |
| **Serif Italic im Hero** | Ja (Akzent) | Nein | Nein | Nein | Ja (Haupttitel) |

---

## 10. Was aktiv vermieden wird

- ❌ Fonts von Google Fonts – immer `api.abler.tirol/fonts/`
- ❌ Lila / Violette Gradienten auf weißem Hintergrund
- ❌ System-Fonts (`Arial`, `Roboto`, `system-ui`) in Produktoberflächen
- ❌ Eckige Buttons – immer Pill-Form (`border-radius: 999px`)
- ❌ Reines Schwarz (`#000`) als Textfarbe – immer `--ink` (`#0f172a`)
- ❌ Mehr als zwei gleichzeitig sichtbare Akzentfarben
- ❌ `animation-duration > 0.7s` für UI-Feedback
- ❌ Scroll-Hijacking oder Parallax
- ❌ Dunkle Muster (versteckte Checkboxen, Fake-Urgency, irreführende CTAs)
- ❌ Überfüllte Navigation (max. 4–5 Einträge)
- ❌ Hardcodierte Farbwerte in HTML/Templates – alle Werte über CSS-Variablen

---

## 11. Repository-Übersicht

```
github.com/simonabler/
├── abler-tirol           → abler.tirol          (Static Landing)
├── api-abler-tirol       → api.abler.tirol       (NestJS · REST-API · Font-Server)
├── barcode-abler-tirol   → barcode.abler.tirol   (Pure Frontend · fetcht api)
├── pdf-abler-tirol       → pdf.abler.tirol       (Pure Frontend · fetcht api)
└── Klara                 → klara.abler.tirol     (Fullstack · NestJS + PostgreSQL)
```

### Geteilte Ressourcen (werden nicht kopiert, sondern referenziert)

| Ressource | Quelle | Eingebunden via |
|---|---|---|
| Fonts (woff2-Dateien) | `api.abler.tirol` | `<link rel="stylesheet" href="https://api.abler.tirol/fonts/abler-stack.css">` |
| Design Tokens (optional) | Dieses Dokument | Manuell pro Projekt als CSS-Variablen |

> Design Tokens werden **nicht** als geteiltes NPM-Package verwaltet. Jedes Projekt implementiert die CSS-Variablen aus diesem Dokument selbst. Das hält die Repos unabhängig und deploybar ohne externe Abhängigkeiten außer den Fonts.

---

*Stand: 2026 · Simon Abler · abler.tirol*
