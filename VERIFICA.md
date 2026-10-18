# Rapporto di verifica · Trailo 2.0 rev. 6

Eseguita il 18 ottobre 2026 con Chromium headless (Playwright) su server locale. Script: `strumenti/t_full.py`, `strumenti/t_tabbar.py`, `strumenti/t_new.py`, `strumenti/t_rev5.py`, `strumenti/t_rev5b.py`, `strumenti/t_rev6.py`.

**Risultato: 341 prove, 341 riuscite, 0 fallite.**

La rete esterna non è raggiungibile da questo ambiente: tessere della mappa, BRouter, Overpass, Nominatim, Open-Meteo e Supabase (database e spazio per foto e audio) sono **simulati** (`strumenti/mock.py`). Le prove verificano come l'app usa le risposte e gestisce gli errori, non la disponibilità dei servizi reali. Microfono e registrazione audio usano il dispositivo finto di Chromium. Le prove "GPS (simulato)" usano posizioni inviate dal browser di test: **non sono prove sul campo**. Nessun test su dispositivi fisici.

Le regole di accesso del database (chi vede post, foto, like, commenti, tag) sono state provate a parte **sul database vero**, con prove SQL annullate alla fine: vedi LEGGIMI, §3.

## Scenari d'uso (simulati con prove automatiche, nessun utente reale)

| Scenario | Passaggi | Chiarezza | Possibili errori gestiti |
|---|---|---|---|
| 1. Nuovo utente inizia una corsa | 2 tocchi: "Inizia una corsa" nella scheda Oggi → "Avvia" | Azione principale visibile senza scorrere anche su iPhone SE | GPS negato, segnale debole o perso, attività troppo breve, salvataggio non riuscito |
| 2. Ciclista cerca un percorso vicino | 3 tocchi: Esplora → apri l'elenco (ordinato per vicinanza) → scheda; oppure tocco su un segnaposto (2 tocchi) | Mappa a tutto schermo, pannello con il numero dei risultati | Nessun risultato con i filtri, servizi non raggiungibili, tessere assenti |
| 3. Capire la difficoltà di un itinerario | 1 tocco dalla scheda | Distanza, salita, durata stimata, difficoltà e fondo in alto; poi tipi di strada e altimetria | Valori "indicativi" dichiarati finché BRouter non risponde |
| 4. Analizzare l'ultima attività | 1 tocco dalla Home | Numeri principali, andamento lungo il percorso, intertempi, confronto, energia | Dati insufficienti dichiarati, nessuna conclusione inventata |
| 5. Partecipare a un evento | 2 tocchi dalla Home con account: evento → "Partecipo" | Visibilità, posti, ritrovo e chat dell'evento | Posti esauriti, evento "solo amici", senza account |

## Cosa non è stato possibile verificare

- Uso su iPhone e Android veri: GPS all'aperto, schermo bloccato, luce del sole, Dynamic Island reale, tastiera reale. Le misure di iPhone sono emulate in Chromium (non Safari).
- Risposte dei servizi veri: tessere, BRouter, Overpass, Nominatim, Open-Meteo (simulati); Supabase solo per le regole del database (provate sul server).
- Riproduzione incrociata dei vocali tra iPhone (MP4) e Android/Chrome (WebM).
- Comportamento di Safari con il service worker e con la cancellazione dei dati dopo settimane senza visite.

## Prove

| Area | Prova | Esito | Dettaglio |
|---|---|---|---|
| Intro | Prima apertura: intro presente | OK |  |
| Intro | Intro completa termina da sola in 2–3 s | OK | 2523 ms dall'apertura |
| Intro | Asset del marchio separati, nessun ritaglio CSS | OK |  |
| Intro | Nessuna inversione automatica dei colori del logo | OK |  |
| Onboarding | Frase guida presente | OK |  |
| Onboarding | Senza scelta non si avanza (messaggio) | OK |  |
| Onboarding | Completato: preferenze salvate | OK | {'choice': 'both', 'level': 2, 'goal': 1, 'dataLevel': 2, 'weekly': {'run': 35, 'bike': 200}, 'skipped': False, 'weight': None} |
| Onboarding | Sport "Entrambi": selettore visibile | OK |  |
| Home | Nuovo utente: nessuno storico inventato | OK |  |
| Home | Obiettivo "gara" orienta la proposta (percorso più lungo) | OK |  |
| Home | Nessun nome o allenamento fisso; il meteo c'è solo se arriva da Open-Meteo, con la fonte | OK |  |
| Sport | Cambio sport: lessico ciclismo | OK |  |
| Intro | Pulsante Salta chiude l'intro | OK |  |
| Onboarding | Saltato: app usabile con valori neutri | OK | {'choice': 'both', 'level': 1, 'goal': None, 'dataLevel': 1, 'weekly': {'run': 20, 'bike': 120}, 'skipped': True, 'weight': None} |
| Intro | Ritorno entro 30 min: nessuna intro | OK | 127 ms |
| Intro | Ritorno dopo 30 min: intro breve | OK | 876 ms |
| Intro | Riduci movimento: logo fermo, poi app | OK | 712 ms, animazioni attive a 200 ms: 0 |
| Intro | Asset non caricabile: ingresso immediato | OK | 79 ms |
| Intro | Escape salta l'intro | OK |  |
| Filtri | run: fascia 0 ("Fino a 5 km") | OK | atteso firenze,garda, ottenuto firenze,garda |
| Filtri | run: fascia 1 ("Oltre 5 fino a 12 km") | OK | atteso appia,rimini, ottenuto appia,rimini |
| Filtri | run: fascia 2 ("Oltre 12 km") | OK | atteso viandante, ottenuto viandante |
| Filtri | bike: fascia 0 ("Fino a 30 km") | OK | atteso etna,ghisallo,imperatore,mortirolo,stelvio, ottenuto etna,ghisallo,imperatore,mortirolo,stelvio |
| Filtri | bike: fascia 1 ("Oltre 30 fino a 60 km") | OK | atteso alpeadria,brisighella,dobbiaco,mincio,muraglione,sellaronda, ottenuto alpeadria,brisighella,dobbiaco,mincio,muraglione,sellaronda |
| Filtri | bike: fascia 2 ("Oltre 60 km") | OK | atteso adige,crete, ottenuto adige,crete |
| Filtri | Confini: 5 km in "Fino a 5 km", 12 km in "Oltre 5 fino a 12" | OK |  |
| Filtri | Poco dislivello | OK | appia,garda / appia,garda |
| Filtri | Fondo misto | OK | appia,garda / appia,garda |
| Filtri | Zero risultati: stato vuoto con azione | OK |  |
| Filtri | Togli filtri ripristina l'elenco | OK |  |
| Ricerca | Per nome, senza maiuscole/minuscole | OK | appia |
| Ricerca | Il campo resta attivo durante la digitazione | OK |  |
| Ricerca luoghi | Luogo trovato (Nominatim) | OK |  |
| Ricerca luoghi | La mappa va sul luogo e passa a Natura | OK | [44.42000769656092, 11.909999999999968, 12.5] |
| Ricerca luoghi | Nessun luogo trovato: messaggio | OK |  |
| Dettaglio percorso | Nome, località, sport, distanza, dislivello, difficoltà, fondo, durata | OK | [] |
| Dettaglio percorso | Durata coerente con il passo dichiarato e il tracciato calcolato | OK | ['2 h 11 min', 'Stima a 6:00 /km in piano, più 1 min ogni 10 m di salita (livello Intermedio).', True] |
| Formati | Durate "45 min" e "1 h 12 min" | OK |  |
| Dettaglio percorso | Immagine dichiarata illustrativa | OK |  |
| Dettaglio percorso | Tracciato calcolato con fonte dichiarata | OK |  |
| Altimetria | Tocco: lettura e punto sulla mappa | OK | km 0,7 · 560 m |
| Altimetria | Da tastiera con le frecce | OK | 0,7 → 0,8 |
| Finestre | Ingresso: focus dentro la finestra | OK | goMove |
| Finestre | Sfondo inerte (shell e barra) | OK |  |
| Finestre | Tab e Maiusc+Tab restano nella finestra | OK |  |
| Finestre | Escape chiude e il focus torna al pulsante d'origine | OK |  |
| Funzioni non collegate | Nessun pulsante per l'assistente IA non collegato; dichiarato nel Profilo | OK |  |
| Attività | Simulazione dichiarata in modo persistente | OK |  |
| Attività | Le metriche si aggiornano | OK | 0.09242005755994898 |
| Attività | Sfondo inerte durante la registrazione | OK |  |
| Attività | Pausa: distanza e tempo fermi | OK | 0.092 km, 40 s |
| Attività | Ripresa: la distanza riparte | OK |  |
| Attività | Riquadro → metrica in grande | OK |  |
| Attività | Oltre la fine del percorso: si ferma all'arrivo | OK | 10.575 / 10.575 km |
| Attività | Dopo l'arrivo la distanza non cresce | OK |  |
| Attività | Termina chiede conferma | OK |  |
| Archivio | Salvata con id, sport, data, durata, distanza, fonte | OK | {'sport': 'run', 'source': 'sim', 'distanceKm': 10.575, 'movingSec': 68} |
| Archivio | Messaggio "salvata" dopo il salvataggio riuscito e avviso locale/non cloud | OK |  |
| Archivio | Si apre il dettaglio dell'attività salvata | OK |  |
| Grafici | Intertempi: barra più alta = km più veloce | OK | [369, 380, 368, 375, 376, 369, 381, 369, 380, 381, 377] → [98, 82, 99.5, 89.1, 87.7, 98, 80.6, 98, 82, 80.6, 86.2] |
| Archivio | Dopo il ricaricamento l'attività c'è ancora | OK |  |
| Coerenza | Home usa l'attività realmente più recente | OK |  |
| Coerenza | Dalla Home si apre il dettaglio corretto | OK |  |
| Coerenza | Home, Progressi e dettaglio con gli stessi totali | OK | home 10,6 · progressi 10,6 · dettaglio 10,6 |
| Coerenza | Dallo storico si apre il dettaglio corretto | OK |  |
| Progressi | Obiettivo modificabile; raggiunto senza testi negativi | OK | Questa settimana · 19 ott – 25 ott  10,6 di 1 km  Obiettivo raggiunto, con 9,58 km in più. Ottimo lavoro.  Modifica obie |
| Progressi | Barra selezionabile con dettaglio e storico filtrato | OK |  |
| Progressi | Record non calcolati senza dati sufficienti | OK |  |
| Sport | La corsa non appare nei progressi bici | OK |  |
| Archivio | Errore di salvataggio: avviso, nessun "salvata" | OK |  |
| Archivio | Errore: l'attività si può scaricare come file | OK |  |
| Archivio | Riprova dopo l'errore: salvata | OK |  |
| Attività | Troppo breve: chiede se salvare | OK |  |
| Attività | Scartata: non salvata, risorse liberate | OK |  |
| Attività | Ciclismo: velocità in grande, salita disponibile | OK |  |
| Sport | Archivi separati per sport | OK |  |
| Archivio | Backup JSON con tutte le attività | OK |  |
| Archivio | Eliminazione con conferma | OK |  |
| Preferenze | Quantità di dati cambia le metriche, il livello resta | OK | riquadri 3 → 5, livello 0 |
| Preferenze | Il livello cambia la stima di durata | OK | Stima a 5:00 /km in piano, più 1 min ogni 10 m di salita (livello Esperto). |
| Preferenze | Sport "Entrambi" dal Profilo mostra il selettore | OK |  |
| Demo | Modalità dimostrativa dichiarata e separata | OK |  |
| Grafici | Passo: a destra il più veloce (passo minore) | OK | ← più lenta · 6:18 /km 5:38 /km · più veloce → |
| Progressi | Suggerimento dichiarato basato su regole | OK |  |
| Home | Demo: banner e attività dimostrativa | OK |  |
| Integrazioni | Collegamenti marcati "Non disponibile nel prototipo" | OK |  |
| GPS (simulato) | Primo fix: stato "GPS buono" con precisione | OK | GPS buono · ±8 m Registrazione |
| GPS (simulato) | Rumore da fermo: nessuna distanza | OK | 0 |
| GPS (simulato) | Movimento di 120 m conteggiato | OK | 120 m |
| GPS (simulato) | Salto di 2 km in 1 s scartato | OK | Salto di posizione scartato (1998 m). |
| GPS (simulato) | Pausa/ripresa: nessuna distanza per lo spostamento in pausa | OK | 6 m dopo la ripresa |
| GPS (simulato) | Precisione 30 m: "GPS debole" | OK |  |
| GPS (simulato) | Precisione 80 m: punto non usato | OK |  |
| GPS (simulato) | Posizione ferma da oltre 15 s: "Segnale GPS perso" | OK | Segnale GPS perso Registrazione |
| GPS (simulato) | Recupero del segnale segnalato | OK |  |
| GPS (simulato) | Tempo da timestamp reali, pause escluse | OK | in movimento 48 s, totale 49 s |
| GPS (simulato) | Salvata come GPS reale con coordinate, precisione e tempi | OK | {'points': 33, 'avgAcc': 9, 'jumps': 1, 'segments': 3} |
| GPS (simulato) | Quota non fornita: salita "non disponibile" | OK |  |
| GPS (simulato) | Mappa reale: tessere non caricate, errore dichiarato e traccia visibile | OK | Mappa di base non disponibile: connessione assente o servizio bloccato. Linee e punti restano visibili. |
| GPS (simulato) | Risorse liberate al termine | OK |  |
| GPS (simulato) | Permesso negato: messaggio e alternativa | OK | Posizione negata Registrazione |
| GPS (simulato) | Passaggio alla simulazione | OK |  |
| Layout | 320×568: nessuno scorrimento laterale; Termina visibile | OK |  |
| Layout | 375×667: nessuno scorrimento laterale; Termina visibile | OK |  |
| Layout | 390×844: nessuno scorrimento laterale; Termina visibile | OK |  |
| Layout | 430×932: nessuno scorrimento laterale; Termina visibile | OK |  |
| Layout | 1280×800: nessuno scorrimento laterale; Termina visibile | OK |  |
| Layout | 844×390 orizzontale: controlli visibili | OK |  |
| Layout | Testo al 150% su 360×560: metriche scorrevoli, comandi sempre visibili | OK | {'scroll': True, 'lastVisible': True, 'stop': True} |
| Tastiera | Tutte le sezioni raggiungibili con Tab | OK | ['evolve', 'explore', 'home', 'kit', 'profile', 'social', 'start'] |
| Barra di navigazione | Cambio sezione: la sfera scende nell'incavo, scorre e risale sulla nuova voce | OK | inizio [13, -22, 1] · a metà [247, 22, 0] · fine [247, -22, 1] |
| Barra di navigazione | "Inizia" apre la finestra senza spostare la sfera | OK |  |
| Barra di navigazione | Riduci movimento: la sfera passa subito alla nuova voce | OK | dopo 330 ms [247, -22, 1] |
| Generale | Nessun errore JavaScript in tutte le prove | OK | [] |
| Mappa | Mappa a tessere caricata (OpenStreetMap) con attribuzione | OK | 6 tessere |
| Mappa | Percorsi famosi come punti sulla mappa | OK | 13 |
| Mappa | Zoom con il pulsante + | OK | 7 → 8 |
| Mappa | Trascinamento sposta la mappa | OK | [44.37, 11.900000000000034] → [44.566007282324854, 11.350683593750034] |
| Mappa | Comandi da tastiera (frecce, + e −) | OK |  |
| Mappa | Vista satellite con nomi dei luoghi | OK |  |
| Mappa | Rete delle ciclovie sovrapposta | OK |  |
| Mappa | Vista del mondo | OK |  |
| Mappa | Vista dell'Italia | OK |  |
| Mappa | Sfondo e sovrapposizioni ricordati | OK |  |
| Natura | Vista Italia: parchi nazionali e grandi laghi | OK | 38 luoghi |
| Natura | Zona: parchi regionali, riserve, laghi e fiumi da OpenStreetMap | OK | ['Fiume Senio', 'Parco regionale della Vena del Gesso Romagnola', 'Lago artificiale di prova', 'Riserva naturale di prova'] |
| Natura | Fiume con più tratti mostrato una volta sola | OK |  |
| Natura | Filtro laghi | OK | ['Lago artificiale'] |
| Luoghi | Dettaglio parco con fonte, Wikipedia e sito | OK |  |
| Luoghi | Cosa trovi intorno, per categoria | OK |  |
| Luoghi | Percorsi famosi vicini | OK |  |
| Lungo il percorso | Alloggi, ristoranti, acqua, officine e cose da vedere | OK | 8 |
| Lungo il percorso | Posizione lungo il tracciato e distanza dal tracciato | OK |  |
| Lungo il percorso | Orari, sito e telefono quando presenti | OK |  |
| Lungo il percorso | Filtro: solo dove dormire | OK | ['Hotel', 'Campeggio'] |
| Lungo il percorso | Punti anche sulla mappa | OK |  |
| Lungo il percorso | Link a Google Maps con le tappe | OK |  |
| Lungo il percorso | GPX scaricabile con il tracciato | OK |  |
| Servizi non disponibili | BRouter non risponde: linea tra le tappe dichiarata | OK |  |
| Servizi non disponibili | Overpass non risponde: messaggio e Riprova | OK |  |
| Servizi non disponibili | Valori indicativi dichiarati | OK |  |
| Servizi non disponibili | Natura: restano parchi nazionali e grandi laghi, errore dichiarato | OK | Dati della zona non disponibili (servizio non raggiungibile). Restano i parchi nazionali e i grandi laghi. |
| Servizi non disponibili | Ricerca luoghi non disponibile: messaggio | OK |  |
| Servizi non disponibili | Simulazione possibile anche senza tracciato, salita non disponibile | OK |  |
| Servizi non disponibili | Tessere della mappa non disponibili: messaggio, punti visibili | OK |  |
| Community | Senza account: spiegazione e accesso | OK |  |
| Community | Validazione del modulo di accesso | OK |  |
| Community | Credenziali errate: messaggio chiaro | OK | Email o password non corretti. |
| Community | Registrazione: profilo creato, sezioni visibili | OK |  |
| Amici e chat | Ricerca persone per nome | OK |  |
| Amici e chat | Richiesta di amicizia inviata | OK |  |
| Amici e chat | Richiesta ricevuta e segnalata nella barra | OK |  |
| Amici e chat | Richiesta accettata | OK |  |
| Amici e chat | Messaggio inviato | OK |  |
| Amici e chat | Messaggio non letto segnalato | OK |  |
| Amici e chat | Messaggio ricevuto | OK |  |
| Amici e chat | Risposta arriva nella chat aperta (aggiornamento ogni 4 s) | OK |  |
| Amici e chat | Messaggi segnati come letti | OK |  |
| Eventi | Validazione: titolo obbligatorio | OK |  |
| Eventi | Validazione: data passata rifiutata | OK |  |
| Eventi | Scegliendo un percorso si compilano distanza e salita | OK |  |
| Eventi | Evento pubblico creato con percorso, posti e punto di ritrovo | OK | {'visibility': 'public', 'route_ref': 'brisighella', 'max_people': 2, 'lat': 44.2858} |
| Eventi | Chat dell'evento per l'organizzatore | OK |  |
| Eventi | Evento "solo amici" invisibile a chi non è amico | OK |  |
| Eventi | Evento "solo amici" visibile all'amico | OK |  |
| Eventi | Chat nascosta finché non partecipi | OK |  |
| Eventi | Iscrizione e chat visibile | OK |  |
| Eventi | Posti esauriti: iscrizione disattivata | OK |  |
| Eventi | Aggiungi al calendario (.ics) | OK |  |
| Eventi | Eventi con ritrovo visibili sulla mappa di Esplora | OK |  |
| Eventi | L'organizzatore annulla l'evento con conferma | OK |  |
| Eventi | Database non aggiornato: "solo amici" spiegato, nessun salvataggio a metà | OK | Eventi "solo amici", posti massimi e percorsi tuoi richiedono l'aggiornamento del database non ancora applicato. |
| Eventi | Database non aggiornato: evento pubblico semplice creato comunque | OK |  |
| Attività condivise | Condivisione di un'attività GPS con gli amici | OK |  |
| Attività condivise | L'amico la vede nelle attività | OK |  |
| Attività condivise | Applauso | OK |  |
| Attività condivise | Chi non è amico non la vede | OK |  |
| Community | Uscita dall'account | OK |  |
| Meteo e occorrente | Home: meteo attuale da Open-Meteo nella scheda di oggi, con la fonte | OK | 18° Poco nuvoloso |
| Meteo e occorrente | Home: riepilogo di acqua, carboidrati e calorie per la proposta del giorno | OK | Se parti adesso: circa 1,7 l d'acqua · 210 g di carboidrati · ≈ 1.736 kcal |
| Meteo e occorrente | Cosa portare: prossime ore dalla partenza | OK |  |
| Meteo e occorrente | Pagina "Cosa portare": meteo dell'uscita, energia, occorrente per gruppi | OK | Colli di Brisighella e Modigliana34 km · 1234 m di salita · 2 h 48 min · dalle 01:54 alle 04:420218°10%0318°10%0418°10%0518°10%0618°10%0718°10%0818°10%0918°10%Poco nuvoloso · 19–19 °C percepitiPioggia |
| Meteo e occorrente | Un'ora: nessun carboidrato durante | OK |  |
| Meteo e occorrente | Quattro ore in bici: 60–90 g di carboidrati all'ora, barrette e gel, sali | OK | ["Carboidrati durante: 60–90 g all'ora, in tutto circa 300 g (≈1200 kcal)."] |
| Meteo e occorrente | Quattro ore: acqua oltre le borracce → consiglio di sosta | OK |  |
| Meteo e occorrente | Partenza prima dell'alba: luci e colazione presto | OK | ['buio o finisce dopo il tramonto (alle 21:30): luci anteriore e posteriore, giubbino riflettente.'] |
| Meteo e occorrente | Peso indicato: calorie ricalcolate e peso salvato solo nel browser | OK | 2800 → 3400 |
| Meteo e occorrente | Caldo, pioggia e vento: crema, impermeabile, antivento, più acqua e sali | OK | ["Acqua: circa 2,7 litri (0,9 l all'ora con 32 °C percepiti) · 4 borracce da 750 ml."] |
| Energia | Corsa: circa 1 kcal per kg per km (70 kg, 10 km → 700 kcal) | OK | 700 |
| Energia | Bici: MET dalla velocità (24 km/h → 10 MET; 70 kg, 2,5 h → 1750 kcal) | OK | 1750 |
| Energia | La salita aggiunge il lavoro meccanico (600 m) | OK | 2143 |
| Energia | Dettaglio percorso: calorie totali, per km, all'ora e carboidrati da assumere | OK | 1.755 kcal stimate (1.404–2.106) 49 kcal per km 612 kcal all'ora 215 g carboidrati da assumere durante (≈49% del consumo)  Dispendio dalla velocità media (12,5 km/h, Compendium of Physical Activities) |
| Energia | Dettaglio attività: report calorico e cosa assumere per recuperare | OK |  |
| Energia | Peso modificabile dal Profilo | OK |  |
| Meteo e occorrente | Open-Meteo non risponde: messaggio chiaro, occorrente comunque disponibile | OK |  |
| Meteo e occorrente | Senza meteo: elenco dichiarato come non basato sulle previsioni | OK |  |
| Percorsi personalizzati | Esplora: "Disegna un percorso" e "Consigliato" in cima all'elenco | OK |  |
| Percorsi personalizzati | Tocchi sulla mappa: tappe numerate | OK |  |
| Percorsi personalizzati | Tracciato calcolato da BRouter con distanza, salita e durata | OK | 12,5 km 1234 m di salita 1 h 54 min stimati Ciclabili e itinerari ciclabili 25% 3,1 km Strade secondarie tranquille 63% 7,8 km Strade provinciali 12% 1,6 km 3 tappe · tracciato calcolato da BRouter su OpenStreetMap |
| Percorsi personalizzati | Tocco su una tappa: viene tolta | OK |  |
| Percorsi personalizzati | "Togli l'ultima" | OK |  |
| Percorsi personalizzati | "Torna alla partenza" chiude l'anello | OK | 4 |
| Percorsi personalizzati | Scelta delle strade: ricalcolo con il profilo BRouter "anche sterrato" (predefinito: strade tranquille) | OK | ['https://brouter.de/brouter?lonlats=11.83923,44.40604\|11.92527,44.38780\|11.96214,44.34217\|11.83923,44.40604&profile=trekking&alternativeidx=0&format=geojson'] |
| Percorsi personalizzati | Salvato nel browser e aperto come percorso | OK | {'id': 'uw96ldt', 'sport': 'bike', 'name': 'Giro di prova', 'wp': [[44.40604, 11.83923], [44.3878, 11.92527], [44.34217, 11.96214], [44.40604, 11.83923]], 'wpn': ['Via 77, Lugo', 'Via 58, Lugo', 'Via 13, Lugo', 'Via 77, Lugo'], 'prof': 'trekking', 'km': 25.115, 'up': 1234, 'created': '2026-10-18T23: |
| Percorsi personalizzati | Dettaglio: tracciato, altimetria, cosa c'è lungo il percorso, energia | OK |  |
| Percorsi personalizzati | GPX del percorso tuo | OK |  |
| Percorsi personalizzati | Si può simulare/registrare sul percorso tuo | OK |  |
| Percorsi personalizzati | Dopo il ricaricamento resta tra i tuoi percorsi, anche sulla mappa | OK |  |
| Condivisione percorsi | Link di condivisione con le tappe | OK | 322 |
| Percorsi personalizzati | Modifica: l'editor riapre le tappe salvate (anello: partenza e arrivo in un solo segnaposto) | OK |  |
| Percorsi personalizzati | Modifica salvata al posto dell'originale (nessun doppione) | OK |  |
| Condivisione percorsi | Chi apre il link vede il percorso (anche se usa l'altro sport) | OK |  |
| Condivisione percorsi | "Salva nei miei percorsi" | OK |  |
| Condivisione percorsi | Link rovinato: messaggio, nessun errore | OK |  |
| Condivisione percorsi | Nome con codice HTML mostrato come testo (nessuna esecuzione) | OK |  |
| Percorsi personalizzati | BRouter non risponde: linea in linea d'aria dichiarata, si può salvare | OK |  |
| Percorsi personalizzati | Salvataggio con le sole tappe | OK |  |
| Bacheca | Bacheca è la prima sezione della Community | OK |  |
| Chat con foto e audio | Foto caricata nella cartella di chi la manda e inviata | OK | ['7877e8b4-32e3-459b-bfe0-dea8ee44fd31/mvehgasks4v993.jpg'] |
| Chat con foto e audio | Foto ridotta (max 1600 px) e ricodificata prima dell'invio | OK | (1600, 1067) |
| Chat con foto e audio | Foto visibile in chat con link firmato | OK |  |
| Chat con foto e audio | Messaggio vocale: registrazione con tempo, invio, file audio caricato | OK | (['7877e8b4-32e3-459b-bfe0-dea8ee44fd31/mvehgdlf0v85bk.webm'], '🎙 Messaggio vocale (0:01)') |
| Chat con foto e audio | Registrazione annullata: niente inviato | OK |  |
| Chat con foto e audio | Percorso mandato in chat (riconosciuto come percorso famoso) | OK |  |
| Chat con foto e audio | L'amico riceve foto, audio e percorso | OK |  |
| Chat con foto e audio | Dal messaggio si apre il percorso | OK |  |
| Bacheca | Post vuoto non pubblicato | OK |  |
| Bacheca | Anteprima della foto scelta | OK |  |
| Bacheca | Post con foto, amico taggato e visibilità "solo amici" | OK | {'visibility': 'friends', 'media_path': '7877e8b4-32e3-459b-bfe0-dea8ee44fd31/mvehgkph7zk0ml.jpg'} |
| Bacheca | Il post compare in bacheca con la foto | OK |  |
| Bacheca | Chi non è amico non vede il post "solo amici", vede quello pubblico | OK |  |
| Bacheca | L'amico taggato vede il post con "Ti ha taggato" | OK |  |
| Bacheca | Mi piace | OK |  |
| Bacheca | Togli il mi piace | OK |  |
| Bacheca | Commento | OK |  |
| Bacheca | Ripubblicazione nel proprio profilo con commento | OK |  |
| Bacheca | La ripubblicazione mostra il post originale | OK |  |
| Bacheca | Non si può ripubblicare un post che non si vede | OK |  |
| Profili | Profilo: numero di post, foto, taggato | OK | 2 post 1 foto 0 in cui sei taggato |
| Profili | Griglia delle foto del profilo | OK |  |
| Profili | Sezione "Taggato": i post in cui sei stato taggato | OK |  |
| Profili | Profilo di chi non è amico: solo i post pubblici e "Aggiungi agli amici" | OK |  |
| Profili | Il repost compare nel profilo di chi l'ha fatto | OK |  |
| Bacheca | L'autore del post può togliere un commento ricevuto | OK |  |
| Bacheca | Eliminazione del post: via anche like, tag e foto | OK |  |
| Eventi con percorso tuo | Evento creato con il percorso tuo allegato (tappe) | OK | {'v': 1, 'n': 'Anello del sabato', 's': 'bike', 'p': 'safety', 'k': 8.5, 'u': 1234, 'w': [[4440604, 1185152], [4435130, 1192527]], 'm': ['Via 77, Lugo', 'Via 22, Lugo']} |
| Eventi con percorso tuo | Gli altri vedono e aprono il percorso dell'evento | OK |  |
| Generale | Nessun errore JavaScript nelle prove della revisione 5 | OK | [] |
| Elenco delle tappe | Senza tappe: elenco vuoto spiegato | OK |  |
| Elenco delle tappe | Ogni tappa con nome della via e del paese (OpenStreetMap) e km lungo il percorso | OK | ['Via 77, Lugo', 'Via 49, Lugo', 'Via 4, Lugo'] |
| Elenco delle tappe | Freccia: la tappa cambia posto e il percorso si ricalcola | OK |  |
| Elenco delle tappe | Prima tappa non spostabile più su, ultima non più giù | OK |  |
| Elenco delle tappe | Tappa aggiunta da un luogo cercato, con il suo nome | OK | ['Via 77, Lugo', 'Via 4, Lugo', 'Via 49, Lugo', 'Bagnacavallo'] |
| Elenco delle tappe | Tappa tolta dall'elenco | OK |  |
| Elenco delle tappe | Tocco sul nome: la mappa va sulla tappa | OK |  |
| Tipi di strada | Editor: ripartizione per tipo di strada (km e %) | OK | 13,3 km 1234 m di salita 1 h 55 min stimati Ciclabili e itinerari ciclabili 25% 3,3 km Strade secondarie tranquille 63% 8,3 km Strade provinciali 12% 1,7 km 3 tappe · tracciato calcolato da BRouter su |
| Elenco delle tappe | Percorso salvato: tappe con nomi e km nel dettaglio | OK |  |
| Tipi di strada | Dettaglio percorso: "Su che strade passa" | OK |  |
| Elenco delle tappe | Chi riceve il link vede anche i nomi delle tappe | OK |  |
| Tipi di strada | Anche sui percorsi famosi | OK |  |
| Percorso consigliato | In Esplora: "Percorso consigliato" | OK |  |
| Percorso consigliato | Si apre la scelta di partenza, distanza, strade e direzione | OK |  |
| Percorso consigliato | Distanza fuori misura: messaggio | OK |  |
| Percorso consigliato | Avanzamento mostrato durante la ricerca | OK |  |
| Percorso consigliato | Proposte (al massimo 3) vicine alla distanza chiesta, con la quota su ciclabili, secondarie e sterrati | OK | [40.0, 40.0, 29.0] |
| Percorso consigliato | Calcolate con il profilo BRouter che preferisce ciclabili e strade secondarie (trekking), in 6 direzioni più l'affinamento | OK | 8 |
| Percorso consigliato | Dichiarato come proposta automatica, non intelligenza artificiale | OK |  |
| Percorso consigliato | La proposta scelta è disegnata sulla mappa, le altre in grigio | OK |  |
| Percorso consigliato | Si può guardare un'altra proposta | OK |  |
| Percorso consigliato | "Usa questo": diventa un percorso modificabile ad anello, con nome proposto | OK |  |
| Percorso consigliato | Poi si modifica come gli altri (tappa aggiunta, ricalcolo) | OK |  |
| Percorso consigliato | Salvato tra i tuoi percorsi | OK |  |
| Percorso consigliato | Solo asfalto tranquillo: profilo "strade tranquille"; direzione nord: 3 direzioni attorno al nord | OK | (5, ['Anello 40 km verso nord', 'Anello 40 km verso nord-ovest', 'Anello 29 km verso nord-est']) |
| Percorso consigliato | Preferenze ricordate | OK |  |
| Percorso consigliato | Editor bici: strade tranquille scelte in partenza | OK |  |
| Percorso consigliato | Andata e ritorno: arriva a un punto e torna alla partenza | OK | ['Andata e ritorno 30 km verso nord', 'Andata e ritorno 30 km verso sud'] |
| Percorso consigliato | Da A a B: si chiede l'arrivo, non la distanza | OK |  |
| Percorso consigliato | Da A a B: varianti verso l'arrivo, scelte per strade tranquille e deviazione contenuta | OK | ['Verso Bagnacavallo · 7,0 km (variante a sinistra)', 'Verso Bagnacavallo · 6,6 km', 'Verso Bagnacavallo · 8,1 km (variante a sinistra)'] |
| Percorso consigliato | Da A a B: partenza A e arrivo B sulla mappa | OK |  |
| Percorso consigliato | Da A a B usato: ultima tappa = arrivo, con il suo nome | OK | ['Via 11, Lugo', 'Via 10, Lugo', 'Bagnacavallo'] |
| Percorso consigliato | Arrivo non trovato: messaggio | OK |  |
| Percorso consigliato | Gli anelli che ripassano sulle stesse strade vengono penalizzati | OK | [0.3833333333333334, 0] |
| Percorso consigliato | Corsa: distanze da corsa e sentieri/parchi | OK |  |
| Percorso consigliato | Corsa: profilo sentieri (hiking-mountain) | OK |  |
| Percorso consigliato | BRouter non risponde: messaggio chiaro e Riprova | OK |  |
| Generale | Nessun errore JavaScript nelle prove aggiuntive | OK | [] |
| Generale | Nessun errore JavaScript nelle nuove prove | OK | [] |
| Home | Nuovo utente: azione principale "Inizia" visibile subito anche su iPhone SE, sopra la barra | OK | ({'x': 30, 'y': 387.578125, 'width': 315, 'height': 62}, 601) |
| Home | Nuovo utente: cosa fa Trailo in tre righe, nessun progresso vuoto o inventato | OK |  |
| Home | Proposta di oggi con la forma del percorso disegnata | OK |  |
| Home | Nessun pulsante per funzioni non collegate (assistente IA) | OK |  |
| Home | Meteo e occorrente dentro la scheda di oggi | OK |  |
| Home | Le righe "Con Trailo" portano alla sezione giusta | OK |  |
| Home | Utente abituale: settimana e ultima attività con i suoi dati, niente presentazione | OK |  |
| Home | Riduci movimento: forma del percorso già disegnata, nessuna animazione | OK |  |
| Esplora | Mappa a tutto schermo, pannello ridotto in basso | OK | (844, 610) |
| Esplora | La pagina non scorre: si muove solo la mappa o il pannello | OK |  |
| Esplora | Pannello a tre altezze con il pulsante (ridotto → metà → pieno) | OK | ('half', 'full') |
| Esplora | Trascinando il pannello con il mouse verso l'alto si apre | OK | half |
| Esplora | Toccando la mappa il pannello si riduce | OK |  |
| Esplora | Trascinamento con il dito (eventi touch) verso l'alto: il pannello si apre | OK | half |
| Accessibilità | Pannello di Esplora apribile da tastiera | OK |  |
| Esplora | Tocco su un percorso della mappa: scheda evidenziata, pannello a metà, tracciato sulla mappa | OK |  |
| Esplora | Secondo tocco: si apre il dettaglio | OK |  |
| Transizioni | Passaggio scheda → dettaglio con continuità dell'immagine (View Transitions, dove il browser lo supporta) | OK |  |
| Esplora | Dettaglio: "Pedala questo percorso" prima della mappa, azioni secondarie raccolte in una riga | OK |  |
| Transizioni | Ritorno a Esplora sulla stessa scheda, evidenziata | OK |  |
| Attività in corso | Comandi bloccati: Pausa e Termina non rispondono ai tocchi, le metriche restano visibili | OK |  |
| Attività in corso | Tocco breve: resta bloccato | OK |  |
| Attività in corso | Tenendo premuto ~1 s si sblocca | OK |  |
| Accessibilità | Sblocco anche da tastiera (Invio tenuto premuto) | OK |  |
| Attività in corso | Pausa e Termina ben separati e alti | OK | [20, 72] |
| Analisi | Andamento della velocità lungo la sessione, con la media | OK |  |
| Accessibilità | Grafico dell'andamento leggibile da tastiera | OK | km 3,0 · 22,6 km/h (sotto la media) |
| Analisi | Attività senza dati punto per punto: lo dice, nessun grafico inventato | OK |  |
| Analisi | Ultime 4 settimane contro le 4 precedenti (solo con dati sufficienti) | OK |  |
| Analisi | Con una sola attività il confronto tra periodi non viene calcolato | OK |  |
| Privacy | "Chi vede cosa" sempre disponibile nella Community | OK |  |
| Privacy | Spiega profilo, post, attività, eventi, chat e posizione | OK |  |
| Privacy | Prima di condividere: chi la vede e opzione per nascondere partenza e arrivo (attiva) | OK |  |
| Privacy | Traccia condivisa senza i primi e gli ultimi 500 m | OK | (0.5, 0.5) |
| Privacy | Condivisione revocabile: l'attività sparisce dal server, resta nell'archivio | OK |  |
| Backup e dati | Profilo: stato dell'archivio, rischio dichiarato, nessun backup ancora | OK |  |
| Backup e dati | Backup completo: attività, percorsi tuoi, profilo e preferenze | OK |  |
| Backup e dati | Data dell'ultimo backup mostrata | OK |  |
| Backup e dati | Ripristino su un altro browser: attività e percorsi tornano | OK |  |
| Backup e dati | Ripristino ripetuto: nessun doppione | OK |  |
| Backup e dati | File sbagliato: messaggio chiaro, niente modificato | OK |  |
| Offline e installazione | Senza rete l'app si apre lo stesso (copia salvata dal service worker) | OK | (True, True) |
| Offline e installazione | Avviso chiaro di cosa funziona offline | OK |  |
| Offline e installazione | Tornata la rete l'avviso sparisce | OK |  |
| Offline e installazione | Installabile su iPhone e Android: manifest, icone, titolo | OK | Trailo |
| iPhone piccolo, medio, grande | iPhone SE (375×667): nessuno scorrimento orizzontale, comandi ≥ 40 px, pulsanti dell'attività sullo schermo | OK | [] |
| iPhone piccolo, medio, grande | iPhone 13/14 (390×844): nessuno scorrimento orizzontale, comandi ≥ 40 px, pulsanti dell'attività sullo schermo | OK | [] |
| iPhone piccolo, medio, grande | iPhone Pro Max (430×932): nessuno scorrimento orizzontale, comandi ≥ 40 px, pulsanti dell'attività sullo schermo | OK | [] |
| Scenari d'uso | 1. Nuovo utente inizia una corsa: 2 tocchi dalla Home (Inizia → Avvia) | OK | 2 |
| Scenari d'uso | 2. Ciclista cerca un percorso vicino: 3 tocchi (Esplora → apri elenco ordinato per vicinanza → scheda) | OK | brisighella |
| Scenari d'uso | 3. Capire la difficoltà: nel dettaglio subito distanza, salita, durata, difficoltà e fondo; più sotto i tipi di strada e l'altimetria | OK |  |
| Scenari d'uso | 4. Analizzare l'ultima attività: 1 tocco dalla Home | OK |  |
| Scenari d'uso | 5. Partecipare a un evento: 2 tocchi dalla Home con un account (evento → Partecipo) | OK | 2 |
| Accessibilità | Nessun errore JavaScript nelle prove della revisione 6 | OK | [] |
