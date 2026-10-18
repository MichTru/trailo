# Trailo 2.0 · revisione 5: percorsi tuoi, meteo, energia, bacheca

Trailo 2.0 per ciclismo e running.

La revisione 5 aggiunge:
- percorsi personalizzati, condivisibili;
- meteo in Home e "cosa portare" (acqua, cibo, carboidrati, gel, sali);
- report calorico;
- foto e audio in chat;
- bacheca "social mode": post, like, commenti, repost, tag e profili.

Restano tutte le funzioni della revisione 4: mappa reale, percorsi famosi, natura, cosa c'è lungo il percorso, amici, chat ed eventi.

**L'app pubblicata oggi non viene toccata.** Questa versione usa lo stesso progetto Supabase per account e Community.

## 1. Avvio

- **GitHub Pages (consigliato):** https://michtru.github.io/trailo/ una volta attivato Pages nel repository (Settings → Pages → Branch `main`, cartella `/ (root)`).
- **Netlify Drop:** trascina la cartella `trailo-prototipo-rev5` (quella con `index.html` e `assets/`) su app.netlify.com/drop. È il modo consigliato: mappe, ricerca e Community richiedono HTTPS e connessione.
- **In locale:** dalla cartella esegui `python3 -m http.server 8080`, poi apri `http://localhost:8080`.
- **Account:** se in Supabase è attiva la conferma via email, il link di conferma porta al "Site URL" impostato in Supabase → Authentication. Va impostato sull'indirizzo da cui apri l'app (GitHub Pages o Netlify).
- **Strumenti del prototipo** (Profilo, in alto a destra, poi in fondo alla pagina): modalità dimostrativa, intro, onboarding, design system, ricomincia da capo.

## 2. Novità della revisione 5

**Percorsi personalizzati** (Esplora → "I tuoi percorsi" → "Crea un percorso").
- Tocchi la mappa per aggiungere le tappe, in ordine.
- Il tracciato viene calcolato da BRouter su strade e sentieri OpenStreetMap, con distanza, salita e durata stimata.
- Scegli che strade preferire:
  - bici: strada veloce, strade tranquille, anche sterrato;
  - corsa: strada o sentieri.
- Comandi:
  - tocca un numero per togliere quella tappa;
  - "Togli l'ultima", "Torna alla partenza" (anello), "Ricomincia";
  - "Vicino a me" e ricerca di un luogo.
- Il percorso salvato ha tutto quello dei percorsi famosi: mappa, altimetria, "Lungo il percorso", GPX, Google Maps, simulazione e registrazione.
- Puoi modificare le tappe o eliminarlo.
- Resta **sul telefono** (memoria del browser), come hai scelto.
- **Condivisione:**
  - link (con "Condividi" del telefono, se presente);
  - in chat a un amico;
  - in bacheca;
  - in un evento.
- Si condividono nome e tappe: chi lo apre vede lo stesso tracciato e può "Salvarlo nei suoi percorsi". Il link funziona anche senza account.
- Se BRouter non risponde, il percorso si salva con le sole tappe e la linea tratteggiata è dichiarata "non è una strada".

**Meteo in Home** (Open-Meteo, gratuito e senza chiave).
- Condizioni attuali e prossime ore.
- Posizione usata: il centro della mappa di Esplora, oppure la tua posizione se tocchi "Usa la mia posizione" (chiesta solo allora).
- Sotto, il riepilogo per la proposta del giorno se parti adesso: acqua, carboidrati, gel, calorie.

**Cosa portare** (Home → "Tutto l'occorrente", oppure dal dettaglio di un percorso).
- Parti da un percorso (proposto, tuo o famoso) o da una durata, poi scegli l'ora di partenza.
- L'app prende il meteo previsto lungo l'uscita nel punto di partenza e calcola:

| Voce | Regola usata |
|---|---|
| Acqua | 0,4–1 litro all'ora secondo temperatura percepita e umidità; borracce da 750 ml; se è più di quanto si porta, consiglia una sosta |
| Carboidrati durante | fino a 1 ora: niente; 1–2,5 ore: 30–60 g all'ora; oltre: 60–90 g all'ora in bici, 60–75 di corsa (oltre 60 solo se già provato) |
| Gel, barrette, banane | gel ≈ 25 g, barretta ≈ 40 g, banana ≈ 25 g |
| Sali minerali | sopra le 2 ore o con caldo: 300–600 mg di sodio per litro |
| Integratori | nessun altro integratore consigliato; per esigenze personali, medico o nutrizionista |
| Prima e dopo | colazione o pasto secondo l'ora di partenza; recupero con carboidrati e proteine |
| Abbigliamento | freddo, fresco, caldo, pioggia, vento, sole (indice UV) |
| Luci | se parti prima dell'alba o finisci dopo il tramonto |
| Attrezzatura | bici: casco e kit riparazione; corsa: cintura per acqua e gel nelle uscite lunghe |

- L'elenco è spuntabile.
- Le indicazioni sono dichiarate generali, per adulti in salute, ispirate alle linee guida di nutrizione sportiva (ACSM, IOC). **Non sono un consiglio medico.**

**Report calorico** (nel dettaglio di ogni percorso, nella pagina "Cosa portare" e nel dettaglio di ogni attività registrata). Mostra:
- calorie totali con margine ±20%;
- calorie per km e all'ora;
- carboidrati da assumere durante, e quale parte del consumo coprono;
- per le attività già fatte, cosa assumere per recuperare.

Calcolo:

| Sport | Formula |
|---|---|
| Corsa | circa 1 kcal per kg per km |
| Bici | MET dalla velocità media (Compendium of Physical Activities) × peso × ore |
| Entrambi | più il lavoro della salita (peso, più 9 kg di bici, × dislivello, con rendimento del 24%) |

Il peso si indica nel Profilo o nella pagina "Cosa portare". Resta nel browser e non va sul server. Senza peso l'app usa 70 kg e lo dice.

**Chat con foto e audio.**
- Foto:
  - dalla galleria o dalla fotocamera;
  - ridotte a 1600 px e ricodificate prima dell'invio, così si tolgono anche i dati di posizione dello scatto;
  - si aprono a schermo intero.
- Messaggi vocali:
  - pulsante microfono, registrazione con tempo, "Annulla" o "Invia";
  - massimo 2 minuti;
  - il microfono viene chiesto solo allora.
- Percorsi: pulsante percorso; chi lo riceve lo apre con un tocco.
- I file stanno nello spazio privato "media" di Supabase:
  - ognuno può caricare solo nella propria cartella;
  - si leggono con link firmati che scadono dopo un'ora.

**Bacheca "social mode"** (Community → Bacheca, ora la prima sezione).
- Post con testo, foto e/o percorso.
- **Visibilità scelta per ogni post:** "Tutti" (chiunque abbia un account) oppure "Solo amici".
- **Tag:** tagghi gli amici che erano con te. Il taggato vede il post anche se è "solo amici", con la scritta "Ti ha taggato", e lo ritrova nel suo profilo; può togliersi il tag.
- **Mi piace**, **commenti** (l'autore del post può togliere i commenti ricevuti) e **ripubblicazione nel proprio profilo**, con un commento facoltativo. Un post "solo amici" si ripubblica solo per gli amici.
- Nella stessa bacheca compaiono le attività GPS che gli amici condividono, con l'applauso.
- Eliminando un post se ne vanno anche like, commenti, tag, ripubblicazioni e la foto.

**Profili.**
- Si aprono toccando nome o iniziale di una persona, oppure con "Il tuo profilo".
- Ogni profilo mostra:
  - numero di post, foto e tag;
  - le schede Post, Foto (griglia) e Taggato;
  - i pulsanti "Aggiungi agli amici", "Accetta" o "Scrivi".
- Di chi non è amico vedi solo i post pubblici.

**Eventi:** si può collegare un tuo percorso. Gli iscritti lo vedono e lo aprono dall'evento.

## 3. Database

**Revisione 5, applicata il 18 ottobre 2026** come hai scelto ("Applica direttamente"). Il file è `sql/2026-10-18_bacheca_media_percorsi.sql`, con due migrazioni:
- `trailo2_social_board_media_routes`;
- `trailo2_posts_select_inline`.

Sono solo aggiunte: nessuna tabella o regola esistente cancellata.

| Cosa | Dettaglio |
|---|---|
| Messaggi | nuovi campi per foto/audio e percorso; il file deve stare nella cartella di chi scrive |
| Eventi | campo per il percorso personalizzato |
| Tabelle nuove | `posts`, `post_likes`, `post_comments`, `post_tags` |
| Spazio `media` | privato, massimo 10 MB a file; solo immagini JPEG, PNG, WebP e audio WebM, MP4, MPEG, OGG, AAC |

Le regole di accesso sono state provate **sul database vero** con utenti reali (due non amici e un amico di entrambi), con prove annullate alla fine e nessun dato lasciato. 24 controlli, tutti riusciti:
- chi non è amico non vede il post "solo amici", i suoi tag, e non può mettere like, commentare o ripubblicarlo;
- l'amico lo vede, mette like e commenta;
- il post pubblico è visibile a tutti con un account, e si può ripubblicare;
- si possono taggare solo gli amici, e solo nei propri post;
- nessuno può pubblicare o mettere like a nome di altri;
- non si può allegare un file della cartella di un altro, né a un post né a un messaggio;
- post vuoti rifiutati;
- nello spazio `media` si carica solo nella propria cartella, chi ha un account legge, chi non ce l'ha non vede niente;
- chi non ha un account vede zero post.

Una prova ha trovato un errore, che ho corretto: pubblicare un post e riceverlo indietro falliva. La regola di lettura chiamava una funzione che non vede ancora la riga appena inserita. È stata riscritta per esteso (seconda migrazione).

Avvisi di sicurezza di Supabase dopo la modifica: nessuno nuovo. Restano due avvisi di prima:
- protezione delle password trapelate da attivare;
- due tabelle Strava, chiuse di proposito.

**Revisione 4** (eventi e chat di gruppo), applicata il 18 ottobre 2026: file `sql/2026-10-18_eventi_e_chat.sql`.

#### Dettaglio della modifica della revisione 4

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


## 4. Funzioni della revisione 4 (invariate)


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

## 5. Funzioni: stato, test e limiti

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
| Percorsi personalizzati e condivisione | Reale (BRouter, memoria del browser) | Automatico: tocchi sulla mappa, tappe tolte, anello, profilo di strade, salvataggio, modifica senza doppioni, GPX, simulazione, link aperto da un altro telefono, link rovinato, nome con codice HTML, BRouter assente | Il percorso vive in un solo browser: cancellando i dati del sito si perde (esportazione non ancora prevista) |
| Meteo e "cosa portare" | Reale (Open-Meteo) | Automatico con meteo simulato: valori mostrati, 1 h / 4 h, alba, caldo con pioggia e vento, peso, servizio assente | Regole generali, non personalizzate; previsione nel punto di partenza, non lungo tutto il tracciato |
| Report calorico | Stima con regola dichiarata | Automatico: 700 kcal per 10 km a 70 kg, 1750 kcal per 60 km a 24 km/h, salita | Margine ±20%; senza cardiofrequenzimetro o potenza non si può fare di meglio |
| Foto e audio in chat | Reale (Supabase Storage) | Automatico con server simulato: foto ridotta a 1600 px, cartella giusta, visibile all'altro, audio registrato (microfono finto di Chromium) e annullato, percorso in chat | Audio registrato su iPhone in formato MP4 e su Android/Chrome in WebM: verificare la riproduzione incrociata sui telefoni veri |
| Bacheca, like, commenti, repost, tag, profili | Reale (Supabase) | Automatico con tre utenti: post solo amici e pubblici, tag, like e tolto, commento, repost, repost vietato se non visibile, profili, griglia foto, Taggato, cancellazioni. Regole di accesso provate anche sul database vero | Nessuna notifica push: novità visibili aprendo l'app; nessuna segnalazione o blocco di utenti |
| Tutto quanto della revisione 3 (intro, onboarding, Move, GPS, archivio, Progressi, layout) | Come prima | Automatico, ripetuto | Vedi revisione 3 |

**Prove automatiche: 248, tutte riuscite** (69 nuove per la revisione 5). Il dettaglio è in `VERIFICA.md`.

In questo ambiente la rete esterna è bloccata. Mappe, BRouter, Overpass, Nominatim, Open-Meteo e Supabase (database e spazio per i file) sono stati simulati (`strumenti/mock.py`) per provare il comportamento dell'app. Le prove dicono che l'app usa correttamente le risposte di questi servizi e gestisce i loro errori. **Non dicono** che i servizi veri rispondano: va verificato aprendo l'app da GitHub Pages o Netlify. Nessun test su dispositivi fisici.

## 6. Problemi residui e cosa serve

- **Attivare GitHub Pages** (Settings → Pages → Branch `main`, `/ (root)`) e mettere il suo indirizzo come **Site URL in Supabase**, per le email di conferma.
- **Protezione delle password trapelate** in Supabase → Authentication (avviso di sicurezza aperto).
- **Prova reale dal telefono:**
  - mappa e satellite;
  - creare un percorso e aprirlo dal link su un altro telefono;
  - meteo in Home;
  - due account che si mandano foto e audio (iPhone ↔ Android);
  - un post con tag e commenti.
- **Moderazione:** con post pubblici servono una funzione "segnala" e "blocca utente" prima di aprire a persone sconosciute.
- **Foto pubbliche:** chiunque abbia un account e conosca il nome esatto di un file può leggerlo. I nomi sono casuali e non si possono elencare, ma per una privacy più stretta servirebbe una regola che controlli il post o il messaggio a cui il file appartiene.
- **Percorsi solo sul telefono:** se vuoi ritrovarli su più dispositivi servirà salvarli anche sul server (con il tuo ok).
- **Logo:** servono simbolo e wordmark ufficiali in SVG e un wordmark chiaro (come nella revisione 3).
- **Fotografie:** le immagini dei percorsi sono ancora illustrazioni generate, dichiarate tali. Con foto con licenza dei luoghi veri l'effetto migliorerebbe molto.
- **Privacy e GDPR:**
  - chat, foto, audio, post e profili sono dati personali sul server;
  - servono informativa e una funzione di cancellazione account (oggi va chiesta all'assistenza).
- **Dipendenze esterne:**
  - Google Fonts;
  - tessere OSM, Esri, OpenTopoMap, Waymarked Trails;
  - BRouter, Overpass, Nominatim, Open-Meteo (servizi gratuiti a uso moderato; Open-Meteo è gratuito per uso non commerciale);
  - Supabase.
- **Chiavi nel codice:** c'è solo la chiave pubblica "anon" di Supabase, la stessa dell'app attuale; le regole di accesso del database proteggono i dati. Nessun segreto.
- **Notifiche:** chat e bacheca si aggiornano ogni pochi secondi con l'app aperta. Non ci sono notifiche push con l'app chiusa.

## 7. Contenuto del pacchetto

- `index.html` e `assets/`: l'app.
- `LEGGIMI.md` e `VERIFICA.md`.
- `sql/`: modifiche del database (revisioni 4 e 5, entrambe applicate).
- `anteprime/`:
  - schermate della revisione 3 (numerate 01–22);
  - schermate della revisione 4 (30–41) e della revisione 5 (42–48), fatte con servizi simulati: lo sfondo a griglia sostituisce le tessere vere e la foto verde è un'immagine di prova.
- `strumenti/`:
  - sorgenti `src/` e `build.py`;
  - script degli asset (`logo_assets.py`, `illus.py`);
  - test (`t_full.py`, `t_tabbar.py`, `t_new.py`, `t_rev5.py`), servizi simulati (`mock.py`) e `verifica.py` che scrive VERIFICA.md.
