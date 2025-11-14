module main

import pool
import time
$if using_sqlite ? {
	import db.sqlite as db_provider
} $else {
	import db.pg as db_provider
}

pub fn new() !&pool.ConnectionPool {
	config := pool.ConnectionPoolConfig{
		max_conns:      10
		min_idle_conns: 5
		max_lifetime:   time.hour
		idle_timeout:   1 * time.minute
		get_timeout:    15 * time.second
	}

	return pool.new_connection_pool(create_conn, config)!
}

$if using_sqlite ? {
	fn create_conn() !&pool.ConnectionPoolable {
		db := db_provider.connect(sqlite_conn_str)!
		db.synchronization_mode(db_provider.SyncMode.off)!
		db.journal_mode(db_provider.JournalMode.memory)!

		return &db
	}
} $else {
	fn create_conn() !&pool.ConnectionPoolable {
		db := db_provider.connect_with_conninfo(pg_conn_str)!

		return &db
	}
}
