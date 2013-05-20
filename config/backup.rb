##
# Backup Generated: nong_min_365_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t my_backup [-c <path_to_configuration_file>]
#

RAILS_ENV    = ENV['RAILS_ENV'] || 'production'

database_yml = Rails.root.join("config","database.yml")

require 'yaml'
config = YAML.load_file(database_yml)

Backup::Model.new(:nm365_backup, 'NongMin365 Backup') do
  ##
  # Split [Splitter]
  #
  # Split the backup file in to chunks of 250 megabytes
  # if the backup file size exceeds 250 megabytes
  #
  split_into_chunks_of 250

  #
  # PostgreSQL [Database]
  #
  database PostgreSQL :nm365_db_prd do |db|
    db.name               = config[RAILS_ENV]["database"]
    db.username           = config[RAILS_ENV]["username"]
    db.password           = config[RAILS_ENV]["password"]
    db.host               = config[RAILS_ENV]["host"]
    db.port               = config[RAILS_ENV]["port"]
    db.socket             = "/tmp/pg.sock"
    db.skip_tables        = ["chinese_regions"]
    #db.only_tables        = ["only", "these", "tables"]
    db.additional_options = ["-xc", "-E=utf8"]
    # Optional: Use to set the location of this utility
    #   if it cannot be found by name in your $PATH
    # db.pg_dump_utility = "/opt/local/bin/pg_dump"
  end

  ##
  # Amazon Simple Storage Service [Storage]
  #
  # Available Regions:
  #
  #  - ap-northeast-1
  #  - ap-southeast-1
  #  - eu-west-1
  #  - us-east-1
  #  - us-west-1
  #
  store_with S3 do |s3|
    s3.access_key_id     = "AKIAITB7CN3GAIAPX34A"
    s3.secret_access_key = "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"
    s3.region            = "Tokyo"
    s3.bucket            = "mw82-backup"
    s3.path              = "/nm365/backups"
    s3.keep              = 10
  end

  ##
  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path       = "~/backups/"
    local.keep       = 5
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the Wiki for other delivery options.
  # https://github.com/meskyanichi/backup/wiki/Notifiers
  #
  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = "webmaster@nongmin365.com"
    mail.to                   = "huobazi@gmail.com"
    mail.address              = "smtp.postmarkapp.com"
    mail.port                 = 2525
    mail.domain               = "nongmin365.com"
    mail.user_name            = "e3f0b960-3ce9-45d9-ae26-113876d01ba7"
    mail.password             = "e3f0b960-3ce9-45d9-ae26-113876d01ba7"
    mail.authentication       = "plain"
    mail.encryption           = :starttls
  end

end
