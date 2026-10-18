-- TRAILO 2.0 · revisione 5: bacheca social, foto e audio in chat, percorsi personalizzati
-- APPLICATA il 18/10/2026 come migrazioni `trailo2_social_board_media_routes` + `trailo2_posts_select_inline`.
-- Solo aggiunte: nessuna tabella o regola esistente cancellata. L'app attuale continua a funzionare.

-- 1) Allegati in chat (foto, audio, percorso). Il testo resta obbligatorio: l'app mette una didascalia ("📷 Foto", "🎙 Audio").
alter table public.messages
  add column if not exists media_path text,
  add column if not exists media_type text,
  add column if not exists route jsonb;
alter table public.messages add constraint messages_media_type_chk check (media_type is null or media_type in ('image','audio'));
-- un file allegato deve stare nella cartella di chi scrive
alter table public.messages add constraint messages_media_path_chk check (media_path is null or (char_length(media_path) <= 300 and split_part(media_path,'/',1) = sender::text));
alter table public.messages add constraint messages_route_size_chk check (route is null or pg_column_size(route) <= 60000);

-- 2) Percorso personalizzato collegato a un evento
alter table public.group_rides add column if not exists route jsonb;
alter table public.group_rides add constraint group_rides_route_size_chk check (route is null or pg_column_size(route) <= 60000);

-- 3) Bacheca: post (testo, foto, percorso, repost), tag, like, commenti
create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references public.profiles(id) on delete cascade,
  body text check (body is null or char_length(body) <= 2000),
  media_path text check (media_path is null or char_length(media_path) <= 300),
  route jsonb check (route is null or pg_column_size(route) <= 60000),
  visibility text not null default 'public' check (visibility in ('public','friends')),   -- scelta per ogni post
  repost_of uuid references public.posts(id) on delete cascade,
  created_at timestamptz not null default now(),
  constraint posts_content_chk check (coalesce(char_length(body),0) > 0 or media_path is not null or route is not null or repost_of is not null),
  constraint posts_media_owner_chk check (media_path is null or split_part(media_path,'/',1) = user_id::text));
create index if not exists posts_user_created on public.posts (user_id, created_at desc);
create index if not exists posts_created on public.posts (created_at desc);
create index if not exists posts_repost on public.posts (repost_of);
create table if not exists public.post_tags (
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  primary key (post_id, user_id));
create index if not exists post_tags_user on public.post_tags (user_id);
create table if not exists public.post_likes (
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null default auth.uid() references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, user_id));
create index if not exists post_likes_user on public.post_likes (user_id);
create table if not exists public.post_comments (
  id bigint generated always as identity primary key,
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null default auth.uid() references public.profiles(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 1000),
  created_at timestamptz not null default now());
create index if not exists post_comments_post on public.post_comments (post_id, created_at);
create index if not exists post_comments_user on public.post_comments (user_id);

-- 4) Funzioni di controllo
create or replace function private.can_see_post(p uuid, u uuid) returns boolean          -- posso vedere il post?
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.posts x where x.id = p and
    (x.visibility = 'public' or x.user_id = u or private.is_friend(u, x.user_id)
     or exists (select 1 from public.post_tags t where t.post_id = x.id and t.user_id = u)));
$$;
create or replace function private.post_owner(p uuid) returns uuid
language sql stable security definer set search_path = public as $$ select user_id from public.posts where id = p $$;
grant execute on function private.can_see_post(uuid,uuid), private.post_owner(uuid) to authenticated;

-- 5) Regole di accesso
alter table public.posts enable row level security;
alter table public.post_tags enable row level security;
alter table public.post_likes enable row level security;
alter table public.post_comments enable row level security;
-- (seconda migrazione) la regola di lettura dei post è scritta per esteso invece di chiamare can_see_post,
-- altrimenti "pubblica e restituisci il post" falliva: la funzione non vede ancora la riga appena inserita.
create policy "vedo i post visibili" on public.posts for select to authenticated using (
  visibility = 'public' or user_id = (select auth.uid()) or private.is_friend((select auth.uid()), user_id)
  or exists (select 1 from public.post_tags t where t.post_id = posts.id and t.user_id = (select auth.uid())));
create policy "pubblico i miei post" on public.posts for insert to authenticated
  with check (user_id = (select auth.uid()) and (repost_of is null or private.can_see_post(repost_of, (select auth.uid()))));
create policy "cancello i miei post" on public.posts for delete to authenticated using (user_id = (select auth.uid()));
create policy "vedo i tag" on public.post_tags for select to authenticated using (user_id = (select auth.uid()) or private.can_see_post(post_id, (select auth.uid())));
create policy "taggo amici nei miei post" on public.post_tags for insert to authenticated
  with check (private.post_owner(post_id) = (select auth.uid()) and private.is_friend((select auth.uid()), user_id));
create policy "tolgo un tag" on public.post_tags for delete to authenticated using (user_id = (select auth.uid()) or private.post_owner(post_id) = (select auth.uid()));
create policy "vedo i like" on public.post_likes for select to authenticated using (private.can_see_post(post_id, (select auth.uid())));
create policy "metto like" on public.post_likes for insert to authenticated with check (user_id = (select auth.uid()) and private.can_see_post(post_id, (select auth.uid())));
create policy "tolgo like" on public.post_likes for delete to authenticated using (user_id = (select auth.uid()));
create policy "vedo i commenti dei post" on public.post_comments for select to authenticated using (private.can_see_post(post_id, (select auth.uid())));
create policy "commento i post" on public.post_comments for insert to authenticated with check (user_id = (select auth.uid()) and private.can_see_post(post_id, (select auth.uid())));
create policy "cancello commenti miei o sui miei post" on public.post_comments for delete to authenticated
  using (user_id = (select auth.uid()) or private.post_owner(post_id) = (select auth.uid()));
grant select, insert, delete on public.posts, public.post_tags, public.post_likes, public.post_comments to authenticated;

-- 6) Spazio "media" per foto e audio: privato (serve un account), max 10 MB, ognuno scrive solo nella cartella col proprio id
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('media','media',false,10485760,array['image/jpeg','image/png','image/webp','audio/webm','audio/mp4','audio/mpeg','audio/ogg','audio/aac'])
on conflict (id) do nothing;
create policy "trailo media: carico nella mia cartella" on storage.objects for insert to authenticated
  with check (bucket_id = 'media' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "trailo media: leggo con account" on storage.objects for select to authenticated using (bucket_id = 'media');
create policy "trailo media: cancello i miei file" on storage.objects for delete to authenticated
  using (bucket_id = 'media' and (storage.foldername(name))[1] = (select auth.uid())::text);
