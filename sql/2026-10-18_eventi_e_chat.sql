-- TRAILO 2.0 · eventi pubblici o tra amici + chat di gruppo
-- Solo aggiunte. Le uscite esistenti diventano 'public': l'app attuale continua a vederle come prima.

-- 1) Nuovi campi sulle uscite/eventi
alter table public.group_rides
  add column if not exists visibility text not null default 'public',   -- 'public' = tutti con un account, 'friends' = solo amici
  add column if not exists lat double precision,                        -- punto di ritrovo sulla mappa
  add column if not exists lon double precision,
  add column if not exists route_ref text,                              -- percorso famoso collegato (es. 'stelvio')
  add column if not exists max_people integer;                          -- posti massimi (vuoto = senza limite)
alter table public.group_rides add constraint group_rides_visibility_chk check (visibility in ('public','friends'));
alter table public.group_rides add constraint group_rides_max_chk check (max_people is null or max_people between 2 and 500);
alter table public.group_rides add constraint group_rides_title_chk check (char_length(title) between 1 and 120) not valid;
alter table public.group_rides add constraint group_rides_coords_chk check ((lat is null and lon is null) or (lat between -90 and 90 and lon between -180 and 180));
create index if not exists group_rides_starts on public.group_rides (starts_at);

-- 2) Funzioni di controllo (eseguibili solo da utenti con account)
create or replace function private.can_see_ride(r uuid, u uuid) returns boolean      -- posso vedere l'evento?
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.group_rides g where g.id = r and
    (g.visibility = 'public' or g.creator = u or private.is_friend(u, g.creator)
     or exists (select 1 from public.ride_members m where m.ride_id = g.id and m.user_id = u)));
$$;
create or replace function private.in_ride(r uuid, u uuid) returns boolean           -- organizzo o partecipo?
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.group_rides g where g.id = r and g.creator = u)
      or exists (select 1 from public.ride_members m where m.ride_id = r and m.user_id = u);
$$;
create or replace function private.ride_has_room(r uuid) returns boolean            -- ci sono ancora posti?
language sql stable security definer set search_path = public as $$
  select coalesce((select g.max_people is null or (select count(*) from public.ride_members m where m.ride_id = r) < g.max_people
                   from public.group_rides g where g.id = r), false);
$$;
revoke all on function private.can_see_ride(uuid,uuid), private.in_ride(uuid,uuid), private.ride_has_room(uuid) from public, anon;
grant execute on function private.can_see_ride(uuid,uuid), private.in_ride(uuid,uuid), private.ride_has_room(uuid) to authenticated;

-- 3) Regole di accesso alle uscite (prima: tutte visibili a tutti)
drop policy if exists "vedo le uscite" on public.group_rides;
create policy "vedo le uscite visibili" on public.group_rides for select to authenticated
  using (visibility = 'public' or creator = (select auth.uid()) or private.is_friend((select auth.uid()), creator)
         or exists (select 1 from public.ride_members m where m.ride_id = group_rides.id and m.user_id = (select auth.uid())));
create policy "modifico le mie uscite" on public.group_rides for update to authenticated
  using (creator = (select auth.uid())) with check (creator = (select auth.uid()));

-- 4) Iscrizioni: solo a eventi che posso vedere e con posti liberi
drop policy if exists "mi iscrivo" on public.ride_members;
create policy "mi iscrivo alle uscite visibili" on public.ride_members for insert to authenticated
  with check (user_id = (select auth.uid()) and private.can_see_ride(ride_id, (select auth.uid())) and private.ride_has_room(ride_id));
drop policy if exists "vedo chi partecipa" on public.ride_members;
create policy "vedo chi partecipa alle uscite visibili" on public.ride_members for select to authenticated
  using (private.can_see_ride(ride_id, (select auth.uid())));

-- 5) Chat dell'evento: la leggono e scrivono solo organizzatore e iscritti
create table if not exists public.ride_messages (
  id bigint generated always as identity primary key,
  ride_id uuid not null references public.group_rides(id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 2000),
  created_at timestamptz not null default now());
create index if not exists ride_messages_ride on public.ride_messages (ride_id, created_at);
create index if not exists ride_messages_user on public.ride_messages (user_id);
alter table public.ride_messages enable row level security;
create policy "leggo la chat delle mie uscite" on public.ride_messages for select to authenticated
  using (private.in_ride(ride_id, (select auth.uid())));
create policy "scrivo nella chat delle mie uscite" on public.ride_messages for insert to authenticated
  with check (user_id = (select auth.uid()) and private.in_ride(ride_id, (select auth.uid())));
create policy "cancello i miei messaggi di gruppo" on public.ride_messages for delete to authenticated
  using (user_id = (select auth.uid()));
revoke all on public.ride_messages from anon;
grant select, insert, delete on public.ride_messages to authenticated;
