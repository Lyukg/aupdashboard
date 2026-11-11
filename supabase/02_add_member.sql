-- Create the account in Authentication > Users first.
-- Replace the email and select admin or marketing, then run in SQL Editor.
do $$
declare member_id uuid;
begin
 select id into member_id from auth.users where lower(email)=lower('REPLACE_WITH_TEAM_EMAIL');
 if member_id is null then raise exception 'Create this user in Authentication > Users first'; end if;
 insert into public.workspace_members(workspace_id,user_id,role)
 values ('6d92f5d1-bb5e-4ba7-a523-40426c00c603',member_id,'admin')
 on conflict(workspace_id,user_id) do update set role=excluded.role;
end $$;
