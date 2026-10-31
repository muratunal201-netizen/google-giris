-- Giriş kayıtları tablosu
-- Supabase panelinde: SQL Editor → bu dosyayı yapıştır → Run

create table if not exists public.login_events (
  id          bigint generated always as identity primary key,
  user_id     uuid not null references auth.users(id) on delete cascade,
  email       text,
  name        text,
  ip          text,
  user_agent  text,
  created_at  timestamptz not null default now()
);

-- Satır bazlı güvenlik: herkes yalnızca KENDİ giriş kaydını ekleyebilir/görebilir
alter table public.login_events enable row level security;

create policy "kendi kaydini ekle"
  on public.login_events for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "kendi kaydini gor"
  on public.login_events for select
  to authenticated
  using (auth.uid() = user_id);

-- Not: Tüm girişleri yönetici olarak görmek için Supabase panelinde
-- Table Editor → login_events (servis rolü RLS'i bypass eder) veya
-- SQL Editor'den sorgulayabilirsiniz:  select * from login_events order by created_at desc;
