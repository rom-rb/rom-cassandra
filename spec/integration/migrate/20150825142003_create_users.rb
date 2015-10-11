# encoding: utf-8

class CreateUsers < ROM::Migrator::Migration
  up do
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

  down do
    call keyspace(:logs).drop.if_exists
  end
end # class CreateUsers
