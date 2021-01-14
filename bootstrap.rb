# frozen_string_literal: true

require 'bundler/setup'
require 'codebreaker'

require 'i18n'

require_relative 'config/application'
require_relative 'lib/modules/statistics'
require_relative 'lib/states/console_state'
require_relative 'lib/states/game_menu_state'
require_relative 'lib/states/game_registration_state'
require_relative 'lib/states/game_state'
require_relative 'lib/states/game_won_state'
require_relative 'lib/states/game_lost_state'
require_relative 'lib/console'
