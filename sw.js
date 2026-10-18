/* Trailo · service worker: l'app si apre anche senza rete.
   Pagina: prima la rete (versione aggiornata), poi la copia salvata. Immagini dell'app e font: copia salvata, aggiornata in background.
   Tessere della mappa: copia salvata delle zone già viste (al massimo 600). Servizi (percorsi, meteo, Community): sempre dalla rete. */
var V='trailo-v6-1',APP=V+'-app',TILES=V+'-tiles';
var CORE=['./','./index.html','./assets/trailo-simbolo.png','./assets/trailo-wordmark.png','./assets/icon-192.png','./manifest.webmanifest'];
self.addEventListener('install',function(e){e.waitUntil(caches.open(APP).then(function(c){return c.addAll(CORE)}).then(function(){return self.skipWaiting()}))});
self.addEventListener('activate',function(e){e.waitUntil(caches.keys().then(function(ks){return Promise.all(ks.filter(function(k){return k.indexOf(V)!==0}).map(function(k){return caches.delete(k)}))}).then(function(){return self.clients.claim()}))});
var TILE_HOSTS=/(^|\.)tile\.openstreetmap\.org$|server\.arcgisonline\.com$|tile\.opentopomap\.org$|tile\.waymarkedtrails\.org$/;
function trim(name,max){caches.open(name).then(function(c){c.keys().then(function(ks){if(ks.length>max)Promise.all(ks.slice(0,ks.length-max).map(function(k){return c.delete(k)}))})})}
self.addEventListener('fetch',function(e){var r=e.request;if(r.method!=='GET')return;var u=new URL(r.url);
  if(r.mode==='navigate'){e.respondWith(Promise.race([fetch(r).then(function(res){if(res.ok){var cp=res.clone();caches.open(APP).then(function(c){c.put('./index.html',cp)})}return res}),new Promise(function(_,rej){setTimeout(rej,6000)})])
    .catch(function(){return caches.match('./index.html').then(function(m){return m||fetch(r)})}));return}
  if(u.origin===location.origin||/fonts\.(googleapis|gstatic)\.com$/.test(u.hostname)){e.respondWith(caches.open(APP).then(function(c){return c.match(r).then(function(m){var f=fetch(r).then(function(res){if(res&&(res.ok||res.type==='opaque'))c.put(r,res.clone());return res}).catch(function(){return m});return m||f})}));return}
  if(TILE_HOSTS.test(u.hostname)){e.respondWith(caches.open(TILES).then(function(c){return c.match(r).then(function(m){if(m)return m;return fetch(r).then(function(res){if(res&&(res.ok||res.type==='opaque')){c.put(r,res.clone());trim(TILES,600)}return res})})}));return}
});
