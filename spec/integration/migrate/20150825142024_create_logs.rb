# encoding: utf-8

class CreateLogs < ROM::Cassandra::Migrations::Migration
  def up
    call keyspace(:logs)
      .table(:logs)
      .create
      .add(:id, :int)
      .add(:name, :text)
      .primary_key(:id)
      .if_not_exists
  end

  def down
    call "DROP TABLE IF EXISTS logs.logs;"
  end
end # class CreateUsers
