# frozen_string_literal: true

require 'bundler/setup'
require 'codebreaker'

require 'i18n'

require_relative 'config/application'
require_relative 'console/modules/statistics'
require_relative 'console/states/console_state'
require_relative 'console/states/game_menu_state'
require_relative 'console/states/game_registration_state'
require_relative 'console/states/game_state'
require_relative 'console/states/game_won_state'
require_relative 'console/states/game_lost_state'
require_relative 'console/console'
