-- Galerie photo L'Eccellenza
-- À exécuter dans Supabase > SQL Editor.
-- Les accès administrateur reposent exclusivement sur app_metadata.role = 'admin'.
-- Ne donnez jamais le rôle admin via user_metadata, modifiable par l'utilisateur.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('gallery-photos', 'gallery-photos', true, 8388608, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

create table if not exists public.gallery_photos (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 100),
  alt_text text not null check (char_length(alt_text) between 1 and 160),
  category text not null check (category in ('cours','centre','evenement','reussites')),
  image_url text not null,
  storage_path text not null unique,
  published boolean not null default false,
  sort_order integer not null default 0,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

alter table public.gallery_photos enable row level security;

grant select on public.gallery_photos to anon, authenticated;
grant insert, update, delete on public.gallery_photos to authenticated;

drop policy if exists "Public can read published gallery photos" on public.gallery_photos;
create policy "Public can read published gallery photos"
on public.gallery_photos for select to anon, authenticated
using (published = true);

drop policy if exists "Admins can read all gallery photos" on public.gallery_photos;
create policy "Admins can read all gallery photos"
on public.gallery_photos for select to authenticated
using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "Admins can insert gallery photos" on public.gallery_photos;
create policy "Admins can insert gallery photos"
on public.gallery_photos for insert to authenticated
with check (
  (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
  and created_by = auth.uid()
);

drop policy if exists "Admins can update gallery photos" on public.gallery_photos;
create policy "Admins can update gallery photos"
on public.gallery_photos for update to authenticated
using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "Admins can delete gallery photos" on public.gallery_photos;
create policy "Admins can delete gallery photos"
on public.gallery_photos for delete to authenticated
using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- Public read access is required because image URLs are public.
drop policy if exists "Public can view gallery image files" on storage.objects;
create policy "Public can view gallery image files"
on storage.objects for select to anon, authenticated
using (bucket_id = 'gallery-photos');

drop policy if exists "Admins can upload gallery image files" on storage.objects;
create policy "Admins can upload gallery image files"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'gallery-photos'
  and (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
);

drop policy if exists "Admins can update gallery image files" on storage.objects;
create policy "Admins can update gallery image files"
on storage.objects for update to authenticated
using (
  bucket_id = 'gallery-photos'
  and (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
)
with check (
  bucket_id = 'gallery-photos'
  and (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
);

drop policy if exists "Admins can delete gallery image files" on storage.objects;
create policy "Admins can delete gallery image files"
on storage.objects for delete to authenticated
using (
  bucket_id = 'gallery-photos'
  and (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
);
