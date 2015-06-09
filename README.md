# HelloPhoenix

Nothing interesting here, just playing with elixir and cassandra.

## Create keyspace and tables

```
CREATE KEYSPACE stats_development
WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };
CREATE TABLE stats_development.events (
  id uuid PRIMARY KEY,
  data map<text, text>,
  type text
);
```

## Launch

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.
