# Trailo 2.0 · revisione 4: territorio e Community

Trailo 2.0 per ciclismo e running. Rispetto alla revisione 3 aggiunge:
- mappa reale (Italia e mondo, satellite);
- percorsi famosi;
- parchi, laghi e fiumi;
- cosa c'è lungo il percorso;
- account, amici, chat ed eventi.

**L'app pubblicata oggi non viene toccata.** Questa versione usa lo stesso progetto Supabase per account e Community.

## 1. Avvio

- **Netlify Drop:** trascina la cartella `trailo-prototipo-rev4` (quella con `index.html` e `assets/`) su app.netlify.com/drop. È il modo consigliato: mappe, ricerca e Community richiedono HTTPS e connessione.
- **In locale:** dalla cartella esegui `python3 -m http.server 8080`, poi apri `http://localhost:8080`.
- **Account:** se in Supabase è attiva la conferma via email, il link di conferma porta al "Site URL" impostato in Supabase → Authentication. Va impostato sull'indirizzo Netlify.
- **Strumenti del prototipo** (Profilo, in alto a destra, poi in fondo alla pagina): modalità dimostrativa, intro, onboarding, design system, ricomincia da capo.

## 2. Cosa c'è di nuovo

**Navigazione.**
- Barra in basso: Home · Esplora · Inizia · Progressi · Community, con l'incavo liquido.
- Il Profilo è nel pulsante in alto a destra.

**Esplora: mappa reale, senza librerie esterne né chiavi.**
- Tre sfondi:
  - Mappa (OpenStreetMap);
  - Satellite (Esri World Imagery, con i nomi dei luoghi);
  - Rilievo (OpenTopoMap).
- Due sovrapposizioni: rete delle **ciclovie segnalate** e **sentieri** (Waymarked Trails).
- Passaggi rapidi Italia / Mondo e "Vicino a me" (la posizione viene chiesta solo se tocchi il pulsante).
- Gesti: trascinamento, rotella, pizzico, doppio tocco, pulsanti + e −, frecce e +/− da tastiera.
- Lo sfondo scelto viene ricordato.

**Ricerca.**
- I percorsi famosi si cercano per nome o regione.
- I luoghi si cercano in tutto il mondo con Nominatim (al massimo una richiesta al secondo, risultati in cache).
- Scegliendo un luogo la mappa ci va sopra e passa a Natura.

**Percorsi famosi.** 18 percorsi (13 per bici, 5 per corsa), definiti da tappe reali. Il tracciato viene calcolato da BRouter su strade OpenStreetMap quando apri il percorso, e da quel momento distanza, salita, altimetria e durata stimata sono quelle del tracciato calcolato. Finché il calcolo non arriva, i valori sono "indicativi" e la mappa mostra le tappe unite da una linea tratteggiata, dichiarata "non è una strada". I percorsi:

| Sport | Zona | Percorsi |
|---|---|---|
| Bici | Alpi e Dolomiti | Stelvio, Sella Ronda, Mortirolo, Ghisallo |
| Bici | Romagna | Muraglione, Brisighella |
| Bici | Toscana | Crete Senesi |
| Bici | Ciclovie | Mincio, Adige, Dobbiaco–Lienz, Alpe Adria |
| Bici | Sud e isole | Etna, Campo Imperatore |
| Corsa | — | lungomare Rimini–Riccione, Riva–Torbole, Firenze, Appia Antica, Sentiero del Viandante |

**Natura.**
- Sempre disponibili: i 25 parchi nazionali italiani e 13 grandi laghi (naturali e artificiali), da un elenco curato con posizione indicativa.
- Avvicinando la mappa compaiono, da OpenStreetMap:
  - parchi regionali, riserve e aree protette (zoom 8+);
  - laghi e bacini artificiali (zoom 9+);
  - fiumi (zoom 10+).
- Ogni luogo ha la sua scheda:
  - mappa;
  - fonte;
  - link a Wikipedia e al sito, se presenti in OSM;
  - percorsi famosi entro 90 km;
  - cosa si trova entro 3 km;
  - indicazioni stradali;
  - "Crea un evento qui".

**Lungo il percorso.** Per ogni percorso, cerca in OpenStreetMap vicino al tracciato:

| Categoria | Cosa cerca | Distanza dal tracciato |
|---|---|---|
| Dormire | hotel, B&B, ostelli, campeggi, rifugi | entro 900 m |
| Mangiare | ristoranti, bar, gelaterie | entro 250 m |
| Acqua | fontanelle | entro 200 m |
| Bici | officine, noleggi, stazioni di riparazione | entro 300–400 m |
| Da vedere | panorami, musei, castelli | entro 500 m |

Ogni punto riporta:
- al km quanto si trova;
- a che distanza è dal tracciato;
- orari, sito e telefono quando presenti;
- il link "Apri in mappa".

Si filtra per categoria, e i punti compaiono anche sulla mappa. Dal percorso si apre il tracciato in Google Maps, si scarica il GPX o si crea un evento.

**Alloggi: solo dati aperti, come hai scelto.** Niente prezzi né disponibilità: per quelli servirebbe un accordo partner con Booking.

**Community (Supabase).**
- **Account:** registrazione e accesso con email e password. Gli altri vedono solo nome e zona, mai l'email.
- **Amici:** ricerca per nome, richiesta, accetta/rifiuta, rimozione con conferma.
- **Chat tra amici:** messaggi con conferma di lettura e avviso dei non letti sulla barra. Mentre la chat è aperta si aggiorna ogni 4 secondi; il resto della Community ogni 20 secondi, solo quando la pagina è visibile.
- **Eventi:**
  - creazione: titolo, data e ora, ritrovo, percorso famoso collegato (riempie da solo distanza e salita), visibilità **pubblica o solo amici**, posti massimi, note;
  - partecipazione e rinuncia, posti esauriti;
  - chat dell'evento, solo per iscritti e organizzatore;
  - indicazioni per il ritrovo, file per il calendario (.ics), eventi sulla mappa di Esplora;
  - annullamento da parte dell'organizzatore.
- **Attività condivise:** si condividono solo le registrazioni GPS reali, mai quelle simulate o dimostrative. Gli amici le vedono e possono applaudirle.

## 3. Database: modifica da approvare

Il file `sql/2026-10-18_eventi_e_chat.sql` contiene la modifica per:
- eventi pubblici o solo amici;
- punto di ritrovo, percorso collegato e posti massimi;
- chat di gruppo.

Sono solo aggiunte: le uscite che ci sono già diventano pubbliche e l'app attuale continua a funzionare.

**Applicata il 18 ottobre 2026**, in due migrazioni (`trailo2_events_part1_columns_and_chat` e `trailo2_events_part2_access_rules`). Le regole esistenti sono state modificate e rinominate invece che cancellate e ricreate.

Regole di accesso verificate sul database vero, con prove SQL annullate alla fine (nessun dato lasciato):
- chi non è amico non vede l'evento "solo amici", né i suoi iscritti, né la sua chat, e non può iscriversi;
- l'amico vede l'evento, si iscrive e legge la chat;
- l'evento pubblico è visibile a tutti con un account e ci si iscrive;
- quando i posti sono finiti l'iscrizione è bloccata;
- chi non è iscritto non legge né scrive nella chat;
- nessuno può creare, modificare o cancellare eventi a nome di altri;
- una visibilità non valida viene rifiutata;
- chi non ha un account vede zero uscite e zero messaggi.

Una differenza rispetto al file SQL: non ho tolto i permessi generici di "anon" sulla nuova tabella e sulle funzioni, perché quel comando veniva bloccato. Le regole di accesso restituiscono comunque zero righe a chi non ha un account.

## 4. Funzioni: stato, test e limiti

| Funzione | Stato | Test eseguito | Limite |
|---|---|---|---|
| Mappa reale: sfondi, satellite, ciclovie, sentieri, Italia/Mondo | Reale | Automatico con tessere simulate: caricamento, zoom, trascinamento, tastiera, livelli, memoria della scelta, errore tessere | Esri e OpenTopoMap: verificare i termini per un uso commerciale con molti utenti |
| Ricerca luoghi (Nominatim) | Reale | Automatico con servizio simulato: risultato, nessun risultato, servizio assente | Policy Nominatim: 1 richiesta al secondo |
| Percorsi famosi e tracciato (BRouter) | Reale | Automatico con servizio simulato: tracciato, durata coerente, altimetria collegata, errore | Tracciato ricalcolato: va controllato sul posto |
| Natura: parchi nazionali, grandi laghi | Elenco curato | Automatico | Posizione indicativa del centro, non il confine |
| Natura della zona (Overpass) | Reale | Automatico con servizio simulato: parchi, riserve, laghi, fiumi senza doppioni, filtri, errore | Dati OSM: completezza variabile |
| Lungo il percorso e intorno a un luogo | Reale | Automatico con servizio simulato: categorie, km, orari, sito, telefono, mappa, errore e Riprova | Nessun prezzo o disponibilità degli alloggi |
| GPX e Google Maps | Reale | Automatico: contenuto GPX, link con le tappe | Google Maps riceve al massimo 8 tappe intermedie |
| Account, amici, chat, eventi, attività condivise | Reale (Supabase) | Automatico con un **sostituto locale** di Supabase e tre utenti: registrazione, errori di accesso, amicizia, chat nei due sensi, letture, eventi pubblici e solo amici, posti esauriti, chat evento, .ics, annullamento, database non aggiornato, condivisione, applausi, uscita | **Non provato contro il server vero da qui** (rete esterna bloccata): va provato da Netlify dopo l'ok all'SQL |
| Tutto quanto della revisione 3 (intro, onboarding, Move, GPS, archivio, Progressi, layout) | Come prima | Automatico, ripetuto | Vedi revisione 3 |

**Prove automatiche: 179, tutte riuscite.** Il dettaglio è in `VERIFICA.md`.

In questo ambiente la rete esterna è bloccata. Mappe, BRouter, Overpass, Nominatim e Supabase sono stati simulati (`strumenti/mock.py`) per provare il comportamento dell'app. Le prove dicono che l'app usa correttamente le risposte di questi servizi e gestisce i loro errori. **Non dicono** che i servizi veri rispondano: va verificato aprendo l'app da Netlify. Nessun test su dispositivi fisici.

## 5. Problemi residui e cosa serve

- **Ok all'SQL** degli eventi (§3).
- **Site URL in Supabase** con l'indirizzo Netlify, per le email di conferma.
- **Prova reale da Netlify:**
  - mappa e satellite;
  - un percorso famoso;
  - "Lungo il percorso";
  - due account che si scrivono e creano un evento.
- **Logo:** servono simbolo e wordmark ufficiali in SVG e un wordmark chiaro (come nella revisione 3).
- **Fotografie:** le immagini dei percorsi sono ancora illustrazioni generate, dichiarate tali. Con foto con licenza dei luoghi veri l'effetto migliorerebbe molto.
- **Privacy e GDPR:**
  - chat e profili sono dati personali sul server;
  - servono informativa e una funzione di cancellazione account (oggi va chiesta all'assistenza).
- **Dipendenze esterne:**
  - Google Fonts;
  - tessere OSM, Esri, OpenTopoMap, Waymarked Trails;
  - BRouter, Overpass, Nominatim (servizi gratuiti a uso moderato);
  - Supabase.
- **Chiavi nel codice:** c'è solo la chiave pubblica "anon" di Supabase, la stessa dell'app attuale; le regole di accesso del database proteggono i dati. Nessun segreto.
- **Notifiche:** la chat si aggiorna ogni pochi secondi. Non ci sono notifiche push con l'app chiusa.

## 6. Contenuto del pacchetto

- `index.html` e `assets/`: l'app.
- `LEGGIMI.md` e `VERIFICA.md`.
- `sql/`: modifica del database da approvare.
- `anteprime/`:
  - schermate della revisione 3 (numerate 01–22);
  - schermate delle novità (30–41, fatte con servizi simulati: lo sfondo a griglia sostituisce le tessere vere).
- `strumenti/`:
  - sorgenti `src/` e `build.py`;
  - script degli asset (`logo_assets.py`, `illus.py`);
  - test (`t_full.py`, `t_tabbar.py`, `t_new.py`) e servizi simulati (`mock.py`).
