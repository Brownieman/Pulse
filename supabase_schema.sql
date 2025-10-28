-- Supabase SQL schema for Task Management App
-- Users table (Supabase Auth handles users)

-- Tasks table
create table if not exists tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  title text not null,
  description text,
  deadline timestamptz,
  status text default 'open',
  created_at timestamptz default now(),
  completed_at timestamptz
);

-- Messages table (for chat)
create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  text text not null,
  is_user boolean default true,
  at timestamptz default now(),
  task_id uuid references tasks(id) on delete cascade
);

-- Reminders table
create table if not exists reminders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  title text not null,
  remind_at timestamptz not null,
  created_at timestamptz default now()
);

-- Servers table (for server list)
create table if not exists servers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  name text not null,
  created_at timestamptz default now()
);

-- Analytics table (for storing user analytics)
create table if not exists analytics (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  trust_score int default 600,
  updated_at timestamptz default now()
);

-- Row Level Security Policies
-- Enable RLS
alter table tasks enable row level security;
alter table messages enable row level security;
alter table reminders enable row level security;
alter table servers enable row level security;
alter table analytics enable row level security;

-- Policies: Only allow users to access their own rows
create policy "Users can access their own tasks" on tasks
  for all using (auth.uid() = user_id);
create policy "Users can access their own messages" on messages
  for all using (auth.uid() = user_id);
create policy "Users can access their own reminders" on reminders
  for all using (auth.uid() = user_id);
create policy "Users can access their own servers" on servers
  for all using (auth.uid() = user_id);
create policy "Users can access their own analytics" on analytics
  for all using (auth.uid() = user_id);
