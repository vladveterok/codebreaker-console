# frozen_string_literal: true

# game paths
require 'yaml/store'
require 'pathname'
require_relative 'modules/validation'
require_relative 'modules/file_loader'
require_relative 'codebreaker/user'
require_relative 'codebreaker/game'
require_relative 'codebreaker/matchmaker'

# console paths
require 'i18n'
require_relative 'config/application'
require_relative 'console/modules/statistics'
require_relative 'console/states/console_state'
require_relative 'console/states/game_menu_state'
require_relative 'console/states/game_registration_state'
require_relative 'console/states/game_state'
require_relative 'console/states/game_won_state'
require_relative 'console/states/game_lost_state'
