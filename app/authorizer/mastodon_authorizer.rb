require 'yaml'
require './app/authorizer/token_creator.rb'
require './app/authorizer/app_creator.rb'
require './app/util/validator.rb'

class MastodonAuthorizer
  include Validator

  def initialize(**args)
    nil_check_for args, [:app_keys_file, :tokens_file, :app_creator, :token_creator]
    @app_keys_file = args[:app_keys_file]
    @tokens_file = args[:tokens_file]
    @token_creator = args[:token_creator]
    @app_creator = args[:app_creator]

    @tokens = open @tokens_file
    @app_keys = open @app_keys_file
    @original_tokens = deep_dup @tokens
    @original_app_keys = deep_dup @app_keys
  end

  def get_token(**args)
    nil_check_for args, [:host_url, :client_name, :email, :password]

    if app_keys_for(args) == nil
      create_app(args)
    end

    args.merge! app_keys_for args

    if token_for(args) == nil
      create_token(args) 
    end

    token_for args
  end

  def save_app_keys_if_needed
    if !@original_app_keys.eql? @app_keys
      YAML.dump(@app_keys, File.open(@app_keys_file, 'w'))
      @original_app_keys = deep_dup @app_keys
      puts "save app_keys at #{@app_keys_file}"
    end
  end

  def save_token_if_needed
    if !@original_tokens.eql? @tokens
      YAML.dump(@tokens, File.open(@tokens_file, 'w'))
      @original_tokens = deep_dup @tokens
      puts "save tokens at #{@tokens_file}"
    end
  end

  private
  def open(filename)
    begin
      res = YAML.load_file(filename)
    rescue => _
      res = {}
    end

    # sometimes YAML#load_file return false 
    # I guess it happen when you try to load file which just beging written by another program
    raise "fail to load file:#{filename}. May be try open writing file" if !res.is_a?(Hash)
    res
  end

  def token_hash_key_for(args)
    nil_check_for args, [:host_url, :email, :client_id]
    "#{args[:host_url]}@#{args[:client_id]}@#{args[:email]}"
  end

  def deep_dup hash
    Marshal.load(Marshal.dump(hash))
  end

  def token_for(args)
    @tokens[token_hash_key_for args]
  end

  def app_hash_key_for(args)
    nil_check_for args, [:host_url, :email, :client_name]
    "#{args[:host_url]}@#{args[:email]}@#{args[:client_name]}"
  end

  def app_keys_for(args)
    @app_keys[app_hash_key_for args]
  end

  def create_app(args)
    nil_check_for args, [:host_url, :client_name, :email]
    app_keys = @app_creator.new(args).create

    @app_keys[app_hash_key_for args]  = app_keys
  end

  def create_token(args)
    nil_check_for args, [:host_url, :email, :password, :client_id]

    token = @token_creator.new(args).create 
    @tokens[token_hash_key_for args] = token
  end
end


