# encoding: utf-8

class CreateLogs < ROM::Migrator::Migration
  up do
    call keyspace(:logs)
      .table(:logs)
      .create
      .add(:id, :int)
      .add(:name, :text)
      .primary_key(:id)
      .if_not_exists
  end

  down do
    call "DROP TABLE IF EXISTS logs.logs;"
  end
end # class CreateUsers
