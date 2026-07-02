-- Neighbour Signals shared research database
-- Replace the email placeholder in both researcher policies before running.

create table if not exists public.story_records (
  record_id text primary key,
  participant_id text not null,
  local_area text not null,
  node text not null,
  node_type text not null,
  feeling text not null,
  importance_score smallint not null,
  support text not null,
  technology text not null,
  privacy_choice text not null,
  completed_at timestamptz not null,
  payload jsonb not null,
  created_at timestamptz not null default now()
);

create index if not exists story_records_participant_idx
  on public.story_records (participant_id);
create index if not exists story_records_created_at_idx
  on public.story_records (created_at desc);
create index if not exists story_records_node_idx
  on public.story_records (node);

alter table public.story_records enable row level security;

revoke all on table public.story_records from anon, authenticated;
grant insert on table public.story_records to anon;
grant select, delete on table public.story_records to authenticated;

drop policy if exists "Anonymous participants can submit stories" on public.story_records;
create policy "Anonymous participants can submit stories"
  on public.story_records
  for insert
  to anon
  with check (
    char_length(record_id) between 8 and 100
    and char_length(participant_id) between 1 and 48
    and char_length(local_area) between 1 and 80
    and importance_score between 1 and 4
    and jsonb_typeof(payload) = 'object'
  );

drop policy if exists "Researcher can read all stories" on public.story_records;
create policy "Researcher can read all stories"
  on public.story_records
  for select
  to authenticated
  using (
    lower((select auth.jwt() ->> 'email')) = lower('REPLACE_WITH_YOUR_RESEARCHER_EMAIL')
  );

drop policy if exists "Researcher can delete all stories" on public.story_records;
create policy "Researcher can delete all stories"
  on public.story_records
  for delete
  to authenticated
  using (
    lower((select auth.jwt() ->> 'email')) = lower('REPLACE_WITH_YOUR_RESEARCHER_EMAIL')
  );
