require 'git'

module Orly
  class NoRepo < StandardError ; end

  class Tester

    def initialize
      @need_bundle = false
      @need_migrate = false
      @need_npm = false
      run_tests
    rescue ArgumentError
      raise NoRepo.new
    end

    def run_tests
      get_diff.each do |file|
        case(file.path)
          when /^Gemfile/ then @need_bundle = true
          when /^db\/migrate/ then @need_migrate = true
          when /^Podfile/ then @need_pod = true
          when /^package\.json/ then @need_npm = true
        end
      end
    rescue Git::GitExecuteError
      false
    end

    def get_diff
      git = Git.open('.')
      git.diff('HEAD@{1}','HEAD')
    end

    def need_migrate?
      @need_migrate
    end

    def need_bundle_install?
      @need_bundle
    end

    def need_pod?
      @need_pod
    end

    def need_npm?
      @need_npm
    end

  end
end