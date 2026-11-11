begin;
create table if not exists public.workspace_members (
 workspace_id uuid not null,
 user_id uuid not null references auth.users(id) on delete cascade,
 role text not null check (role in ('admin','marketing')),
 primary key (workspace_id,user_id)
);
create table if not exists public.workspace_state (
 workspace_id uuid primary key,
 data jsonb not null,
 revision bigint not null default 0,
 updated_by uuid references auth.users(id),
 updated_at timestamptz not null default now()
);
alter table public.workspace_members enable row level security;
alter table public.workspace_state enable row level security;
revoke all on public.workspace_members, public.workspace_state from anon, authenticated;
grant select on public.workspace_members, public.workspace_state to authenticated;
grant update (data,revision,updated_by,updated_at) on public.workspace_state to authenticated;
drop policy if exists member_self_read on public.workspace_members;
create policy member_self_read on public.workspace_members for select to authenticated using (user_id=(select auth.uid()));
drop policy if exists workspace_member_read on public.workspace_state;
create policy workspace_member_read on public.workspace_state for select to authenticated using (
 exists(select 1 from public.workspace_members m where m.workspace_id=workspace_state.workspace_id and m.user_id=(select auth.uid()))
);
drop policy if exists workspace_member_update on public.workspace_state;
create policy workspace_member_update on public.workspace_state for update to authenticated using (
 exists(select 1 from public.workspace_members m where m.workspace_id=workspace_state.workspace_id and m.user_id=(select auth.uid()) and m.role in ('admin','marketing'))
) with check (
 updated_by=(select auth.uid()) and exists(select 1 from public.workspace_members m where m.workspace_id=workspace_state.workspace_id and m.user_id=(select auth.uid()) and m.role in ('admin','marketing'))
);
insert into public.workspace_state(workspace_id,data) values ('6d92f5d1-bb5e-4ba7-a523-40426c00c603','{"version":2,"mode":"custom","hasDemoData":false,"campaigns":[{"id":"office","name":"Office","desc":"Office leasing, workspace and workplace strategy"},{"id":"retail","name":"Retail","desc":"Mặt bằng thương mại / bán lẻ"},{"id":"residential","name":"Residential","desc":"Residential developments and housing"},{"id":"hospitality","name":"Hospitality","desc":"Hospitality assets and hotels"},{"id":"factory","name":"Factory","desc":"Industrial, manufacturing and factory leasing"}],"records":[],"liWeekly":[],"liInsights":{},"liPostInsights":{},"targets":{"retail":{"sessions":1450,"leads":29,"mql":15,"sql":8,"impressions":11000},"office":{"sessions":1250,"leads":24,"mql":15,"sql":8,"impressions":11500},"residential":{},"hospitality":{},"factory":{}},"pages":[],"keywords":[],"aioChecks":[],"posts":[],"tasks":[],"notes":{"competitors":"","positioning":"","hypotheses":""},"goalConfig":{"startWeek":"2026-W46","baselineFollowers":0,"targets":{"followers":500,"liImpressions":20000,"liER":4,"liContents":24,"liFeed":8,"liVideo":8,"liArticle":8,"keywords":20,"searchGrowth":30,"clickGrowth":30,"ctrDelta":0.3,"top10":5,"aioChecks":15,"sessions":1000,"seoArticles":16,"forms":4,"mql":2},"milestones":{"followers":[160,195,235,275,330,385,440,500],"sessions":[20,40,70,110,150,180,200,230],"forms":[0,0,0,0,1,1,1,1]},"notes":{},"updatedAt":null,"targetSchema":3},"directorLinkedIn":[],"seoInsights":{},"websiteInsights":{},"executiveInsights":{},"facebookPosts":[],"tiktokPosts":[],"facebookWeekly":[],"tiktokWeekly":[],"seoArticles":[],"attribution":[],"liArticles":[],"directorPosts":[],"periodSnapshots":[],"facebookInsights":{},"tiktokInsights":{},"metaDemoSources":{},"linkedinPersonalTest":null}'::jsonb) on conflict(workspace_id) do nothing;
commit;
