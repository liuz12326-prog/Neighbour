# Neighbour Signals

A responsive Moray community story game. Version 4 adds shared cloud sync and a password-protected researcher dashboard.

## How Sync Works

- A participant's answers are saved locally during the game.
- Selecting **Finish session** marks the stories as submitted.
- Submitted stories upload to the shared Supabase database.
- If the device is offline, stories remain queued and upload automatically when the connection returns.
- Participant devices have permission to insert records only. They cannot read, change, or delete the shared dataset.
- The researcher signs in with an email and password to read, export, or delete all synced records.

## One-Time Cloud Setup

### 1. Create the database

1. Create a Supabase project.
2. Open **Authentication → Users** and create one researcher user with your email and a strong password.
3. Open **SQL Editor**.
4. Open `supabase-schema.sql` from this folder.
5. Replace both instances of `REPLACE_WITH_YOUR_RESEARCHER_EMAIL` with the same researcher email.
6. Run the SQL.

### 2. Connect the website

Open `config.js` and add the project values:

```js
window.NEIGHBOUR_SIGNALS_CONFIG = {
  supabaseUrl: "https://YOUR_PROJECT.supabase.co",
  supabaseAnonKey: "YOUR_PUBLISHABLE_OR_ANON_KEY",
};
```

The project URL is in **Project Settings → Data API**. The publishable/anon key is in **Project Settings → API Keys**.

The publishable/anon key is designed to be used in a browser when Row Level Security is enabled. Never put a `service_role` or secret key in `config.js`.

### 3. Deploy

Upload the complete folder to a static host. Every participant must open the same deployed URL. Their finished stories will then arrive in the same database.

## Researcher Access

1. Select the `▥` button in the top-right corner.
2. Enter the researcher email and password created in Supabase.
3. The dashboard loads all synced participant records.
4. Use **Refresh**, **CSV**, or **JSON** as needed.
5. Select **Log out** before handing the device to a participant.

The researcher login token is kept in session storage, so closing the browser tab ends local dashboard access.

## Data Collected

Each anonymous story contains:

- participant code, optional age range, and broad Moray area
- chosen role and scenario
- time context
- community node and node type
- feeling and frequency
- importance label and 1–4 score
- preferred support
- attitude to technology
- privacy boundary
- optional free-text note
- timestamp and game version

## Important Test

Before fieldwork:

1. Submit one test story on a phone.
2. Open the researcher dashboard on the main device.
3. Confirm the story appears.
4. Export CSV and inspect the record.
5. Log out and confirm the dashboard asks for the password again.
