# Trailo 2.0 · Changelog

## Revisione 6 · 18 ottobre 2026: da prototipo avanzato a prodotto

Principio guida: immersiva nell'esplorazione, tecnica durante lo sport, elegante nell'analisi. Non ci sono funzioni nuove per fare numero: ho migliorato quelle che c'erano e tolto quello che non serviva.

### Diagnosi di partenza (audit della revisione 5)

Ho controllato 10 schermate su tre misure di iPhone: SE, 13/14 e Pro Max. Accanto alle schermate ho fatto controlli automatici:
- scorrimenti orizzontali;
- pulsanti sotto i 40 px;
- contrasti;
- errori in console.

| Gravità | Problema | Cosa è cambiato |
|---|---|---|
| Alta | Home con 8 blocchi in fila, nessuna azione chiaramente principale; per un nuovo utente, uno spazio "progressi" vuoto | Home ridisegnata attorno alla scheda "Oggi" |
| Alta | "Chiedi a Trailo" presente in tre schermate, ma l'IA non è collegata | Pulsanti tolti; l'assistente compare tra i collegamenti "non disponibili" del Profilo |
| Alta | Mappa di Esplora a metà schermo, poi un elenco lungo; segnaposto non collegati alle schede | Mappa a tutto schermo con pannello trascinabile, collegato ai segnaposto |
| Alta | Attività condivise con la traccia completa: partenza e arrivo, spesso casa | Avviso prima di condividere, partenza e arrivo nascosti, condivisione revocabile |
| Alta | Dati solo nel browser, senza ripristino e senza uso offline | Backup completo con ripristino, protezione dell'archivio, app che si apre senza rete, installabile |
| Media | Dettaglio percorso: sei pulsanti in colonna, azione principale in fondo | "Pedala/Corri" subito sotto i numeri, azioni secondarie in una riga |
| Media | Solo dissolvenze | Continuità scheda → dettaglio, pannello con inerzia, risposta al tocco |
| Media | Durante l'attività nessuna protezione dai tocchi in tasca | Blocco dei comandi con sblocco tenendo premuto |
| Media | Analisi della sessione solo per intertempi | Andamento di passo o velocità lungo il percorso, confronto tra periodi |
| Media | Community: non era chiaro chi vede cosa | Pannello "Chi vede cosa" sempre presente |
| Bassa | Pulsanti piccoli (meteo, "Sito", date dei record, maniglia), contrasti al limite, un bug grafico dei messaggi durante l'attività | Corretti |

### Home
- **Scheda "Oggi"** su fondo notte, l'unico elemento scuro della Home. Contiene:
  - data e meteo attuale (Open-Meteo);
  - titolo;
  - la **proposta del giorno con la forma del percorso disegnata come il tracciato del marchio**, che si traccia una volta all'apertura;
  - cosa portare se parti adesso: acqua, carboidrati, calorie;
  - l'azione principale **"Inizia un giro/una corsa"**, visibile senza scorrere anche su iPhone SE;
  - due azioni secondarie: "Trova percorsi" e "Cosa portare".
- **Nuovo utente:** tre righe "Con Trailo" che spiegano cosa fa l'app e portano alla sezione giusta. Nessun progresso vuoto o inventato, più un link alla modalità dimostrativa.
- **Utente abituale:** "Questa settimana" con obiettivo e ultima attività, tutti dati reali.
- Tolti dalla Home: il blocco Natura (resta in Esplora), le ore meteo dettagliate (spostate in "Cosa portare") e l'assistente non collegato.
- La regola della proposta resta dichiarata sotto la scheda.

### Esplora
- **Mappa a tutto schermo.** Ricerca in alto; livelli e "vicino a me" a destra; zoom a destra; attribuzioni sempre visibili.
- **Pannello sopra la mappa con tre altezze** (ridotto, metà, pieno):
  - si trascina con il dito, si apre con la maniglia (anche da tastiera) e si riduce toccando la mappa;
  - quando trascini, segue il dito e si aggancia con inerzia.
- **Selezione progressiva:**
  - toccando un percorso sulla mappa, il segnaposto diventa evidente, il pannello sale a metà, la scheda si evidenzia e il tracciato compare sulla mappa;
  - un secondo tocco apre il dettaglio.
- **Transizione scheda → dettaglio:** l'immagine della scheda diventa quella grande del percorso (View Transitions), e al ritorno torna sulla stessa scheda. Dove il browser non la supporta, o con "riduci movimento", il passaggio è diretto.
- **Filtri in una riga** scorrevole. In cima ci sono "Disegna un percorso" e "Consigliato"; i tuoi percorsi compaiono solo se ne hai.
- **Segnaposto più grandi**: 40 px.
- **Dettaglio percorso:**
  - "Pedala/Corri questo percorso" è subito sotto i numeri;
  - Condividi, Evento, GPX e Google Maps stanno in una riga di quattro pulsanti.

### Durante l'attività
- **Blocca i comandi.** Le metriche restano visibili. Pausa e Termina non rispondono finché non tieni premuto "sblocca" per circa un secondo; funziona anche da tastiera.
- Pausa e Termina sono più distanti (20 px).
- Corretto un difetto grafico: durante l'attività i messaggi a comparsa occupavano tutta l'altezza dello schermo.

### Progressi e analisi
- **Andamento del passo (corsa) o della velocità (bici) lungo il percorso**, con media mobile e linea della media.
  - È interattivo: tocco, trascinamento, frecce, Inizio, Fine.
  - Si disegna solo se ci sono abbastanza dati punto per punto; altrimenti lo dice.
- **Ultime 4 settimane contro le 4 precedenti**: km, attività, tempo, passo o media. Si calcola solo con almeno 2 attività per periodo; altrimenti dice quante ne mancano.
- Barre degli intertempi più larghe, scorrevoli quando sono tante.

### Community e privacy
- **"Chi vede cosa"** in cima alla Community: profilo, post, attività, eventi, chat e foto, posizione.
- **Condividere un'attività:**
  - prima ti dice chi la vedrà (solo amici) e cosa;
  - **nasconde partenza e arrivo**, togliendo i primi e gli ultimi 500 m (opzione attiva in partenza);
  - si può **togliere la condivisione** in qualsiasi momento.

### Dati e affidabilità
- **Backup completo** (Profilo → I tuoi dati):
  - contiene attività, percorsi tuoi, profilo e preferenze;
  - mostra la data dell'ultimo backup.
- **Ripristino** da un altro telefono o browser:
  - aggiunge quello che manca, senza doppioni e senza cancellare nulla;
  - con un file non valido o un archivio illeggibile, si ferma e lo spiega.
- **Protezione dell'archivio:** dopo il primo salvataggio Trailo chiede al browser di non cancellarlo (dove supportato). Su iPhone spiega il rischio di cancellazione di Safari e come evitarlo aggiungendo Trailo alla schermata Home.
- **Funziona senza rete:**
  - un service worker conserva l'app e le tessere di mappa già viste (al massimo 600);
  - un avviso dice cosa funziona offline e cosa no.
- **Installabile:** manifest, icone (dal simbolo originale, senza modifiche) e titolo per la schermata Home di iPhone e Android.

### Sistema visivo
- Il fondo chiaro è passato dal crema a un **grigio nebbia freddo** (#F3F5F4), più vicino a turchese e blu del marchio. Il logo non è cambiato: wordmark nero su fondo chiaro.
- Le etichette piccole non sono più TUTTE MAIUSCOLE, per una lettura più calma e una gerarchia più chiara.
- I pulsanti rispondono al tocco con una leggera compressione, disattivata con "riduci movimento".
- Il fondo scuro è riservato a due momenti: la scheda "Oggi" e l'attività in corso.

### Test
- **341 prove automatiche, tutte riuscite.** Di queste, 54 sono nuove per la revisione 6. Le prove precedenti sono state aggiornate dove l'interfaccia è cambiata.
- Le prove nuove coprono:
  - Home nuovo e abituale, e "riduci movimento";
  - pannello di Esplora (pulsante, mouse, dito, tastiera, tocco sulla mappa) e selezione progressiva;
  - transizione scheda → dettaglio e ritorno;
  - blocco comandi (tocco breve, pressione lunga, tastiera);
  - andamento della sessione e confronto tra periodi;
  - privacy della condivisione (oscuramento verificato sulla traccia inviata, revoca);
  - backup e ripristino (doppioni, file sbagliato);
  - avvio senza rete con il service worker e manifest;
  - tre misure di iPhone (scorrimenti orizzontali, comandi sotto i 40 px, pulsanti dell'attività sullo schermo);
  - i cinque scenari d'uso del brief, con i passaggi contati.

---

## Revisione 5 · 18 ottobre 2026
- Percorsi personalizzati, condivisibili con link, in chat, in bacheca e negli eventi.
- Elenco delle tappe con nomi e km.
- Percorso consigliato automatico: anello, andata e ritorno, da A a B.
- "Su che strade passa".
- Meteo e "cosa portare"; report calorico.
- Chat con foto, audio e percorsi.
- Bacheca con post, like, commenti, repost, tag e profili.
- Database: post, like, commenti, tag e spazio "media".

## Revisione 4
- Mappa reale (OpenStreetMap, satellite, rilievo) e percorsi famosi su BRouter.
- Natura: parchi, laghi, fiumi.
- Lungo il percorso.
- Account, amici, chat ed eventi (Supabase).

## Revisione 3
- Tre esperienze, logo originale, intro, onboarding onesto, archivio locale, GPS reale.
