# pg-performance-queries

A repository of queries to help analyze the performance of a PostgreSQL database.

## Purpose

This repository holds a collection of queries that can be run against PostgreSQL version 12 or 13 engines. They are intended to help users track down issues regarding query performance in the database.

## Query Types

### Engine

The directory `./engine` holds queries directed at the engine itself. They will primarily access the `pg_settings` table.

### Locks

The directory `./locks` holds queries that will help track blocked queries due to lock contention.

#### WARNING

⚠ You will be able to see query parameters when using these statements. Be careful that sensitive information is not leaked.

### Statistics

The directory `./stats` holds queries that will gather information from the statistics tables.

#### WARNING

⚠ You will be able to see query parameters when using these statements. Be careful that sensitive information is not leaked.
