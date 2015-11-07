require 'json'

class LocalStorage
  def store(key, value)
    setup
    config = load_config
    config[key.to_s] = value
    write_config(config)
  end

  def load(key)
    config = load_config
    config[key.to_s]
  end

  private

  def load_config
    JSON.parse(File.read('.local_storage'))
  end

  def write_config(config)
    File.write('.local_storage', config.to_json)
    File.chmod(0600, '.local_storage')
  end

  def setup
    write_config({}) unless File.exist? '.local_storage'
  end
end

