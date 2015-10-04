# encoding: utf-8

class CreateUsers < ROM::Migrator::Migration
  def up
    replication = { class: :SimpleStrategy, replication_factor: 1 }

    call keyspace(:logs)
      .create
      .if_not_exists
      .with(replication: replication)

    call keyspace(:logs)
      .table(:users)
      .create
      .if_not_exists
      .add(:id, :int)
      .add(:name, :text)
      .primary_key(:id)
  end

  def down
    call keyspace(:logs).drop.if_exists
  end
end # class CreateUsers
